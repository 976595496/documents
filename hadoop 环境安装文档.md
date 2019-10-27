# hadoop 环境安装文档

## hadoop 



## zookeeper 



## hive 



## sqoop



## flume



## oozie





### 知识点

#### workflow

##### Start Node(开始节点)



##### End Node(结束节点)



##### Kill Node(终止节点)



##### Decision Node (决策路由节点)



##### Fork Node & Join Node(分支节点和合并节点)



#####Action Node (action 节点)

* 由动作节点触发的所有计算/处理任务均由Oozie异步执行
* oozie 提供两种方式检测 Action Node 执行的情况: 回调和轮训
  * 当开始执行 Action Node 时, oozie 会提供一个 `唯一的 URL`, 执行的任务应该调用这个 URL 来通知执行完成
  * 可能由于任何原因, 这个 URL 没有调用成功, oozie 提供了轮训的方式检测完
* Action Node 有两个子属性 `ok`     `error`
  * 当 task 正确完成后会调用 ok
  * 当 task 未能正确完成 会调用 error
  * 如果 task 由于错误退出action，则该计算/处理任务必须 向Oozie 提供`错误代码` 和 `错误消息`信息



