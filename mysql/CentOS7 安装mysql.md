# CentOS 安装mysql

## yum 安装

**1.下载mysql源安装包**

$ wget <http://dev.mysql.com/get/mysql57-community-release-el7-8.noarch.rpm>

 

**2.安装mysql源**

$ yum localinstall mysql57-community-release-el7-8.noarch.rpm 

 

**3.检查mysql源是否安装成功**

$ yum repolist enabled | grep "mysql.*-community.*"

 

**4.安装MySQL** 

这一步才是真正安装mysql

$ yum install -y mysql-community-server

 

**6.启动MySQL服务并设置开机启动**

$ systemctl start mysqld

$ systemctl enable mysqld

$ systemctl daemon-reload

 

**7.端口开放**

$ firewall-cmd --zone=public --add-port=3306/tcp --permanent

$ firewall-cmd --reload

 

**8.修改root本地登录密码**

 1）查看mysql密码

$ grep 'temporary password' /var/log/mysqld.log

$ mysql -uroot -p

3）修改密码【注意：后面的分号一定要跟上】

mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY 'password';

或者：

mysql> set password for 'root'@'localhost'=password('password'); 

**mysql5.7会提示错误 Your password does not satisfy the current policy requirements**

查看密码策略

```mysql
msyql>  SHOW VARIABLES LIKE 'validate_password%'; 
```

![](./mysql/1.png)

设置允许使用简单密码策略    

```mysql
mysql> set global validate_password_policy=LOW;
```

设置密码长度为4位长度(最小设置为4位)

```mysql
mysql> set global validate_password_length=1; 
```

**9.添加远程登录用户**

```mysql
GRANT ALL PRIVILEGES ON *.* TO 'username'@'%' IDENTIFIED BY 'password' WITH GRANT OPTION;
```



## tar包安装

1. 卸载MariaDB

   ```shell
   # rpm -qa|grep mariadb
   mariadb-5.5.56-2.el7.x86_64
   
   # yum remove -y mariadb-5.5.56-2.el7.x86_64
   ```

   

2. 安装libaio 依赖

   ```shell
   # yum install -y libaio 
   ```

   

3. 解压安装包到指定目录

   ```shell
   # tar -zxvf mysql-5.7.21-linux-glibc2.12-x86_64.tar.gz -C /usr/local/
   # cd /usr/local/
   # mv mysql-5.7.21-linux-glibc2 mysql
   ```

   

4. 创建mysql用户和用户组

   ```shell
   # groupadd mysql
   # useradd -g mysql mysql
   # passwd mysql
   ```

   

5. 修改mysql目录所属用户为mysql

   ```shell
   # chown -R mysql:mysql mysql
   ```

   

6. 修改配置文件/

   ```shell
   # vim /support-files/mysql.server
   ```

   ```shell
   basedir=/usr/local/mysql
   datadir=/usr/local/mysql/data
   mysqld_pid_file_path=/usr/local/mysql/data/mysql.pid
   ```

   ```shell
   cp /support-files/mysql.server /etc/init.d/mysqld
   ```

   

7. 初始化mysql

   ```shell
   ./bin/mysqld --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data --initialize
   ```

   控制台会出现root 初始化密码

8. 使用初始化密码登录mysql

   ```shell
   bin/mysql -u root -p
   ```

   ![](./mysql/2.png)

9. 修改root 初始化密码

   ```mysql
   > alter user 'root'@'localhost' identified by 'newPassword';
   > flush privileges;
   ```

   

10. 增加外网访问用户

    ```mysql
    > grant all privileges on *.* to 'hive'@'%' identifyed by 'hive' with grant option;
    > flush privileges;
    ```

11. 查看用户情况

    ```mysql
    > select user, host from mysql.user;
    ```

    ![](./mysql/3.png)

12.使用navicat在外网访问

![](mysql/4.png)

 



![](mysql/5.png)

  

## 配置主从复制

### 主备库

1. 如果主库有数据, 将主库数据同步到备库
2. 在每台服务器上创建复制账号
3. 配置主库和备库
4. 通知备库连接到主库并从主库复制数据

步骤如下:

1. 如果主库有数据执行

   ```shell
   #主库服务器
   mysqldump -uroot -p --all-databases > sqlfile.sql
   ```

   ```sql
   -- 主库客户端
   source /sqlfile.sql
   ```

2. 创建用户并给予相应权限

   主库和备库都创建

   ```sql
   GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO repl@'%' IDENTIFIED BY 'zcz920518';
   ```

3. 配置主库和备库

   ```ini
   #主
   #开启bin-log日志
   log_bin=mysql-bin
   #为mysql设置一个服务id
   server_id=10
   ```

   

   ```ini
   #备
   #开启bin-log日志
   log_bin=mysql-bin
   #为mysql设置一个服务id
   server_id=11
   #启动备库的中继日志
   relay_log=/var/lib/mysql/log/mysql-relay-bin 
   #记录备库执行同步的更新操作
   log_slave_updates=1
   read_only=1
   ```

   ```shell
   #修改relay-log目录用户组权限为mysql
   chown -R mysql:mysql /var/lib/mysql/log/
   ```

   重启主从库, 主库执行show master status 查看检查bin-log创建

   ```sql
   mysql> show master status;
   +------------------+----------+--------------+------------------+-------------------+
   | File             | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
   +------------------+----------+--------------+------------------+-------------------+
   | mysql-bin.000003 |      154 |              |                  |                   |
   +------------------+----------+--------------+------------------+-------------------+
   ```

   

4. 启动复制

   ```sql
   CHANGE MASTER TO MASTER_HOST='server1', 
   MASTER_USER='repl', 
   MASTER_PASSWORD='zcz920518', 
   MASTER_LOG_FILE='mysql-bin.000003', 
   MASTER_LOG_POS=0;
   ```

   MASTER_LOG_POS参数被设置为0, 因为要从日志的开头读起

   ```sql
    检查复制是否正在执行
   show slave status;
   ```

   ```sql
   开始复制
   start slave;
   ```

   

   