//
//  Wrapper.swift
//  GameDemo
//
//  Created by 哲思 on 2023/11/16.
//

import Foundation
import TPNS

@objc public protocol WrapperDelegate {
    @objc optional func xgPushDidRegistered(deviceToken: String?, xgToken: String?, error: Error?)
    @objc optional func xgPushDidFailToRegisterDeviceToken(error:Error?)
    @objc optional func xgPushDidFinishStop(isSuccess: Bool, error: Error?)
    
    @objc optional func xgPushDidReceiveRemoteNotification(_ notification: Any, withCompletionHandler completionHandler: ((UInt) -> Void)?)
    @objc optional func xgPushDidReceiveNotificationResponse(_ response: Any, withCompletionHandler completionHandler: @escaping () -> Void)
    
    @objc optional func xgPushDidSetBadge(_ isSuccess: Bool, error: Error?)
    @objc optional func xgPushDidRequestNotificationPermission(_ isEnable: Bool, error: Error?)
    @objc optional func xgPushNetworkConnected()
    @objc optional func xgPushNetworkDisconnected()
}

@objcMembers public class Wrapper: NSObject, TPNSDelegate {
    
    private let sdk = TPNS.shared
    public weak var delegate: WrapperDelegate?
    
    fileprivate override init() {
        super.init()
        sdk.delegate = self
    }
}

// !!!: 切记，由于猫工程工程被Unity打包修改，所以该包装器并非直接供包体使用，而是通过UnityFramework动态库链接调用，所以包装器接口必须全部公开给OC编译器调用
public extension Wrapper {
    static let shard = Wrapper()
    
    static func log() {
        print(TPNS.shared.des + "当前版本:" + TPNS.shared.version)
    }
    
    static func openTPNSLog() {
        TPNS.isTPNSDebug = true
    }
    
    static func setBadge(_ num: Int) {
        TPNS.badge = num
    }
    
    static func clearPushConfig(appGroupIdentifier: String) {
        TPNS.clearPushConfig(appGroupIdentifier)
    }

    static func config(domain: String, accessId:UInt32, accessKey: String) {
        TPNS.config(domain: domain, accessId: accessId, accessKey: accessKey)
    }
    
    static func upsertAccounts(_ account: String) {
        TPNS.upsertAccounts(account)
    }
    
    static func clearAccounts() {
        TPNS.clearAccounts()
    }
}

// MARK: 执行SPM中的协议TPNSDelegate
public extension Wrapper {
    func pushDidRegistered(deviceToken: String?, xgToken: String?, error: Error?) {
        delegate?.xgPushDidRegistered?(deviceToken: deviceToken, xgToken: xgToken, error: error)
    }
    
    func pushDidFailToRegisterDeviceToken(error: Error?) {
        delegate?.xgPushDidFailToRegisterDeviceToken?(error: error)
    }
    
    func pushDidFinishStop(isSuccess: Bool, error: Error?) {
        delegate?.xgPushDidFinishStop?(isSuccess: isSuccess, error: error)
    }
    
    func pushDidReceiveRemoteNotification(_ notification: Any, withCompletionHandler completionHandler: ((UInt) -> Void)?) {
        delegate?.xgPushDidReceiveRemoteNotification?(notification, withCompletionHandler: completionHandler)
    }
    
    func pushDidReceiveNotificationResponse(_ response: Any, withCompletionHandler completionHandler: @escaping () -> Void) {
        delegate?.xgPushDidReceiveNotificationResponse?(response, withCompletionHandler: completionHandler)
    }
    
    func pushDidSetBadge(_ isSuccess: Bool, error: Error?) {
        delegate?.xgPushDidSetBadge?(isSuccess, error: error)
    }
    
    func pushDidRequestNotificationPermission(_ isEnable: Bool, error: Error?) {
        delegate?.xgPushDidRequestNotificationPermission?(isEnable, error: error)
    }
    
    func pushNetworkConnected() {
        delegate?.xgPushNetworkConnected?()
    }
    
    func pushNetworkDisconnected() {
        delegate?.xgPushNetworkDisconnected?()
    }
}
