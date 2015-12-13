//
//  BRAInternetsViewController.m
//  LunchTyme
//
//  Created by Jinhuan Li on 12/10/15.
//  Copyright © 2015 likers33. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRAInternetsViewController.h"

typedef NS_ENUM(NSInteger, navActions)
{
    backAction = 1,
    forwardAction = 2,
    reloadAction = 3,
    stopAction = 4
};

@implementation BRAInternetsViewController

@synthesize mWebView, mConfig, homeURL, progressView;

- (void)dealloc
{
    [self.mWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.mWebView setNavigationDelegate:nil];
    [self.mWebView setUIDelegate:nil];
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.homeURL = @"http://www.bottlerocketstudios.com";
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self initNavigationBar];
    [self initProgressView];
    [self initWKWebView];
}

- (void)initNavigationBar
{
    //set bar tint color
    [self.navigationController.navigationBar setBarTintColor:[UIColor BRANavGreen]];
    
    //set left barButtonItems
    UIView *leftNavView = [[UIView alloc] init];
    leftNavView.backgroundColor = [UIColor clearColor];
    
    UIButton *backButton = [[UIButton alloc] init];
    [backButton setImage:[UIImage imageNamed:@"WebBack"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(navButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundColor:[UIColor clearColor]];
    backButton.tag = backAction;
    backButton.alpha = 0.5;
    [leftNavView addSubview:backButton];
    
    backButton.translatesAutoresizingMaskIntoConstraints = NO;
    [backButton.centerYAnchor constraintEqualToAnchor:leftNavView.centerYAnchor].active = true;
    [backButton.leftAnchor constraintEqualToAnchor:leftNavView.leftAnchor constant:32].active = true;
    
    UIButton *reloadButton = [[UIButton alloc] init];
    [reloadButton setImage:[UIImage imageNamed:@"WebRefresh"] forState:UIControlStateNormal];
    [reloadButton addTarget:self action:@selector(navButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [reloadButton setBackgroundColor:[UIColor clearColor]];
    reloadButton.tag = reloadAction;
    [leftNavView addSubview:reloadButton];
    
    reloadButton.translatesAutoresizingMaskIntoConstraints = NO;
    [reloadButton.centerYAnchor constraintEqualToAnchor:leftNavView.centerYAnchor].active = true;
    [reloadButton.leftAnchor constraintEqualToAnchor:backButton.rightAnchor constant:32].active = true;
    
    UIButton *forwardButton = [[UIButton alloc] init];
    [forwardButton setImage:[UIImage imageNamed:@"WebForward"] forState:UIControlStateNormal];
    [forwardButton addTarget:self action:@selector(navButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [forwardButton setBackgroundColor:[UIColor clearColor]];
    forwardButton.tag = forwardAction;
    forwardButton.alpha = 0.5;
    [leftNavView addSubview:forwardButton];
    
    forwardButton.translatesAutoresizingMaskIntoConstraints = NO;
    [forwardButton.centerYAnchor constraintEqualToAnchor:leftNavView.centerYAnchor].active = true;
    [forwardButton.leftAnchor constraintEqualToAnchor:reloadButton.rightAnchor constant:32].active = true;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftNavView];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    leftNavView.translatesAutoresizingMaskIntoConstraints = NO;
    [leftNavView.topAnchor constraintEqualToAnchor:self.navigationController.navigationBar.topAnchor].active = true;
    [leftNavView.leftAnchor constraintEqualToAnchor:self.navigationController.navigationBar.leftAnchor].active = true;
    [leftNavView.bottomAnchor constraintEqualToAnchor:self.navigationController.navigationBar.bottomAnchor].active = true;
    [leftNavView.widthAnchor constraintEqualToConstant:DEVICE_WIDTH/2].active = true;
    
    //set right barButtonItems
    UIView *rightNavView = [[UIView alloc] init];
    rightNavView.backgroundColor = [UIColor clearColor];
    
    UIButton *stopButton = [[UIButton alloc] init];
    [stopButton setImage:[UIImage imageNamed:@"WebCancel"] forState:UIControlStateNormal];
    [stopButton addTarget:self action:@selector(navButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [stopButton setBackgroundColor:[UIColor clearColor]];
    stopButton.tag = stopAction;
    [rightNavView addSubview:stopButton];
    
    stopButton.translatesAutoresizingMaskIntoConstraints = NO;
    [stopButton.centerYAnchor constraintEqualToAnchor:rightNavView.centerYAnchor].active = true;
    [stopButton.rightAnchor constraintEqualToAnchor:rightNavView.rightAnchor constant:-32].active = true;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavView];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    rightNavView.translatesAutoresizingMaskIntoConstraints = NO;
    [rightNavView.topAnchor constraintEqualToAnchor:self.navigationController.navigationBar.topAnchor].active = true;
    [rightNavView.rightAnchor constraintEqualToAnchor:self.navigationController.navigationBar.rightAnchor].active = true;
    [rightNavView.bottomAnchor constraintEqualToAnchor:self.navigationController.navigationBar.bottomAnchor].active = true;
    [rightNavView.widthAnchor constraintEqualToConstant:DEVICE_WIDTH/2].active = true;
}

- (void)initProgressView
{
    progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    [self.view addSubview:progressView];
    
    progressView.translatesAutoresizingMaskIntoConstraints = NO;
    [progressView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = true;
    [progressView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = true;
    [progressView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = true;
    [progressView.heightAnchor constraintEqualToConstant:2.5].active = true;
}

- (void)initWKWebView
{
    self.mConfig = [[WKWebViewConfiguration alloc] init];
    [self addUserScriptToUserContentController:mConfig.userContentController];
    
    mWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:self.mConfig];
    mWebView.navigationDelegate = self;
    mWebView.UIDelegate = self;
    mWebView.allowsBackForwardNavigationGestures = YES;
    [self.view insertSubview:mWebView belowSubview:progressView];
    
    mWebView.translatesAutoresizingMaskIntoConstraints = NO;
    [mWebView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = true;
    [mWebView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = true;
    [mWebView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = true;
    [mWebView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = true;
    
    [self.mWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    NSURL *url = [NSURL URLWithString:homeURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [mWebView loadRequest:requestObj];
}

- (void) addUserScriptToUserContentController:(WKUserContentController *) userContentController
{
    NSString *jsHandler = [NSString stringWithContentsOfURL:[[NSBundle mainBundle]URLForResource:@"ajaxHandler" withExtension:@"js"] encoding:NSUTF8StringEncoding error:NULL];
    WKUserScript *ajaxHandler = [[WKUserScript alloc]initWithSource:jsHandler injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [userContentController addScriptMessageHandler:self name:@"callbackHandler"];
    [userContentController addUserScript:ajaxHandler];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    if([message.name isEqualToString:@"callbackHandler"])
    {
        [self.navigationController.navigationBar viewWithTag:backAction].alpha = mWebView.canGoBack ? 1 : 0.5;
        [self.navigationController.navigationBar viewWithTag:forwardAction].alpha = mWebView.canGoForward ? 1 : 0.5;
    }
}

//show/hide progress
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"] && object == self.mWebView)
    {
        [progressView setAlpha:1];
        [progressView setProgress:mWebView.estimatedProgress animated:YES];
        if(self.mWebView.estimatedProgress >= 1.0f)
        {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [progressView setProgress:0.0 animated:YES];
}

- (void)navButtonAction:(UIButton *)button
{
    switch (button.tag)
    {
        case backAction:
            [self navBack];
            break;
        case forwardAction:
            [self navForward];
            break;
        case reloadAction:
            [mWebView reload];
            break;
        case stopAction:
            [mWebView stopLoading];
            break;
        default:
            break;
    }
}

- (void)navBack
{
    if (mWebView.canGoBack && ![[mWebView.URL absoluteString] isEqualToString:self.homeURL])
    {
        [self.mWebView goBack];
        [self.navigationController.navigationBar viewWithTag:forwardAction].alpha = 1;
    } else
    {
        [self.navigationController.navigationBar viewWithTag:backAction].alpha = 0.5;
    }
}

- (void)navForward
{
    if (mWebView.canGoForward)
    {
        [self.mWebView goForward];
        [self.navigationController.navigationBar viewWithTag:backAction].alpha = 1;
    } else
    {
        [self.navigationController.navigationBar viewWithTag:forwardAction].alpha = 0.5;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end