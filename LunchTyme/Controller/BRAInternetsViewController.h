//
//  BRAInternetsViewController.h
//  LunchTyme
//
//  Created by Jinhuan Li on 12/10/15.
//  Copyright © 2015 likers33. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface BRAInternetsViewController : UIViewController<WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *mWebView;
@property (nonatomic, strong) WKWebViewConfiguration *mConfig;
@property (nonatomic, copy) NSString *homeURL;
@property (nonatomic, strong) UIProgressView *progressView;

@end