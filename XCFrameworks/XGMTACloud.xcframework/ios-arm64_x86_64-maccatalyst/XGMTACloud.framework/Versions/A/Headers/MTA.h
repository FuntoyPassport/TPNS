//
//  MTA.h
//  MTA-SDK
//
//  Originally Created by uweiyuan on 2019/7/4.
//  Copyright (c) 2020 TEG of Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 MTA版本号
 */

#define MTA_SDK_VERSION @"2.6.0"

#pragma mark - 接口监控相关数据结构
/**
 接口统计的枚举值
 */
typedef enum {
    /**
     接口调用成功
     */
    MTA_SUCCESS = 0,

    /**
     接口调用失败
     */
    MTA_FAILURE = 1,

    /**
     接口调用出现逻辑错误
     */
    MTA_LOGIC_FAILURE = 2
} MTAAppMonitorErrorType;

/**
 MTA错误码

 - EC_OK: 无错误
 - EC_SERVICE_DISABLE: MTA服务未启动，请检查是否调用[MTA startWithAppkey:]
 - EC_ARGUMENT_INVALID: 参数错误，比如eventID为空，或者在没有结束计时事件的情况下又重新开始计时事件
 - EC_INPUT_LENGTH_LIMIT: 参数过长，详细情况请查看自定义事件API的注释
 */
typedef NS_ENUM(NSInteger, MTAErrorCode) {
    EC_OK = 0,
    EC_SERVICE_DISABLE = -1,
    EC_ARGUMENT_INVALID = 1000,
    EC_INPUT_LENGTH_LIMIT = 1001,
};

#pragma mark - MTA统计功能相关接口
/// MTA核心类
@interface MTA : NSObject

#pragma mark - 获取MTA版本号

/**
获取MTA版本号

@return 返回MTA版本号
*/
+ (NSString *)getSdkVersion;

#pragma mark - 启动MTA

/**
 启动MTA

 @param appkey 从网页申请的appKey
 */
+ (void)startWithAppkey:(NSString *)appkey;

#pragma mark - XG

@end
