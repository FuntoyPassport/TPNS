# TPNS
该库用于配合FuntoySDK的脚本执行，接入腾讯的推送通知(TPNS)业务

## 一、文件引入说明：

    1.1：XG_SDK_Cloud.xcframework（TPNS的主SDK，提供接口文件）
    
    1.2：XGExtension.xcframework（“抵达和富媒体”扩展插件库及接口头文件）
    
    1.3：XGInAppMessage.xcframework（应用内消息）
    
    1.4：XGMTACloud.xcframework（“点击上报”组件）

## 二、接入步骤如下：

    2.1：用脚本passport_config_unity_project.rb自动完成TPNSService的相关配置以及关联设置。

    2.2：SPM导入该库后，需要为主添target加"-ObjC"标识。
     
    2.3：APP开启推送权限，【Push Notifications】、【Background Modes -> Remote notifications】。
        
    2.4：配置APP与Service Extension之间的App Groups数据共享。

    2.5：参照demo，接入和实现相关代理方法。
