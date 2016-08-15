# NetworkObserver
a useful demo to observer network status for iOS

1、首先去苹果官网下载两个文件Reachability.h和Reachability.m文件，这里苹果提供的关于获取当前网络状态的文件 <br \>

2、生成一个单例类，默认其初始网络状态为unknown

3、设置全局实例变量：<br \>
`@interface NetTestObject () {`<br \>
   `Reachability *_obsearverReach;`<br \>
`}` <br \>
设置网络状态改变回调block<br \>
`@property (copy, nonatomic) NetworkStatusChangedBlock networkStatusChangeBlock;`<br \>
设置只读属性当前网络状态
`@property (assign, nonatomic, readonly) NetTestStatus currentTestStatus;`

4、添加网络状态监视,同时添加网络状态通知接收，此通知在Reachability.m的`static void ReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info){}`方法中被发出

5、接收网络状态消息<br \>
demo中将该对象加入appdelegate中，对象打开app时就会接收到一次通知，而后每次改变网络状态，_obsearverReach对象都会发送过来两次通知，因此我们判断发送过来时的网络状态是否和上次的存储在单例对象中的网络状态是否相同，相同则跳过，不同则激活回调

6、对象销毁时，停止监视网络状态变化，同时remove通知观察