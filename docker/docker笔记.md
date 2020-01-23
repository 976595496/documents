# docker笔记

## 安装

### centOS7

```shell
yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine
```

```shell
yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
```

```shell
yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
```

```shell
yum install docker-ce docker-ce-cli containerd.io
```

指定版本安装

```shell
yum list docker-ce --showduplicates | sort -r
已加载插件：fastestmirror
可安装的软件包
 * updates: mirror.bit.edu.cn
Loading mirror speeds from cached hostfile
 * extras: mirror.bit.edu.cn
docker-ce.x86_64            3:19.03.5-3.el7                     docker-ce-stable
docker-ce.x86_64            3:19.03.4-3.el7                     docker-ce-stable
docker-ce.x86_64            3:19.03.3-3.el7                     docker-ce-stable
docker-ce.x86_64            3:19.03.2-3.el7                     docker-ce-stable
docker-ce.x86_64            3:19.03.1-3.el7                     docker-ce-stable
```

```shell
yum install docker-ce-18.06.3.ce
```

配置阿里镜像加速器

```shell
vim /etc/docker/daemon.json
```

```json
{
  "registry-mirrors": [
      "https://******.mirror.aliyuncs.com"
      ]
}
```

<img src="./pic/1.png" />

<img src="./pic/2.png" />

<img src="./pic/3.png" />



## 操作笔记

### 命令

* --help

  帮助参数, 查看命令内容

  ```shell
  docker --help
  docker <command> --help
  ```

  

* run

  -i: 启动交互模式

  -t:打开控制台 

  -d: 后台启动

  -p:  `-p 8888:8080` 指定端口 8888 表示 docker 端口, 8080 表示容器端口, 理解为外部通过 8888 访问映射容器的 8080 端口

  -P: 随机分配端口

  -v: 容器数据卷

  

  --name: 起别名

  一般-i 和 -t一起使用, 但不加-p 属于前台启动容器, 当使用 exit 退出时,容器也就关闭了 可以使用`ctl+P+Q` 退出保证容器不关闭, 或者直接使用-p 后台运行容器

  ```shell
  docker run -it --name mycentos centos:7  #交互模式前台启动容器, 随机生成一个容器 id
  ```

  <img src="./pic/5.png" />

  此时操作控制台在 mycentos 容器中, 使用`ctl+P+Q` 退出不关闭容器

  <img src="./pic/4.png" />

  ```shell
  docker attach a1dd917a9b57  #进入容器交互模式
  ```

  

  ```shell
  docker run -d --name mycentos1 centos:7 #后台运行启动容器
  ```

  

* commit 将本地容器重新打包成一个新的镜像

  ```shell
  docker commit -a="作者" -m="备注" f79889df69fb zcz/tomcat:1
  ```

  f79889df69fb是本地容器id    zcz/tomcat:1新的容器名和 tag

* exec  宿主机通过 docker 执行容器内部命令

  ```shell
  docker exec #{containerId} #{command}
  ```

* cp 从容器内拷贝文件到主机

  ```
  docker cp #{containerId:容器内路径} 目的主机路径 
  ```

  

* inspect 以 json 串格式查看容器

  ```shell
  docker inspect #{containerId} 
  ```

  

* attach 重新进入容器

  ```shell
  docker attach #{containerId} 
  ```

  

* 

### 容器数据卷

* 概念
  * docker 容器数据持久化
  * docker 容器间间数据共享或 与主机间的数据共享

* 使用容器数据卷的方式

  * 命令添加

    ```shell
    docker run -it -v  #{/宿主机绝对目录}:#{/容器内目录:ro} --privileged=true #{镜像名}
    ```

    :ro 可选参数  表示 read-only 只读

    --privileged=true 可选参数, Docker 挂在主机目录 Docker 访问出现 cannot open directory.:Permission denied 时增加此参数

  *  dockerFile添加

    ```shell
    docker build -f #{Dockerfile} -t #{imageName:tag} .
    ```

    **注意最后的点表示路径** 

    ```shell
    FROM centos:7
    VOLUME ["/share-data1", "/share-data2"]
    CMD echo "finish.....success"
    CMD /bin/bash
    ```

    

* 数据卷容器

  `命名的容器挂载数据卷`, 其它容器通过`挂载这个(父容器)`实现数据共享, 挂载数据卷的容器, 程志文数据卷容器

  容器间的数据共享与传递

  ```shell
  docker run -it --name #{containerName} --volumes-from #{FromContainerName} #{imageName}
  ```

  

### dockerfile

* **Dockerfile 是用来构建 Docker 镜像的构建文件, 是由一系类命令和参数构成的脚本**

* Dockerfile中每条指令都会创建一个新的镜像层, 并对镜像进行提交

* Dockerfile 执行流程
  * docker 从基础镜像运行一个容器
  * 执行一条指令并对容器作出修改
  * 执行类似 docker commit 的操作提交一个新的镜像层
  * docker 再给予刚提交的镜像运行一个新容器
  * 执行 dockerfile 中的下一条指令知道所有指定都执行完成

* docker 保留字指令

  * `FROM` 基础镜像,当前新镜像是基于哪个镜像的

    最基本的镜像`scratch`

  * `MAINTAINER` 镜像维护者的信息

  * `RUN` 容器构建时需要运行的命令

  * `EXPOSE` 当前容器运行后对外暴露的端口

  * `WORKDIR` 指定当前镜像启动后的容器, 控制台进入容器的工作目录

  * `ENV` 用来构建镜像设置环境变量

  * `ADD` 将宿主机目录下的文件拷贝进镜像且 ADD 命令会自动处理 URL 和解压缩 tar 压缩包

  * `COPY` 类似于 ADD, 拷贝文件和目录到镜像, 但不做处理

    `COPY src dest` 或COPY ["src", "dest"]

  * `VOLUME` 容器数据卷

  * `CMD` 指定容器启动时要运行的命令; Dockerfile 中可以有多个 CMD 指定, 但只有最后一个生效, CMD 会被 docker run 之后的参数替换 

  * `ENTRYPOINT` 指定容器启动是要运行的命令; 不会被覆盖

  * `ONBUILD` 当构建一个被继承的 Dockerfile 时运行命令, 当前镜像的ONBUILD指定在被其它镜像继承构建时触发

    | BUILD             | BOTH    | RUN        |
    | ----------------- | ------- | ---------- |
    | FROM              | WORKDIR | CMD        |
    | MAINTAINER        | USER    | ENV        |
    | COPY              |         | EXPOSE     |
    | ADD               |         | VOLUME     |
    | RUN               |         | ECTRYPOINT |
    | ONBUILD           |         |            |
    | .dockerfileignore |         |            |

* 联系 1

  ```shell
  FROM centos:7
  MAINTAINER zcz<youya_cz@163.com>
  
  ENV workdir=/workdir
  RUN mkdir -p  $workdir
  RUN yum install -y net-tools
  RUN yum install -y vim
  
  WORKDIR $workdir
  
  EXPOSE 80
  CMD echo "====success===="
  CMD /bin/bash
  ```

  ```shell
  docker build -f /opt/container/mycentosDockerfile -t mycentos:1.0 .
  ```

  ```shell
  docker run -it --name mycentos mycentos:1.0
  ```

  <img src="./pic/6.png" />

* 练习 2 CMD 与 ENTRYPOINT

  ```shell
  FROM centos:7
  
  MAINTAINER zcz<youya_cz@163.com>
  
  RUN ["yum","install", "-y", "curl"]
  
  
  CMD ["echo", "====success==="]
  ENTRYPOINT ["curl", "-s", "https://ip.cn/"]
  ```

  ```shell
  docker build -f /opt/container/Dockerfile3 -t myip
  ```

  <img src="./pic/8.png" />



## 安装案例

### mysql

```shell
docker pull mysql:5.7
docker run -p 3306:3306 --name mysql5.7 -v /test/mysql/conf:/etc/mysql/conf.d -v /test/mysql/data:/var/lib/mysql -v /test/mysql/logs:/logs -e MYSQL_ROOT_PASSWORD=zcz920518 -d mysql:5.7
docker exec -it #{containerId} /bin/bash
```

进入容器

```shell
mysql -uroot -p
```

