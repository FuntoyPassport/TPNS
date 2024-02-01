// The Swift Programming Language
// https://docs.swift.org/swift-book

import XG_SDK_Cloud

public protocol TPNSDelegate: AnyObject {
    /// 注册推送服务成功回调
    /// - Parameters:
    ///   - deviceToken: APNs 生成的Device Token。
    ///   - xgToken: TPNS 生成的 Token，推送消息时需要使用此值。【TPNS 维护此值与APNs 的 Device Token的映射关系】
    ///   - error: 错误信息，若error为nil则注册推送服务成功
    func pushDidRegistered(deviceToken: String?, xgToken: String?, error:Error?)
    
    /// 注册推送服务失败回调
    /// - Parameter error: 注册失败错误信息
    func pushDidFailToRegisterDeviceToken(error:Error?)
    
    /// 注销推送服务回调
    /// - Parameters:
    ///   - isSuccess: 是否注销成功
    ///   - error: 错误信息
    func pushDidFinishStop(isSuccess: Bool, error: Error?)
    
    /// 统一接收消息的回调
    /// - Parameters:
    ///   - notification: 消息对象(有2种类型NSDictionary和UNNotification具体解析参考示例代码)，此回调为前台收到通知消息及所有状态下收到静默消息的回调（消息点击需使用统一点击回调）。区分消息类型说明：xg字段里的msgtype为1则代表通知消息,msgtype为2则代表静默消息,msgtype为9则代表本地通知
    ///   - completionHandler: 待执行函数
    func pushDidReceiveRemoteNotification(_ notification: Any, withCompletionHandler completionHandler: ((UInt) -> Void)?)
    
    /// 统一点击回调
    /// - Parameters:
    ///   - response: 如果iOS 10+/macOS 10.14+则为UNNotificationResponse，低于目标版本则为NSDictionary。区分消息类型说明：xg字段里的msgtype为1则代表通知消息,msgtype为9则代表本地通知
    ///   - completionHandler: 待执行函数
    func pushDidReceiveNotificationResponse(_ response: Any, withCompletionHandler completionHandler: @escaping () -> Void)
    
    /// 角标设置成功回调
    /// - Parameters:
    ///   - isSuccess: 设置角标是否成功
    ///   - error: 错误标识，若设置不成功会返回
    func pushDidSetBadge(_ isSuccess: Bool, error: Error?)
    
    /// 通知授权弹框的回调
    /// - Parameters:
    ///   - isEnable: 用户是否授权
    ///   - error: 错误信息
    func pushDidRequestNotificationPermission(_ isEnable: Bool, error: Error?)
    
    /// TPNS网络连接成功
    func pushNetworkConnected()
    
    /// TPNS网络连接断开
    func pushNetworkDisconnected()
}


public class TPNS: NSObject, XGPushDelegate {
    /// 业务介绍
    public private(set) var des = "TPNS(Funtoy)是聚合三方腾讯云旗下的TPNS业务功能的一个SDK。"
    public private(set) var version = "3.2.5"
    static let pushConfigSaveKey = "FTPushSDKConfig"
    /// 单例管理
    public static let shared = TPNS()
    /// 需要执行的协议
    public weak var delegate: TPNSDelegate?
    /// 群组Identifier
    var appGroupIdentifier: String?
    /// 禁止初始化
    private override init() {}
    
    public static var isTPNSDebug: Bool = false {
        didSet {
            XGPush.defaultManager().isEnableDebug = self.isTPNSDebug
        }
    }
    
    public static var badge: Int? {
        didSet {
            if let badge = badge {
                XGPush.defaultManager().setBadge(badge)
            }
        }
    }
    
    /// 清除推送配置缓存
    public static func clearPushConfig(_ appGroupIdentifier: String) {
        shared.appGroupIdentifier = appGroupIdentifier
        
        if let sharedUserDefaults = UserDefaults(suiteName: appGroupIdentifier),
           let _ = sharedUserDefaults.object(forKey: pushConfigSaveKey) {
            sharedUserDefaults.removeObject(forKey: pushConfigSaveKey)
        }
    }
    
    public static func config(domain: String, accessId:UInt32, accessKey: String) {
        // 保存config数据
        savePushConfig(domain: domain, accessId: accessId, accessKey: accessKey)
        // 集群设置
        XGPush.defaultManager().configureClusterDomainName(domain)
        // 初始化
        XGPush.defaultManager().startXG(withAccessID: accessId, accessKey: accessKey, delegate: shared)
    }
    
    static func savePushConfig(domain: String, accessId:UInt32, accessKey: String) {
        let config = "\(domain)_\(accessId)_\(accessKey)"
        
        if let sharedUserDefaults = UserDefaults(suiteName: shared.appGroupIdentifier) {
            sharedUserDefaults.setValue(config, forKey: pushConfigSaveKey)
        } else {
            print("FC+++++请先进行AppGroup绑定设置!!!")
        }
    }
    
    /// 添加通知账号
    /// - Parameter account: 番糖通行证账号，不区分类型
    public static func upsertAccounts(_ account: String) {
        // 不区分类型统一均为番糖账号，类型值为1
        XGPushTokenManager.default().upsertAccounts(byDict: [NSNumber(1) : account])
    }
    
    /// 清除所有设置的账号
    public static func clearAccounts() {
        XGPushTokenManager.default().clearAccounts()
    }
}

// MARK: XGPushDelegate
extension TPNS {
    public func xgPushDidRegisteredDeviceToken(_ deviceToken: String?, xgToken: String?, error: Error?) {
        delegate?.pushDidRegistered(deviceToken: deviceToken, xgToken: xgToken, error: error)
    }
    
    public func xgPushDidFailToRegisterDeviceTokenWithError(_ error: Error?) {
        delegate?.pushDidFailToRegisterDeviceToken(error: error)
    }
    
    public func xgPushDidFinishStop(_ isSuccess: Bool, error: Error?) {
        delegate?.pushDidFinishStop(isSuccess: isSuccess, error: error)
    }
    
    public func xgPushDidReceiveRemoteNotification(_ notification: Any, withCompletionHandler completionHandler: ((UInt) -> Void)? = nil) {
        delegate?.pushDidReceiveRemoteNotification(notification, withCompletionHandler: completionHandler)
    }
    
    public func xgPushDidReceiveNotificationResponse(_ response: Any, withCompletionHandler completionHandler: @escaping () -> Void) {
        delegate?.pushDidReceiveNotificationResponse(response, withCompletionHandler: completionHandler)
    }
    
    public func xgPushDidSetBadge(_ isSuccess: Bool, error: Error?) {
        delegate?.pushDidSetBadge(isSuccess, error: error)
    }
    
    public func xgPushDidRequestNotificationPermission(_ isEnable: Bool, error: Error?) {
        delegate?.pushDidRequestNotificationPermission(isEnable, error: error)
    }
    
    public func xgPushNetworkConnected() {
        delegate?.pushNetworkConnected()
    }
    
    public func xgPushNetworkDisconnected() {
        delegate?.pushNetworkDisconnected()
    }
}
