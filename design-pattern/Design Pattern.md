# Design Pattern

## 分类

###创建型模式

| 名称         | 问题 | 方案 | 效果 |
| ------------ | ---- | ---- | ---- |
| 抽象工厂模式 |      |      |      |
| 工厂方法模式 |      |      |      |
| 建造者模式   |      |      |      |
| 原型模式     |      |      |      |
| 单例模式     |      |      |      |



### 结构型模式

| 名称       | 问题 | 方案 | 效果 |
| ---------- | ---- | ---- | ---- |
| 适配器模式 |      |      |      |
| 组合模式   |      |      |      |
| 装饰模式   |      |      |      |
| 代理模式   |      |      |      |
| 外观模式   |      |      |      |
| 桥接模式   |      |      |      |
| 享元模式   |      |      |      |



###行为型模式

| 名称         | 问题 | 方案 | 效果 |
| ------------ | ---- | ---- | ---- |
| 观察者模式   |      |      |      |
| 策略模式     |      |      |      |
| 责任链模式   |      |      |      |
| 模板方法模式 |      |      |      |
| 命令模式     |      |      |      |
| 迭代器模式   |      |      |      |
| 状态模式     |      |      |      |
| 解释器模式   |      |      |      |
| 中介者模式   |      |      |      |
| 备忘录模式   |      |      |      |
| 访问者模式   |      |      |      |



## 面向对象设计原则

### 单一职责原则

定义: 一个对象应该只包含单一的职责, 并且该职责被完整地封装在一个类中

就一个类而言, 应该仅有一个引起它变化的原因



### 开闭原则

定义: 软件实体应当对扩展开放, 对修改关闭

一个软件模块 或 一个有多个类组成的局部结构 或 一个独立的类 应尽量在不修改原有代码的情况下进行扩展



### 里氏代换原则

定义: 所有引用基类的地方必须能透明地使用其子类的对象



### 依赖倒转原则

定义: 高层模块不应该依赖底层模块, 他们都应该依赖抽象. 抽象不应该依赖于细节, 细节应该依赖于抽象.

依赖倒转原则要求针对接口编程, 不要针对实现编程. 在程序代码中传递参数时或在关联关系中尽量引用层次高的抽象层类, 即 接口, 抽象类进行变量类型声明, 参数类型声明, 方法返回类型声明, 以及数据类型的转换等. 



### 接口隔离原则

定义: 客户端不应该依赖那些它不需要的接口

当一个接口太大时需要将它分割成一些更细小的接口, 使用该接口的客户端仅需要知道与之相关的方法即可. 每一个接口应该承担一种相对独立的角色.



### 合成复用原则

定义: 优先使用对象组合, 而不是通过继承来达到复用的目的.

尽量使用对象的关联关系实现代码复用, 避免使用继承. 通过继承进行复用的问题在于集成复用会破坏系统的封装性, 因为集成会将基类的实现细节暴露给子类, 如果基类发生改变, 子类不得不发生改变.



### 迪米特法则

每一个软件单位对其他单位都只有最少的知识, 而且局限于那些与本单位密切相关的软件单位.

一个软件实体模块应当尽可能少地与其他实体发生相互作用. 避免其中一个模块发生修改时影响其他模块



## 设计模式

### 简单工厂模式
