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
* Action 恢复能力
  * 在执行 action 的开始和结束时, 可以指定 action 尝试重新执行这个 action, 一旦action 成功开始后失败, 便不会再重试;对于 java Action 是一个特例, 因为在 hadoop 执行 map 时, hadoop 内部会执行重试致使 action 重试恢复
  * 对于 action 开始之前的故障, oozie 可以提供不同的策略应对故障, 
    * 暂时性故障: Oozie将在预定义的时间间隔后重试, 一种操作类型的重试次数和计时器间隔必须在Oozie级别上预先配置。工作流作业可以覆盖此类配置
    * 非暂时性故障: Oozie将暂停工作流程作业，直到手动或程序干预恢复工作流程作业并且重试操作开始或结束为止。管理员或外部管理系统负责在恢复工作流作业之前执行任何必要的清理。
    * 如果失败是错误，并且重试不能解决问题，Oozie将执行该操作的错误转移

- Map-Reduce Action
- Pig Action
- Fs(HDFS) Action
- SSH Action
- Sub-workflow Action
- Java Action