# Netty笔记

<img src="./pic/1.png" />



## Netty 概述

* 原生 NIO 存在的问题
  * NIO 的类库和 API 复杂, 使用麻烦, 需要掌握 `Selector`, `ServerSocketChannel`, `SocketChannel`, `Bytebuffer`等
  * 需要具备其它的额外技能, 要熟悉 JAVA 多线程编程, 因为 NIO 编程涉及到 Reactor 模式, 必须要对多线程和网络编程非常熟悉, 才能编写出高质量的 NIO 程序.
  * 开发工作量和难度非常大: 面对网络问题, 半包读写, 失败缓存等很难处理
  * JDK NIO 使用:难免会出现空轮训的问题, 处理不当可能 CPU 100%



* Netty 优点: Netty 对 JDK 自带的 NIO 进行了封装, 有效的解决了 NIO 的大部分问题
  * 设计优雅: 适合于各种传输类型的统一, API 阻塞和非阻塞 Socket; 基于灵活可扩展的时间模型, 可以清晰的分离关注点; 高度可定制化的线程模型, --单线程, 一个或多个线程池
  * 使用方便, 其他依赖低, JDK5 (Netty3.x)    JDK6(Netty4.x) 就足够了 
  * 高性能, 高吞吐量; 低延迟, 减少资源消耗; 最小化不必要的内存复制
  * 安全: 完整的 SSL/TLS 和 StartTLS 支持
  * 社区活跃



## 线程模型概述

### 传统 I/O 线程模型

<img src="./pic/2.png" />

服务端为每 一个客户端请求 单独开辟一条线成进行业务处理, 效率低, 资源消耗较大

### Reactor 线程模型

Reactor 可以分为三种: `单Reactor单线程`,  `单Reactor 多线程`, `主从Reactor模型(netty 基于此模型)`

<img src="./pic/3.png" />

I/O复用结合线程池, 就是 Reactor 模式设计思想,

* Reactor 模式, 通过一个或多个输入同事传递给服务处理器的模式(基于时间驱动)
* 服务器端程序处理传入的多个请求, 并将他们同步分派到响应的处理线程, 因此 Reactor 模式也叫 Dispatcher 模式
* Reactor 模式使用 I/O复用监听事件, 收到时间后, 分发给某个线程(进程), 这点就是网络服务器高并发处理关键

#### 单Reactor单线程

<img src="./pic/4.png" />

简单易用, 但并发量低, 不能充分利用 CPU, 容易发生阻塞等等问题

#### 单Reactor 多线程

<img src="./pic/5.png" />

* Reator 对象通过 select 监控客户端请求事件, 收到事件后, 通过 dispatch 进行分发
* 如果简历连接请求, 则用 accept 通过连接请求处理, 然后创建一个 Handler 对象进行后续事件
* 如果不是连接请求, 则由 Reactor 分发调用连接对应的 handler 来处理
* handler 只负责响应事件, 不做具体的业务处理, 通过该 read 读取数据后,会分发给后面的 worker 线程处理业务
* worker 线程池会分配独立线程完成真正的业务, 并将结果返回 handler
* handler 收到相应通过 write 返回 client

特点, 有效的提高执行效率, 加大并发量, 但是在接收部分还是单线程, 所以对于大并发量还是容易产生性能瓶颈

#### 主从 Reactor 多线程

<img src="./pic/6.png" />

* Reactor 主线程 MainReactor 对象通过 select 监听连接事件, 收到时间后,通过 Acceptor 处理连接事件
* 当 Acceptor 处理连接事件后, MainReactor 将连接分配给 SubReactor
* SubReactor将连接加入到连接队列进行监听, 并创建 Handler 进行各种事件处理
* 当有新事件发生时, subReactor 就会调用对应的 handler 处理
* handler 通过 read 读取数据, 分发给后面的 worker 线程处理
* work 线程池分配独立的 worker 线程进行业务处理, 并返回结果
* handler 收到相应的结果后, 在通过 send 将结果返回给 client
* Reactor 主线程可以对多个 Reactor 子线程, 及 MainReactor 可以对应多个 SubReactor



### Netty 模型

<img src="./pic/7.png" />

* Netty抽象出两个线程池: BossEventLoopGroup 专门负责接收客户端的连接; WorkerEventLoopGroup 专门负责网络的读写
* BossEventLoopGroup和 WorkerEventLoopGroup类型都是 NioEventLoopGroup
* NioEventLoopGroup 相当于一个事件的循环组, 这个组中含有多个事件循环, 每一个事件循环是 NioEventLoop
* NioEventLoop 表示一个不断循环的执行处理人物的线程, 每个 NioEventLoop 都有一个 selector, 用于监听绑定在其上的 socket 网络通讯
* NioEventLoop 可以有多个线程, 即可以含有多个 NioEventLoop
* 每个 BossNioEventLoop循环的步骤有三部
  * 轮训 accept 事件
  * 处理 accept 事件, 与 client 建立连接, 生成 NioSocketChannel, 并将其注册到某个 workerNioEventLoop 上的 selector
  * 处理任务队列的任务, 即 runAllTasks
* 每个 WorkerNioEventLoop 循环执行的步骤:
  * 轮训 read/write 事件
  * 处理 I/O 事件, 即 read,write 事件, 在对应的 NioSocketChannel 处理
  * 处理任务队列的任务, 即 runAllTasks
* 每个 workerNioEventLoop 处理业务时, 会使用 pipline(管道), pipeLine 中包含了 channel, 即通过 pipeLine 可以获取到对应的通道, 管道中维护了很多的处理器

#### 简单案例

```java
public class NettyServer {

    public static void main(String[] args) throws Exception {
        //bossGroup 只是处理连接请求 workGroup 会做业务处理
        //两个都有持有无限循环
        EventLoopGroup bossGroup = new NioEventLoopGroup();
        EventLoopGroup workGroup = new NioEventLoopGroup();

        try {
            //创建服务器端的启动对象
            ServerBootstrap serverBootstrap = new ServerBootstrap();
            //使用链式编程对启动对象进行设置
            serverBootstrap.group(bossGroup, workGroup)//绑定接收连接组和工作组
                    .channel(NioServerSocketChannel.class) //设置服务端通道使用 NioServerSocketChannel
                    .option(ChannelOption.SO_BACKLOG, 128)//设置线程队列得到连接个数
                    .childOption(ChannelOption.SO_KEEPALIVE, true) //设置保持活动连接状态
                    .childHandler(new ChannelInitializer<SocketChannel>() {
                        //给 pipeLine 设置处理器
                        @Override
                        protected void initChannel(SocketChannel socketChannel) throws Exception {
                            socketChannel.pipeline().addLast(new ServerHandler());
                        }
                    });// 给 workgroup 里的 eventloop对应的管道设置处理器

            //绑定一个端口并同步 返回一个 ChannelFuture 对象
            ChannelFuture channelFuture = serverBootstrap.bind(7000).sync();
            //监听关闭通道
            channelFuture.channel().closeFuture().sync();
        }finally {
            //优雅关闭
            workGroup.shutdownGracefully();
            bossGroup.shutdownGracefully();
        }

    }
}
```

```java
public class ServerHandler extends ChannelInboundHandlerAdapter {
    //读取客户端发送的数据
    //ChannelHandlerContext ctx 上下文对象, 这是一个复杂对象, 内部基本包括所有想要的东西
    //msg 客户端传递的内容,
    @Override
    public void channelRead(ChannelHandlerContext ctx, Object msg) throws Exception {
        //将 msg 强转为 ByteBuf   ByteBuf 是 netty 封装的, 性能优于 nio 的 ByteBuffer
        ByteBuf byteBuf = (ByteBuf) msg;
        System.out.println("客户端: "+byteBuf.toString(CharsetUtil.UTF_8));
    }

    //数据读取结束
    @Override
    public void channelReadComplete(ChannelHandlerContext ctx) throws Exception {
        //做信息返回给客户端
        ctx.writeAndFlush(Unpooled.copiedBuffer("hello...", CharsetUtil.UTF_8));
    }

    //捕获异常
    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) throws Exception {
        cause.printStackTrace();
    }
}
```

```java
public class NettyClient {
    public static void main(String[] args) throws Exception {
        EventLoopGroup workGroup = new NioEventLoopGroup();

        try {

            Bootstrap bootstrap = new Bootstrap();
            bootstrap.group(workGroup)
                    .channel(NioSocketChannel.class)
                    .handler(new ChannelInitializer<SocketChannel>() {

                        @Override
                        protected void initChannel(SocketChannel socketChannel) throws Exception {
                            socketChannel.pipeline().addLast(new ClientHandler());
                        }
                    });

            ChannelFuture channelFuture = bootstrap.connect("127.0.0.1", 7000).sync();

            channelFuture.channel().closeFuture().sync();
        }finally {
            workGroup.shutdownGracefully();
        }


    }
}
```

```java
public class ClientHandler extends ChannelInboundHandlerAdapter {


    @Override
    public void channelActive(ChannelHandlerContext ctx) throws Exception {
        ctx.writeAndFlush(Unpooled.copiedBuffer("hello, I'm client ", CharsetUtil.UTF_8));
    }

    @Override
    public void channelRead(ChannelHandlerContext ctx, Object msg) throws Exception {
        ByteBuf byteBuf = (ByteBuf) msg;
        System.out.println("服务端: "+byteBuf.toString(CharsetUtil.UTF_8));
    }

    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) throws Exception {
        cause.printStackTrace();
    }
}
```

#### 知识点

* EventLoopGroup 默认创建自身所创建的线程数是`当前系统内核数*2`









































