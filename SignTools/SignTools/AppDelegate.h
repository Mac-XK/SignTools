//
//  AppDelegate.h
//  SignTools
//
//  Created by MacXK on 2025/6/15.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
	NSUserDefaults *defaults;
	
	NSTextField *pathField;
	NSTextField *dylibField;
	
	NSButton *browseButton;
	NSButton *browseDylibButton;
	NSButton *resignButton;
	
	NSProgressIndicator *flurry;
    
    // 日志相关
    NSScrollView *logScrollView;
    NSTextView *logTextView;
    NSTextField *logLabel;
}

@property (strong) NSWindow *window;

- (void)browse:(id)sender;
- (void)browseDylib:(id)sender;
- (void)showHelp:(id)sender;
- (void)resign:(id)sender;

// 日志相关方法
- (void)addLogMessage:(NSString *)message;
- (void)clearLog;

@end

