wkwebview 本地资源替换


----

##GCDWebServer

这个是一个第三方的库

###使用方法

1.创建`GCDWebServer`,
2.设置根目录，这里的根目录既可以是`[NSBundle mainBundle].bundlePath`，也可以是`NSHomeDirectory()`
3.进行请求地址替换，这里有两种情况
`http://localhost:8081/Documents/video.mp4`
`http://localhost:8080/6980f7dc69b54574928648705a0f7273.jpeg`
如果是第一种，那么资源必须存在在根目录下面的`Documents `文件夹，并且命名为`video.mp4 `
如果是第二种，（假如GET请求）那么需要实现方法
```
- (void)addDefaultHandlerForMethod:(NSString*)method requestClass:(Class)aClass asyncProcessBlock:(GCDWebServerAsyncProcessBlock)block
```
并在回调中根据拦截的url中参数，结合自定义参数，进行自定义的资源查找，并返回`GCDWebServerResponse`对象，这个对象的类型有很多种
如果两种url同时存在，那么就需要创建两个server

###特点

功能强大，开发成本低，开发友好
不能拦截所有的请求

##NSURLProtocol

由于业务的特殊性，发现上面的方式不能拦截到部分请求，上面的方法已经不能满足需要，这里祭出`NSURLProtocol `大法

###使用方法

1.新建一个继承自`NSURLProtocol`的协议
2.在方法中进行需要拦截的url判断，并过滤已经处理过的请求，避免循环请求
```
+ (BOOL )canInitWithRequest:(NSURLRequest *)request
```
如果需要自定义增加或修改参数，可以在这个方法里进行修改
```
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
```
3.当需要处理的请求发出时，会走到这个方法里,首先要对进行处理的请求进行标记，然后根据业务需要实现自定义的逻辑
```
- (void )startLoading
```
4.由于`WKWebView`本身不支持`NSURLProtocol`,所以这里创建了一个分类，找到里面的`browsingContextController`来完成注册
5.在使用的地方注册自定义的`protocol`,并在自定义协议中注册需要拦截的协议头
```
[NSURLProtocolregisterClass:[MPWKURLProtocolclass]];
[MPWKURLProtocolwk_registerScheme:@"https"];
```
6.使用完毕记得解除注册，这里是全局生效的

###注意事项

无需对url进行修改
能够拦截到所有请求
但是只要被拦截，就会丢弃请求的body信息，所以需要根据业务场景，适时开启并关闭。控制不慎，影响广泛
采用了私有api，有审核被拒风险
开发麻烦，自己需要处理很多事情，例如管理请求标记


##WKURLSchemeHandler

这个是iOS11中新增加的，系统提供的api，可以用来进行请求拦截
###使用方法
1.创建一个遵循`WKURLSchemeHandler`协议的帮助类
2.根据业务需求实现仅有的两个代理，这里不需要像`NSURLProtocol`一样对处理过的请求进行标记
```
///开始请求
- (void)webView:(WKWebView *)webView startURLSchemeTask:(id <WKURLSchemeTask>)urlSchemeTask;
///停止请求
- (void)webView:(WKWebView *)webView stopURLSchemeTask:(id <WKURLSchemeTask>)urlSchemeTask;

```
3.创建帮助类，并在初始化`WKWebViewConfiguration`时，调用其方法`[config setURLSchemeHandler:(handler) forURLScheme:@"bz"];`完成设置

###注意事项

这里拦截的请求，只能是自定义协议。也就是说，HTTP、HTTPS、FTP等是不能拦截的，否则闪退报错
无需对url进行修改
具备代码简洁，侵入后影响范围小，系统函数安全的特点
系统版本要求高


|| ||WKURLSchemeHandler||NSURLProtocol||GCDWebServer||
||系统版本||iOS 11 以后||无限制||无限制||
||内置级别||系统提供||私有api||第三方库||
||协议级别||只能使用自定义协议||不限||不限||
||请求方式||url拦截||url拦截||需先替换url为localhost||
||优点||官方提供，安全，无审核被拒风险||能够拦截到HTML里所有的请求||集成简单，使用方便||
||缺点||1.版本较高2.只能拦截自定义的协议头3.拦截后会丢弃请求中的body内容||1.全局生效，需注意使用场景2.拦截后会丢弃请求中的body内容											3.采用私有api，有一定的审核风险||1.需要预先替换请求地址2.部分请求无法拦截，比如header中的请求||


###效果

![拦截前](https://github.com/Bourbon404/WKWebview_Resource_Replace/raw/master/before.png)
![拦截后](https://github.com/Bourbon404/WKWebview_Resource_Replace/raw/master/after.png)
