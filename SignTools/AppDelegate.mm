//
//  AppDelegate.mm
//  SignTools
//
//  Created by MacXK on 2025/6/15.
//

#import "AppDelegate.h"
#import "SignTools.h"

@interface NSAlert (RunModal)
+ (NSInteger)runAlertWithTitle:(NSString *)title message:(NSString *)message defaultButton:(NSString *)defaultButton alternateButton:(NSString *)alternateButton otherButton:(NSString *)otherButton;
@end

@implementation NSAlert (RunModal)
+ (NSInteger)runAlertWithTitle:(NSString *)title message:(NSString *)message defaultButton:(NSString *)defaultButton alternateButton:(NSString *)alternateButton otherButton:(NSString *)otherButton
{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:title];
    [alert setInformativeText:message];
    
    if (defaultButton)
        [alert addButtonWithTitle:defaultButton];
    if (alternateButton)
        [alert addButtonWithTitle:alternateButton];
    if (otherButton)
        [alert addButtonWithTitle:otherButton];
    
    return [alert runModal];
}
@end

@implementation AppDelegate
@synthesize window;

//
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
	return YES;
}

// 创建UI元素
- (void)setupUI
{
	// 创建主窗口 - 增加窗口高度以容纳日志区域
	self.window = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 500, 500)
											  styleMask:NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable
												backing:NSBackingStoreBuffered
												  defer:NO];
	[self.window setTitle:@"SignTools"];
	[self.window center];
	
	// 创建文本字段和标签
	NSTextField *pathLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 460, 100, 20)];
	[pathLabel setStringValue:NSLocalizedString(@"IPA路径:", nil)];
	[pathLabel setBezeled:NO];
	[pathLabel setDrawsBackground:NO];
	[pathLabel setEditable:NO];
	[pathLabel setSelectable:NO];
	
	pathField = [[NSTextField alloc] initWithFrame:NSMakeRect(120, 460, 280, 20)];
	[pathField setPlaceholderString:NSLocalizedString(@"拖拽IPA文件到这里或点击浏览按钮", nil)];
	
	NSTextField *dylibLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 420, 100, 20)];
	[dylibLabel setStringValue:NSLocalizedString(@"动态库/框架:", nil)];
	[dylibLabel setBezeled:NO];
	[dylibLabel setDrawsBackground:NO];
	[dylibLabel setEditable:NO];
	[dylibLabel setSelectable:NO];
	
	dylibField = [[NSTextField alloc] initWithFrame:NSMakeRect(120, 420, 280, 20)];
	[dylibField setPlaceholderString:NSLocalizedString(@"可选：选择要注入的动态库或框架", nil)];
	
	// 创建按钮
	browseButton = [[NSButton alloc] initWithFrame:NSMakeRect(410, 460, 70, 20)];
	[browseButton setTitle:NSLocalizedString(@"浏览", nil)];
	[browseButton setBezelStyle:NSBezelStyleRounded];
	[browseButton setTarget:self];
	[browseButton setAction:@selector(browse:)];
	
	browseDylibButton = [[NSButton alloc] initWithFrame:NSMakeRect(410, 420, 70, 20)];
	[browseDylibButton setTitle:NSLocalizedString(@"浏览", nil)];
	[browseDylibButton setBezelStyle:NSBezelStyleRounded];
	[browseDylibButton setTarget:self];
	[browseDylibButton setAction:@selector(browseDylib:)];
	
	NSButton *helpButton = [[NSButton alloc] initWithFrame:NSMakeRect(20, 380, 70, 20)];
	[helpButton setTitle:NSLocalizedString(@"帮助", nil)];
	[helpButton setBezelStyle:NSBezelStyleRounded];
	[helpButton setTarget:self];
	[helpButton setAction:@selector(showHelp:)];
	
	resignButton = [[NSButton alloc] initWithFrame:NSMakeRect(410, 380, 70, 20)];
	[resignButton setTitle:NSLocalizedString(@"签名", nil)];
	[resignButton setBezelStyle:NSBezelStyleRounded];
	[resignButton setTarget:self];
	[resignButton setAction:@selector(resign:)];
	
	// 创建进度指示器
	flurry = [[NSProgressIndicator alloc] initWithFrame:NSMakeRect(240, 380, 20, 20)];
	[flurry setStyle:NSProgressIndicatorStyleSpinning];
	[flurry setDisplayedWhenStopped:NO];
    
    // 创建日志区域标签
    logLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 340, 100, 20)];
    [logLabel setStringValue:NSLocalizedString(@"日志", nil)];
    [logLabel setBezeled:NO];
    [logLabel setDrawsBackground:NO];
    [logLabel setEditable:NO];
    [logLabel setSelectable:NO];
    
    // 创建日志文本视图
    logScrollView = [[NSScrollView alloc] initWithFrame:NSMakeRect(20, 20, 460, 310)];
    [logScrollView setBorderType:NSBezelBorder];
    [logScrollView setHasVerticalScroller:YES];
    [logScrollView setHasHorizontalScroller:NO];
    [logScrollView setAutohidesScrollers:YES];
    
    logTextView = [[NSTextView alloc] initWithFrame:[[logScrollView contentView] bounds]];
    [logTextView setMinSize:NSMakeSize(0.0, 0.0)];
    [logTextView setMaxSize:NSMakeSize(FLT_MAX, FLT_MAX)];
    [logTextView setVerticallyResizable:YES];
    [logTextView setHorizontallyResizable:NO];
    [logTextView setAutoresizingMask:NSViewWidthSizable];
    [logTextView setEditable:NO];
    [logTextView setRichText:NO];
    [[logTextView textContainer] setContainerSize:NSMakeSize(logScrollView.contentSize.width, FLT_MAX)];
    [[logTextView textContainer] setWidthTracksTextView:YES];
    
    [logScrollView setDocumentView:logTextView];
	
	// 添加元素到窗口
	NSView *contentView = [self.window contentView];
	[contentView addSubview:pathLabel];
	[contentView addSubview:pathField];
	[contentView addSubview:dylibLabel];
	[contentView addSubview:dylibField];
	[contentView addSubview:browseButton];
	[contentView addSubview:browseDylibButton];
	[contentView addSubview:helpButton];
	[contentView addSubview:resignButton];
	[contentView addSubview:flurry];
    [contentView addSubview:logLabel];
    [contentView addSubview:logScrollView];
}

// 添加日志消息
- (void)addLogMessage:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", message]];
        [[self->logTextView textStorage] appendAttributedString:attrString];
        [self->logTextView scrollRangeToVisible:NSMakeRange([[self->logTextView string] length], 0)];
    });
}

// 清空日志
- (void)clearLog
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self->logTextView textStorage] setAttributedString:[[NSAttributedString alloc] initWithString:@""]];
    });
}

//
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// 设置应用程序为主应用程序
	[NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
	[NSApp activateIgnoringOtherApps:YES];
	
	// 请求完全磁盘访问权限
	NSString *part1 = @"SignTools需要访问您的文件以进行IPA签名和处理。\n\n请在";
	NSString *part2 = @"系统偏好设置";
	NSString *part3 = @" > ";
	NSString *part4 = @"安全性与隐私";
	NSString *part5 = @" > ";
	NSString *part6 = @"隐私";
	NSString *part7 = @" > ";
	NSString *part8 = @"完全磁盘访问权限";
	NSString *part9 = @"中授予权限。";
	NSString *message = [NSString stringWithFormat:@"%@\"%@\"%@\"%@\"%@\"%@\"%@\"%@\"%@", 
						part1, part2, part3, part4, part5, part6, part7, part8, part9];
	
	NSAlert *alert = [[NSAlert alloc] init];
	[alert setMessageText:@"需要文件访问权限"];
	[alert setInformativeText:message];
	[alert addButtonWithTitle:@"好的"];
	[alert runModal];
	
	// 尝试打开系统偏好设置的隐私页面
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"]];
	
	// 设置UI
	[self setupUI];
	
	[flurry setAlphaValue:0.5];
	defaults = [NSUserDefaults standardUserDefaults];
	
	if ([defaults valueForKey:@"IPA_PATH"])
		[pathField setStringValue:[defaults valueForKey:@"IPA_PATH"]];
	if ([defaults valueForKey:@"DYLIB_PATH"])
		[dylibField setStringValue:[defaults valueForKey:@"DYLIB_PATH"]];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:@"/usr/bin/zip"])
	{
		NSAlert *zipAlert = [[NSAlert alloc] init];
		[zipAlert setMessageText:@"错误"];
		[zipAlert setInformativeText:@"应用程序无法在没有/usr/bin/zip工具的情况下运行"];
		[zipAlert addButtonWithTitle:@"确定"];
		[zipAlert runModal];
		exit(0);
	}
	if (![[NSFileManager defaultManager] fileExistsAtPath:@"/usr/bin/unzip"])
	{
		NSAlert *unzipAlert = [[NSAlert alloc] init];
		[unzipAlert setMessageText:@"错误"];
		[unzipAlert setInformativeText:@"应用程序无法在没有/usr/bin/unzip工具的情况下运行"];
		[unzipAlert addButtonWithTitle:@"确定"];
		[unzipAlert runModal];
		exit(0);
	}
	if (![[NSFileManager defaultManager] fileExistsAtPath:@"/usr/bin/codesign"])
	{
		NSAlert *codesignAlert = [[NSAlert alloc] init];
		[codesignAlert setMessageText:@"错误"];
		[codesignAlert setInformativeText:@"应用程序无法在没有/usr/bin/codesign工具的情况下运行"];
		[codesignAlert addButtonWithTitle:@"确定"];
		[codesignAlert runModal];
		exit(0);
	}
	
	// 显示窗口
	[self.window makeKeyAndOrderFront:nil];
}

//
- (void)browse:(id)sender
{
	NSOpenPanel* openDlg = [NSOpenPanel openPanel];
	
	[openDlg setCanChooseFiles:TRUE];
	[openDlg setCanChooseDirectories:TRUE];
	[openDlg setAllowsMultipleSelection:FALSE];
	[openDlg setAllowsOtherFileTypes:FALSE];
	
	#pragma clang diagnostic push
	#pragma clang diagnostic ignored "-Wdeprecated-declarations"
	if ( [openDlg runModalForTypes:@[@"ipa", @"dylib"]] == NSModalResponseOK )
	{
		NSString* fileNameOpened = [[openDlg filenames] objectAtIndex:0];
		[pathField setStringValue:fileNameOpened];
	}
	#pragma clang diagnostic pop
}

//
- (void)browseDylib:(id)sender
{
	// 在主线程创建和配置面板
	dispatch_async(dispatch_get_main_queue(), ^{
		NSOpenPanel* openDlg = [NSOpenPanel openPanel];
		
		[openDlg setCanChooseFiles:TRUE];
		[openDlg setCanChooseDirectories:TRUE]; // 允许选择目录以支持framework
		[openDlg setAllowsMultipleSelection:FALSE];
		[openDlg setAllowsOtherFileTypes:FALSE];
		
		#pragma clang diagnostic push
		#pragma clang diagnostic ignored "-Wdeprecated-declarations"
		if ([openDlg runModalForTypes:@[@"dylib", @"framework"]] == NSModalResponseOK)
		{
			NSString* fileNameOpened = [[openDlg filenames] objectAtIndex:0];
			// 已经在主线程中，可以直接设置UI控件的值
            [self->dylibField setStringValue:fileNameOpened];
		}
		#pragma clang diagnostic pop
	});
}

//
- (void)showHelp:(id)sender
{
	NSString *title = NSLocalizedString(@"如何使用SignTools", nil);
	
	NSString *part1 = NSLocalizedString(@"SignTools允许您处理和优化iOS应用程序。\n\n", nil);
	NSString *part2 = NSLocalizedString(@"1. 将您的.ipa文件拖到顶部框中，或使用浏览按钮。\n\n", nil);
	NSString *part3 = NSLocalizedString(@"2. 如果需要注入动态库，请在动态库路径框中选择要注入的dylib文件。\n\n", nil);
	NSString *part4 = NSLocalizedString(@"3. 点击签名按钮并等待。处理后的文件将保存在与原始文件相同的文件夹中。", nil);
	
	NSString *content = [NSString stringWithFormat:@"%@%@%@%@", 
						part1, part2, part3, part4];
	
	NSAlert *helpAlert = [[NSAlert alloc] init];
	[helpAlert setMessageText:title];
	[helpAlert setInformativeText:content];
	[helpAlert addButtonWithTitle:NSLocalizedString(@"确定", nil)];
	[helpAlert runModal];
}

//
- (void)resign:(id)sender
{
	[defaults setValue:[pathField stringValue] forKey:@"IPA_PATH"];
	[defaults setValue:[dylibField stringValue] forKey:@"DYLIB_PATH"];
	[defaults synchronize];
	
	[pathField setEnabled:FALSE];
	[browseButton setEnabled:FALSE];
	[resignButton setEnabled:FALSE];
	
	[flurry startAnimation:self];
	
	[self performSelectorInBackground:@selector(resignThread) withObject:nil];
}

//
- (void)resignThread
{
	@autoreleasepool
	{
        [self clearLog];
        
        // 使用带回调的refine方法
        NSString *error = [[[SignTools alloc] init] refine:pathField.stringValue
                                              dylibPath:dylibField.stringValue
                                          withCallback:^(NSString *message) {
                                              [self addLogMessage:message];
                                          }];
        
		[self performSelectorOnMainThread:@selector(resignDone:) withObject:error waitUntilDone:YES];
	}
}

//
- (void)resignDone:(NSString *)error
{
	[pathField setEnabled:TRUE];
	[browseButton setEnabled:TRUE];
	[resignButton setEnabled:TRUE];
	
	[flurry stopAnimation:self];
	
	if (error)
	{
		NSAlert *errorAlert = [[NSAlert alloc] init];
		[errorAlert setMessageText:@"Error"];
		[errorAlert setInformativeText:error];
		[errorAlert addButtonWithTitle:@"OK"];
		[errorAlert runModal];
	}
}

@end

