# XHGAlertView

[![CI Status](https://img.shields.io/travis/gdutxzy/XHGAlertView.svg?style=flat)](https://travis-ci.org/gdutxzy/XHGAlertView)
[![Version](https://img.shields.io/cocoapods/v/XHGAlertView.svg?style=flat)](https://cocoapods.org/pods/XHGAlertView)
[![License](https://img.shields.io/cocoapods/l/XHGAlertView.svg?style=flat)](https://cocoapods.org/pods/XHGAlertView)
[![Platform](https://img.shields.io/cocoapods/p/XHGAlertView.svg?style=flat)](https://cocoapods.org/pods/XHGAlertView)

## Features
AlertView SheetView 弹框 
1、仿照UIAlertController的初始化API。
2、当内容高度超出屏幕时，内容可滚动。 
3、当多个弹窗同时出现时，采用LIFO机制（后进先出。先展示最后一个加入的AlertView，当其消失时，继续展示最后一个）。 
4、支持Alert、Sheet样式，能展示的内容包括 标题图片、标题、内容、选项框、底部操作按钮。以及自定义视图。
5、支持自定义视图含有输入框的情况，可自动调节位置不被键盘遮挡。
6、采用keywindow模式显示，弹出时会自动收起已有键盘。消失时会恢复键盘。

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

XHGAlertView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby

pod 'XHGAlertView'

```

小黄狗弹窗选项视图，非通用视图

```ruby

pod 'XHGAlertView', :subspecs =>['customizeMenuView']

```

## Author

gdutxzy, xiezongyuan@xhg.com

## License

XHGAlertView is available under the MIT license. See the LICENSE file for more info.
