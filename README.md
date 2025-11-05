# ZZJDCookieGetter
这是一个运行在Mac上配合 [青龙面板](https://qinglong.apifox.cn/) 使用的京东Cookie获取的App。

![Home](https://raw.githubusercontent.com/lishuzhi1121/ZZJDCookieGetter/main/images/home.png)

## 主要功能

App内通过WebView登陆京东账号，自动解析青龙面板里需要的京东Cookie的pt_key和pt_pin字段，并发送到青龙面板自动启用。

### 青龙配置

用于配置青龙面板相关的参数，包括服务器地址，客户端ID，密钥等，同时包含一个测试登陆的功能，用来验证青龙配置是否可用。

![settings](https://raw.githubusercontent.com/lishuzhi1121/ZZJDCookieGetter/main/images/settings.png)

### 发送到青龙

用户将获取到的京东Cookie发送到青龙面板并启用它。

## 项目使用

> 说明：使用该项目前，默认你已具备iOS开发或macOS开发相关的基本经验。

#### 1. 克隆该项目到本地，并安装pod，命令如下

```shell
git clone https://github.com/lishuzhi1121/ZZJDCookieGetter.git
cd ZZJDCookieGetter
pod install
```

#### 2. 运行项目

使用Xcode打开 ZZJDCookieGetter.xcworkspace ，设置好签名证书和Bundle ID即可编译运行。

#### 3. 打包DMG（可选）

每次通过Xcode运行实属麻烦至极，如果能像其他App一样，直接安装即用就好了。因此该项目内置了自动化打包脚本，自动化工程使用了fastlane进行构建，因此你需要确保本地的fastlane环境正常。执行如下命令检查：

```shell
fastlane -v
```

![fastlane](https://raw.githubusercontent.com/lishuzhi1121/ZZJDCookieGetter/main/images/fastlane.png)

结果类似上图即说明fastlane环境正常。

##### 3.1 修改fastlane配置

修改fastlane目录里的 `Appfile` 和 `Fastfile` ，需要修改的地方都有注释，将其修改成你的开发者账号相应的值即可。

![fastlane-appfile](https://raw.githubusercontent.com/lishuzhi1121/ZZJDCookieGetter/main/images/fastlane-appfile.png)

![fastlane-fastfile](https://raw.githubusercontent.com/lishuzhi1121/ZZJDCookieGetter/main/images/fastlane-fastfile.png)

#### 3.2 执行打包

到fastlane目录下，执行 `fastlane auto_package` 即可。

执行完成后，如果一切正常，则会在fastlane目录里输出out目录和package目录，接下来自行按需食用即可。🎉

![fastlane-out](https://raw.githubusercontent.com/lishuzhi1121/ZZJDCookieGetter/main/images/fastlane-out.png)

![fastlane-package](https://raw.githubusercontent.com/lishuzhi1121/ZZJDCookieGetter/main/images/fastlane-package.png)


### 后记

一些打包过程中的输出日志

![fastlane-1-start](https://raw.githubusercontent.com/lishuzhi1121/ZZJDCookieGetter/main/images/fastlane-1-start.png)

![fastlane-2-pagckage-done](https://raw.githubusercontent.com/lishuzhi1121/ZZJDCookieGetter/main/images/fastlane-2-pagckage-done.png)

![fastlane-3-notary-start](https://raw.githubusercontent.com/lishuzhi1121/ZZJDCookieGetter/main/images/fastlane-3-notary-start.png)

![fastlane-4-notary-success](https://raw.githubusercontent.com/lishuzhi1121/ZZJDCookieGetter/main/images/fastlane-4-notary-success.png)

![fastlane-5-success](https://raw.githubusercontent.com/lishuzhi1121/ZZJDCookieGetter/main/images/fastlane-5-success.png)
