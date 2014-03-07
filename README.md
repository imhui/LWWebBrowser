LWWebBrowser - A web browser control for iOS apps
============

LWWebBrowser - A web browser control for iOS apps

![screenshot1](https://github.com/imhui/LWWebBrowser/blob/master/LWWebBrowser/screenshot/screenshot1.png?raw=true)

## Features

LWWebBrowser offers the following features:

- Back and forward buttons
- Reload button
- Activity indicator while page is loading
- Action button to open the current page in Safari 
- Displays the page title at the navigation bar
- ARC supported
- iOS6 and later


## Usage
```
LWWebBrowser *browser = [[LWWebBrowser alloc] initWithURL:[NSURL URLWithString:@"http://www.google.com"] mode:LWWebBrowserModeNavigation];
[self.navigationController pushViewController:webBrowser animated:YES];
```