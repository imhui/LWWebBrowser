//
//  LWWebBrowser.m
//  LWWebBrowser
//
//  Created by LiYonghui on 14-3-7.
//  Copyright (c) 2014年 LiYonghui. All rights reserved.
//


#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#import "LWWebBrowser.h"


static const CGFloat LWWebBrowserToolbarHeight = 44;


@interface LWWebBrowser () <UIWebViewDelegate, UIActionSheetDelegate> {
    
    UIWebView *_webView;
    UIToolbar *_toolbar;
    UINavigationBar *_modalNavigationBar;
    UINavigationItem *_modalNavigationItem;
    
    UIBarButtonItem *_goBackButtonItem;
    UIBarButtonItem *_goForwardButtonItem;
    UIBarButtonItem *_reloadButtonItem;
    UIBarButtonItem *_actionButtonItem;
    
    UIActivityIndicatorView *_loadingIndicator;
    UIBarButtonItem *_indicatorButtonItem;
    
    LWWebBrowserMode _browserMode;
    
}

@property (nonatomic, strong) NSURL *urlToLoad;

@end



@implementation LWWebBrowser

- (id)initWithURL:(NSURL *)url mode:(LWWebBrowserMode)mode
{
    self = [super init];
    if (self) {
        self.urlToLoad = url;
        _browserMode = mode == LWWebBrowserModeNavigation ? LWWebBrowserModeNavigation : LWWebBrowserModeModal;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initWebView];
    [self initToolbar];
    
    [self loadURL:self.urlToLoad];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


#pragma mark - auto rotate
- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

#pragma mark
- (void)loadURL:(NSURL *)url {
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)loadHTMLString:(NSString *)string {
    [_webView loadHTMLString:string baseURL:nil];
}

#pragma mark - Initialize Views
- (void)initNavigationBar {
    
    CGFloat navigationBarHeight = LWWebBrowserToolbarHeight;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        navigationBarHeight = 64;
    }
    _modalNavigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), navigationBarHeight)];
    _modalNavigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _modalNavigationBar.barStyle = UIBarStyleBlackOpaque;
    [self.view addSubview:_modalNavigationBar];
    
    _modalNavigationItem = [[UINavigationItem alloc] initWithTitle:@""];
    [_modalNavigationBar pushNavigationItem:_modalNavigationItem animated:NO];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil)
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self action:@selector(backButtonAction:)];
    _modalNavigationItem.leftBarButtonItem = backItem;
}


- (void)initWebView {
    
    if (_browserMode == LWWebBrowserModeModal) {
        [self initNavigationBar];
    }
    
    CGRect webViewRect = self.view.bounds;
    webViewRect.origin.y = _browserMode == LWWebBrowserModeNavigation ? 0 : CGRectGetHeight(_modalNavigationBar.frame);
    webViewRect.size.height = CGRectGetHeight(webViewRect) - LWWebBrowserToolbarHeight - CGRectGetHeight(_modalNavigationBar.frame);
    _webView = [[UIWebView alloc] initWithFrame:webViewRect];
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _webView.scalesPageToFit = YES;
    _webView.delegate = self;
    [self.view addSubview:_webView];
    [self.view sendSubviewToBack:_webView];
    
}

- (void)initToolbar {
    
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - LWWebBrowserToolbarHeight, CGRectGetWidth(self.view.bounds), LWWebBrowserToolbarHeight)];
    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_toolbar];
    
    _goBackButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"LWWebBrowser.bundle/back_icon"] style:UIBarButtonItemStylePlain
                                                        target:self action:@selector(goBackButtonItemAction:)];
    _goForwardButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"LWWebBrowser.bundle/forward_icon"] style:UIBarButtonItemStylePlain
                                                        target:self action:@selector(goForwardButtonItemAction:)];
    _reloadButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"LWWebBrowser.bundle/reload_icon"] style:UIBarButtonItemStylePlain
                                                           target:self action:@selector(reloadButtonItemAction:)];
    _actionButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                      target:self action:@selector(actionButtonItemAction:)];
    
    _loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _indicatorButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_loadingIndicator];
    
    
    UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *fixedSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpaceItem.width = 20;
    
    NSMutableArray *toolbarItems = [NSMutableArray arrayWithCapacity:0];
    [toolbarItems addObject:_goBackButtonItem];
    [toolbarItems addObject:fixedSpaceItem];
    [toolbarItems addObject:_goForwardButtonItem];
    [toolbarItems addObject:flexibleSpaceItem];
    [toolbarItems addObject:_indicatorButtonItem];
    [toolbarItems addObject:flexibleSpaceItem];
    [toolbarItems addObject:_reloadButtonItem];
    
    [toolbarItems addObject:fixedSpaceItem];
    [toolbarItems addObject:_actionButtonItem];
    
    _goBackButtonItem.enabled = NO;
    _goForwardButtonItem.enabled = NO;
    
    [_toolbar setItems:toolbarItems animated:YES];
}


#pragma mark - Property
- (UINavigationItem *)navigationItem {
    
    if (_browserMode == LWWebBrowserModeNavigation) {
        return [super navigationItem];
    }
    return _modalNavigationItem;
    
}


#pragma mark
- (void)backButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)goBackButtonItemAction:(id)sender {
    [_webView goBack];
    [self reloadButtonItemsStatus];
}

- (void)goForwardButtonItemAction:(id)sender {
    [_webView goForward];
    [self reloadButtonItemsStatus];
}

- (void)reloadButtonItemAction:(id)sender {
    [_webView reload];
    [self reloadButtonItemsStatus];
}

- (void)actionButtonItemAction:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:_webView.request.URL.absoluteString
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:NSLocalizedString(@"Open in Safari", nil), nil];
    [sheet showInView:self.view.window];
}

#pragma makr - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    [[UIApplication sharedApplication] openURL:_webView.request.URL];
}


#pragma mark
-(void)showActivityIndicators {
    _loadingIndicator.hidden = NO;
    [_loadingIndicator startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)hideActivityIndicators {
    _loadingIndicator.hidden = YES;
    [_loadingIndicator stopAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)reloadButtonItemsStatus {
    _goBackButtonItem.enabled = _webView.canGoBack;
    _goForwardButtonItem.enabled = _webView.canGoForward;
}


#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    if ([[request.URL absoluteString] hasPrefix:@"sms:"]) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self showActivityIndicators];
    [self reloadButtonItemsStatus];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSString *pageTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.navigationItem.title = pageTitle;
    
    [self hideActivityIndicators];
    [self reloadButtonItemsStatus];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self hideActivityIndicators];
    [self reloadButtonItemsStatus];
}


#pragma mark
/**
 *  注入javascript
 *
 *  @param scriptPath 脚本路径
 */
- (void)injectScript:(NSString *)scriptPath {
    
    NSMutableString *jsScript = [NSMutableString stringWithCapacity:0];
    [jsScript appendString:@"var script = document.createElement('script');"];
    [jsScript appendFormat:@"script.src = '%@';", [NSURL URLWithString:scriptPath]];
    [jsScript appendString:@"script.type = 'text/javascript';"];
    [jsScript appendString:@"document.getElementsByTagName('body')[0].appendChild(script);"];
    [_webView stringByEvaluatingJavaScriptFromString:jsScript];
    
}



@end
