*	更新 yum
	```	shell
	# yum update
	```
	
*	安装依赖包

  ```shell
  yum install -y yum-utils device-mapper-persistent-data lvm2
  ```

*	设置 yum 源

  ```shell
  //中央仓库
  yum-config-manager --add-repo http://download.docker.com/linux/centos/docker-ce.repo
  ```

  或

  ```shell
  //阿里仓库
  yum-config-manager --add-repo http://download.docker.com/linux/centos/docker-ce.repo
  ```

*	查看仓库中 docker 版本列表

  ```shell
  [root@localhost ~]# yum list docker-ce --showduplicates | sort -r
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
  docker-ce.x86_64            3:19.03.0-3.el7                     docker-ce-stable
  docker-ce.x86_64            3:18.09.9-3.el7                     docker-ce-stable
  docker-ce.x86_64            3:18.09.8-3.el7                     docker-ce-stable
  docker-ce.x86_64            3:18.09.7-3.el7                     docker-ce-stable
  docker-ce.x86_64            3:18.09.6-3.el7                     docker-ce-stable
  docker-ce.x86_64            3:18.09.5-3.el7                     docker-ce-stable
  docker-ce.x86_64            3:18.09.4-3.el7                     docker-ce-stable
  docker-ce.x86_64            3:18.09.3-3.el7                     docker-ce-stable
  docker-ce.x86_64            3:18.09.2-3.el7                     docker-ce-stable
  docker-ce.x86_64            3:18.09.1-3.el7                     docker-ce-stable
  docker-ce.x86_64            3:18.09.0-3.el7                     docker-ce-stable
  docker-ce.x86_64            18.06.3.ce-3.el7                    docker-ce-stable
  docker-ce.x86_64            18.06.2.ce-3.el7                    docker-ce-stable
  docker-ce.x86_64            18.06.1.ce-3.el7                    docker-ce-stable
  docker-ce.x86_64            18.06.0.ce-3.el7                    docker-ce-stable
  docker-ce.x86_64            18.03.1.ce-1.el7.centos             docker-ce-stable
  docker-ce.x86_64            18.03.0.ce-1.el7.centos             docker-ce-stable
  docker-ce.x86_64            17.12.1.ce-1.el7.centos             docker-ce-stable
  docker-ce.x86_64            17.12.0.ce-1.el7.centos             docker-ce-stable
  docker-ce.x86_64            17.09.1.ce-1.el7.centos             docker-ce-stable
  docker-ce.x86_64            17.09.0.ce-1.el7.centos             docker-ce-stable
  docker-ce.x86_64            17.06.2.ce-1.el7.centos             docker-ce-stable
  docker-ce.x86_64            17.06.1.ce-1.el7.centos             docker-ce-stable
  docker-ce.x86_64            17.06.0.ce-1.el7.centos             docker-ce-stable
  docker-ce.x86_64            17.03.3.ce-1.el7                    docker-ce-stable
  docker-ce.x86_64            17.03.2.ce-1.el7.centos             docker-ce-stable
  docker-ce.x86_64            17.03.1.ce-1.el7.centos             docker-ce-stable
  docker-ce.x86_64            17.03.0.ce-1.el7.centos             docker-ce-stable
   * base: mirrors.aliyun.com
  ```

*	安装 docker

  ```shell
  yum install docker-ce-18.06.3.ce
  ```

*	启动 docker

  ```shell
  systemctl start docker
  ```

*	修改 docker 镜像源

  ```shell
  vim /etc/docker/daemon.json
  ```

  ```shell
  {
    "registry-mirrors": [
        "https://kfwkfulq.mirror.aliyuncs.com",
        "https://2lqq34jg.mirror.aliyuncs.com",
        "https://pee6w651.mirror.aliyuncs.com",
        "https://registry.docker-cn.com",
        "http://hub-mirror.c.163.com"
        ]
  }
  ```

*	重新加载

  ```shell
  systemctl daemon-reload
  systemctl restart docker
  ```






