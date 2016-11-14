###写在前面
  JSPatch的诞生让iOS平台应用实现热更新变得非常方便, 这是一套服务端+客户端的开源解决方案,让iOS开发者也能很方便的集成JSPatch、搭建服务端,不再需要求助于很忙的服务端开发人员。

=======
###贡献者
沉睡的军哥


=======
###使用步骤

####服务端
1.安装nodejs(自行安装)
 
2.安装sails   
   `npm -g install sails`
         
3.安装pm   
   `npm -g install pm2`
   
4.启动服务端应用   
    ① 生成RSA公钥私钥,参考[http://www.jianshu.com/p/bfa57e049a7e](http://www.jianshu.com/p/bfa57e049a7e)                       
    ② 将jspatchserver放在服务端,将第一步得到的私钥命名为`private_key.pem`, 放入jspatchserver/patch/pem目录下          
    ③ 在jspatchserver/patch/js目录下创建以APP命名(自定)的目录,例如TestAPPName,然后在TestAPPName目录下放入需要修复BUG的js文件,命名格式为patch+版本号.js(例如patch1.0.0.js)   
    ④ 定好要使用的端口号,并映射好域名       
    ⑤ 找到jspatchserver/config/local.js文件, vi打开(或者其他方式), 找到`port: process.env.PORT`这一行,将后面的端口号修改为你在上一步定好的端口号, 例如我要使用端口号8000(`port: process.env.PORT || 8000`)，shift + ':' wq保存退出   
    ⑥ cd到jspatchserver目录下执行`npm install`   
    ⑦ 执行`pm2 start app.js`,启动成功,恭喜你，在浏览器中录入你的域名+端口号/jspatch?version=你要修复的版本号&appName=你APP的命名，例如(`test.patch.com:8000/jspatch?version=1.0.0&appName=TestAPPName`),可以正常看到返回数据,说明环境已通, 你现在可以将需要更新的jspatch(什么?你还没有使用过jspatch, 去这里看看吧[https://github.com/bang590/JSPatch](https://github.com/bang590/JSPatch),还有这里[http://bang590.github.io/JSPatchConvertor/](http://bang590.github.io/JSPatchConvertor/))文件放入jspatchserver/patch/js目录下热修复你的应用了,是不是很简单。   
    
      
 =======   
####客户端  

1.CocoaPods集成   
   
```ruby
# Your Podfile
platform :ios, '6.0'
pod 'QFJSPatch'
```
     
2.使用   
  ①将在服务端使用过程中生成的公钥命名为`public_key.pem`,导入到客户端工程   
  ②在合适的位置引入`#import "QFJSPatch.h"`      
  ③在`didFinishLaunchingWithOptions`中调用`[QFJSPatch execJS];`,   
  在`applicationDidBecomeActive`或者你认为更合的位置调用`[QFJSPatch requestJSWithUrl:@"test.patch.com:8000/jspatch?" appName:@"TestAPPName"];`    
  
  好了,现在你再也不怕线上出BUG了。

**注意：iOS10上需要开启Keychain sharing**   
参考[http://stackoverflow.com/questions/38689631/how-to-use-facebook-ios-sdk-on-ios-10/38799196#38799196](http://stackoverflow.com/questions/38689631/how-to-use-facebook-ios-sdk-on-ios-10/38799196#38799196)

=======

    
###相关阅读
该解决方案与node.js、sails.js、pm2等有关，相关资料如下   
1. [nodejs官方网站](https://nodejs.org)   
2. [sails.js官方网站](https://sailsjs.org)   
3. [pm2](https://github.com/Unitech/pm2)

=======