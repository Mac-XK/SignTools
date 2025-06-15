//
//  main.m
//  SignTools
//
//  Created by MacXK on 2025/6/15.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // 创建应用程序实例
        NSApplication *application = [NSApplication sharedApplication];
        
        // 创建应用程序委托
        AppDelegate *delegate = [[AppDelegate alloc] init];
        [application setDelegate:delegate];
        
        // 运行应用程序
        [application run];
    }
    return 0;
}
