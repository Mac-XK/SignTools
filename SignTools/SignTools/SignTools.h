//
//  SignTools.h
//  SignTools
//
//  Created by MacXK on 2025/6/15.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

// 定义日志回调函数类型
typedef void (^LogCallback)(NSString *message);

@interface SignTools : NSObject {
    NSString *_error;
}

- (NSString *)refine:(NSString *)ipaPath dylibPath:(NSString *)dylibPath;
- (NSString *)refine:(NSString *)ipaPath dylibPath:(NSString *)dylibPath withCallback:(LogCallback)callback;

@end

NS_ASSUME_NONNULL_END
