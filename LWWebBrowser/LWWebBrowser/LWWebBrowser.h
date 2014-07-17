//
//  LWWebBrowser.h
//  LWWebBrowser
//
//  Created by LiYonghui on 14-3-7.
//  Copyright (c) 2014年 LiYonghui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _LWWebBrowserMode {
    LWWebBrowserModeModal = 0,  // used when browser presented
    LWWebBrowserModeNavigation, // used when browser pushed
} LWWebBrowserMode;


@interface LWWebBrowser : UIViewController

/**
*  initialize web browser
*
*  @param url  url
*  @param mode LWWebBrowserMode
*
*  @return reutrn a initialized web browser
*/
- (id)initWithURL:(NSURL *)url mode:(LWWebBrowserMode)mode;

/**
 *  load url
 *
 *  @param url url
 */
- (void)loadURL:(NSURL *)url;

/**
 *  load string
 *
 *  @param string string
 */
- (void)loadHTMLString:(NSString *)string;


@end
