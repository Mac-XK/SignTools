# SignTools

[English](#english) | [简体中文](#简体中文)

<img src="screenshot.png" width="500" alt="SignTools Screenshot">

## English

### Overview

SignTools is a macOS application for processing and optimizing iOS IPA files. It allows you to inject dynamic libraries (dylibs) or frameworks into iOS applications and repackage them for installation.

### Features

- Unpack and repackage iOS IPA files
- Inject dylib files or frameworks into iOS applications
- Automatic handling of file dependencies
- Detailed logging of the processing steps
- Simple and intuitive user interface
- Multi-language support (English and Chinese)

### Requirements

- macOS 10.13 or later
- Command line tools: `zip`, `unzip`, `codesign` (installed by default on macOS)
- Full disk access permission (for handling files with special characters)

### Installation

1. Download the latest release from the [Releases](https://github.com/yourusername/SignTools/releases) page
2. Move the SignTools application to your Applications folder
3. When first launching, you may need to grant full disk access permission

### Usage

1. Launch SignTools
2. Drag your IPA file to the top field or use the Browse button
3. (Optional) If you want to inject a dylib or framework, select it using the second field
4. Click the Sign button to process the IPA
5. The processed IPA will be saved in the same folder as the original file

### Language Settings

SignTools supports both English and Chinese languages. The application will automatically use your system's language settings. To change the language:

#### Method 1: Using macOS System Preferences

1. Open System Preferences
2. Go to Language & Region
3. Drag English or Chinese to the top of the Preferred Languages list
4. Restart SignTools

#### Method 2: Using Terminal Command

You can launch SignTools with a specific language using the following Terminal commands:

For English:
```bash
defaults write com.yourusername.SignTools AppleLanguages '("en")'
open /Applications/SignTools.app
```

For Chinese:
```bash
defaults write com.yourusername.SignTools AppleLanguages '("zh-Hans")'
open /Applications/SignTools.app
```

To reset to system default:
```bash
defaults delete com.yourusername.SignTools AppleLanguages
```

### Troubleshooting

If you encounter issues:

1. Make sure you have granted full disk access permission to SignTools
2. Check the log area for detailed information about the process
3. Ensure that the IPA file is not encrypted
4. Verify that the dylib or framework you're trying to inject is compatible with the target application

### For Developers

#### Localization Implementation

SignTools uses standard macOS localization techniques. If you want to contribute or modify the localization:

1. Localized strings are stored in `.lproj` directories (e.g., `en.lproj`, `zh-Hans.lproj`)
2. Each `.lproj` directory contains `Localizable.strings` files
3. Use `NSLocalizedString()` in code to reference localized strings

Example of localization in code:
```objc
// Using localized strings
NSString *message = NSLocalizedString(@"Hello World", nil);

// With comment for translators
NSString *message = NSLocalizedString(@"Hello World", @"Greeting message shown on startup");
```

To add a new language:
1. Create a new `.lproj` directory with the language code (e.g., `fr.lproj` for French)
2. Copy `Localizable.strings` from an existing language folder
3. Translate all string values while keeping the keys unchanged

Example `Localizable.strings` file:
```
/* Button titles */
"Sign" = "Sign";
"Browse" = "Browse";

/* Messages */
"Processing completed" = "Processing completed";
"Error occurred" = "Error occurred";
```

#### Testing Localization

To test your localization without changing system settings:

```bash
# Run app in a specific language
xcrun simctl launch --language=zh-Hans --region=CN com.yourusername.SignTools
```

### License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## 简体中文

### 概述

SignTools 是一款用于处理和优化 iOS IPA 文件的 macOS 应用程序。它允许您将动态库（dylib）或框架（framework）注入到 iOS 应用程序中，并重新打包以供安装。

### 功能特点

- 解包和重新打包 iOS IPA 文件
- 向 iOS 应用程序注入 dylib 文件或框架
- 自动处理文件依赖关系
- 详细记录处理步骤
- 简洁直观的用户界面
- 多语言支持（英文和中文）

### 系统要求

- macOS 10.13 或更高版本
- 命令行工具：`zip`、`unzip`、`codesign`（macOS 默认已安装）
- 完全磁盘访问权限（用于处理带有特殊字符的文件）

### 安装方法

1. 从 [Releases](https://github.com/yourusername/SignTools/releases) 页面下载最新版本
2. 将 SignTools 应用程序移动到应用程序文件夹
3. 首次启动时，您可能需要授予完全磁盘访问权限

### 使用方法

1. 启动 SignTools
2. 将您的 IPA 文件拖到顶部字段或使用浏览按钮选择
3. （可选）如果您想注入动态库或框架，使用第二个字段选择它
4. 点击签名按钮处理 IPA
5. 处理后的 IPA 文件将保存在与原始文件相同的文件夹中

### 语言设置

SignTools 支持英文和中文两种语言。应用程序将自动使用您系统的语言设置。要更改语言：

#### 方法一：使用 macOS 系统偏好设置

1. 打开系统偏好设置
2. 前往语言与地区
3. 将英文或中文拖到偏好语言列表的顶部
4. 重新启动 SignTools

#### 方法二：使用终端命令

您可以使用以下终端命令以特定语言启动 SignTools：

英文：
```bash
defaults write com.yourusername.SignTools AppleLanguages '("en")'
open /Applications/SignTools.app
```

中文：
```bash
defaults write com.yourusername.SignTools AppleLanguages '("zh-Hans")'
open /Applications/SignTools.app
```

重置为系统默认设置：
```bash
defaults delete com.yourusername.SignTools AppleLanguages
```

### 故障排除

如果遇到问题：

1. 确保您已授予 SignTools 完全磁盘访问权限
2. 查看日志区域，了解处理过程的详细信息
3. 确保 IPA 文件未加密
4. 验证您尝试注入的动态库或框架与目标应用程序兼容

### 开发者信息

#### 本地化实现

SignTools 使用标准的 macOS 本地化技术。如果您想贡献或修改本地化：

1. 本地化字符串存储在 `.lproj` 目录中（例如 `en.lproj`、`zh-Hans.lproj`）
2. 每个 `.lproj` 目录包含 `Localizable.strings` 文件
3. 在代码中使用 `NSLocalizedString()` 引用本地化字符串

代码中本地化的示例：
```objc
// 使用本地化字符串
NSString *message = NSLocalizedString(@"Hello World", nil);

// 带有翻译者注释
NSString *message = NSLocalizedString(@"Hello World", @"启动时显示的问候消息");
```

要添加新语言：
1. 创建一个带有语言代码的新 `.lproj` 目录（例如，法语为 `fr.lproj`）
2. 从现有语言文件夹复制 `Localizable.strings`
3. 翻译所有字符串值，同时保持键不变

`Localizable.strings` 文件示例：
```
/* 按钮标题 */
"Sign" = "签名";
"Browse" = "浏览";

/* 消息 */
"Processing completed" = "处理完成";
"Error occurred" = "发生错误";
```

#### 测试本地化

要在不更改系统设置的情况下测试本地化：

```bash
# 以特定语言运行应用
xcrun simctl launch --language=zh-Hans --region=CN com.yourusername.SignTools
```

### 许可证

本项目采用 MIT 许可证 - 详情请参阅 LICENSE 文件。 