# redis 安装

## 单机

1. 下载安装包

   ```shell
   $ cd /opt
   $ mkdir software modules
   $ cd /software
   $ wget http://download.redis.io/releases/redis-5.0.4.tar.gz
   ```

2. 解压

   ```shell
   $ tar -zxvf redis-5.0.4.tar.gz -C /opt/modules/
   ```

3. 安装 c依赖

   ```shell
   $ yum install -y gcc-c++
   ```

4. 编译安装

   ```shell
   $ cd redis-5.0.4
   $ make
   $ mkdir -p /opt/modules/redis
   $ make install PREFIX=/opt/modules/redis
   ```

5. 三种启动方式

   ```shell
   $ cd /opt/modules/redis/bin
   ```

   * 前台启动

     ```shell
     $ ./redis-server
     ```

   * 后台启动

     * 设置配置文件

       ```shell
       $ cp /opt/modules/redis-5.0.4/redis.conf /opt/modules/redis/bin/
       $ vim redis.conf
       ```

       修改**daemonize**为 **yes**

       ```shell
       daemonize=yes
       ```

     * 启动

       ```shell
       $ ./redis-server redis.conf
       ```

   * 使用redis启动脚本设置开机自启动

     在解压包中有 utils 文件夹, 文件夹中有一个**redis_init_script**脚本, 这个是启动初始化脚本

     ```shell
     $ cp redis_init_script /etc/init.d/redisd
     $ vim /etc/init.d/redisd
     ```

     ```shell
     #!/bin/sh
     #
     # Simple Redis init.d script conceived to work on Linux systems
     # as it does use of the /proc filesystem.
      
     #redis服务器监听的端口
     REDISPORT=6379
      
     #服务端所处位置
     EXEC=/opt/modules/redis/bin/redis-server
      
     #客户端位置
     CLIEXEC=/opt/modules/redis/bin/redis-cli
      
     #redis的PID文件位置，需要修改
     PIDFILE=/opt/modules/redis/redis_${REDISPORT}.pid
      
     #redis的配置文件位置，需将${REDISPORT}修改为文件名
     CONF="/opt/modules/redis/bin/${REDISPORT}.conf"
      
     case "$1" in
         start)
             if [ -f $PIDFILE ]
             then
                     echo "$PIDFILE exists, process is already running or crashed"
             else
                     echo "Starting Redis server..."
                     $EXEC $CONF
             fi
             ;;
         stop)
             if [ ! -f $PIDFILE ]
             then
                     echo "$PIDFILE does not exist, process is not running"
             else
                     PID=$(cat $PIDFILE)
                     echo "Stopping ..."
                     $CLIEXEC -p $REDISPORT shutdown
                     while [ -x /proc/${PID} ]
                     do
                         echo "Waiting for Redis to shutdown ..."
                         sleep 1
                     done
                     echo "Redis stopped"
             fi
             ;;
         *)
             echo "Please use start or stop as first argument"
             ;;
     esac
     ```

     配置开机启动

     ```shell
     #设置为开机自启动服务器
     chkconfig redisd on
     #打开服务
     service redisd start
     #关闭服务
     service redisd stop
     ```

   单机配置完成
   
6. redis 停止服务

   ```shell
   $ redis-cli shutdown
   ```

   **注意** 对于 redis 的服务停止,最好不要直接 `kull -9` 

   redis 关闭的关闭过程: 断开与客户端的连接, 持久化文件生成, 但如果是直接 kill 掉 redis 服务, 不仅不会做持久化操作, 还会造成缓冲区等资源不能被优雅关闭, 极端情况会造成 AOF 和赋值丢失数据的情况

## N主 N从集群

首先说redis 的集群主节点需要>=3 台的服务器组成, 还需要准备哨兵节点服务器, 这里准备三台 

| ip             | port                 | 职责            |
| -------------- | -------------------- | --------------- |
| 127.16.235.132 | 7001    7002    7003 | 主   从    哨兵 |
| 127.16.235.133 | 7001    7002    7003 | 主   从    哨兵 |
| 127.16.235.134 | 7001    7002    7003 | 主   从    哨兵 |

1. 下载安装包

   ```shell
   $ cd /opt/software
   $ wget http://download.redis.io/releases/redis-5.0.4.tar.gz
   ```

2. 解压到指定目录

   ```shell
   $ tar -zxvf redis-5.0.4.tar.gz -C /opt/modules/
   ```

3. 安装 C 依赖

   ```shell
   $ yum install gcc-c++
   ```

4. 进入文件夹编译到指定安装位置

   ```shell
   $ cd /opt/modules/
   $ mkdir redis
   $ cd redis-5.0.4
   $ make
   $ make install PREFIX=/opt/modules/redis/
   ```

5. 拷贝安装包到安装位置

   ```shell
   $ cp redis.conf ../redis/7001.conf
   $ cp redis.conf ../redis/7002.conf
   ```

6. 修改配置文件

   ```shell
   $ vim 7001.conf
   ```

   ```shell
   
   ```

7. 同时修改 7002.conf

8. 将安装后的文件同步到其他服务器, 并修改响应的配置文件 ip, host

9. 安装 ruby 依赖, 因`redis_trib.rb`这个命令启动集群依赖 ruby 环境

   ```shell
   $ yum install -y ruby //查看当前 redis 所对应的 ruby 版本, 一定要版本匹配
   ```

10. 启动多有 redis 节点

    ```shell
    $ ./redis-server 7001.conf
    $ ./redis-server 7001.conf
    ```

    **注意:** 启动节点时会在执行命令的当前路径创建 nodes, 记录当前启动节点的同步节点数据. 这个一台机器上启动多个节点的方案, 不要再统一路径下启动多个节点, 这样会导致, 后面启动的节点与第一个节点启动冲突而无法启动

11. 启动集群配置

```shell
$ ./redis_trib.rb create -- replicas 1 172.16.235.132:7001 172.16.235.132:7002 172.16.235.133:7001 172.16.235.133:7002 172.16.235.134:7001 172.16.235.134:7002
```

```shell
./redis-cli --cluster create 172.16.235.132:7001 172.16.235.132:7002 172.16.235.133:7001 172.16.235.133:7002 172.16.235.134:7001 172.16.235.134:7002 --cluster-replicas 1
```

这里用的是 redis.5.0.4 版本, 使用r`edis_trib.rb` 创建集群提示建议使用 `redis-cli` , 所以建议使用第二条命令创建集群, 为了保证主节点不落在同一 ip 下, 所以将每个 ip 的不同 port 节点间隔创建集群, 这样, 所有 7002 就是从节点, 7001 都是主节点

## 高可用集群









