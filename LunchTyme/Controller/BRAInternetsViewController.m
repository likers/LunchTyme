//
//  BRAInternetsViewController.m
//  LunchTyme
//
//  Created by Jinhuan Li on 12/10/15.
//  Copyright © 2015 likers33. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRAInternetsViewController.h"
#import "UIButton+Extensions.h"

typedef NS_ENUM(NSInteger, navActions)
{
    backAction = 1,
    forwardAction = 2,
    reloadAction = 3
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
    [backButton setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -30, -10, -10)];
    backButton.tag = backAction;
    backButton.alpha = 0.5;
    backButton.translatesAutoresizingMaskIntoConstraints = NO;
    [leftNavView addSubview:backButton];
    
    UIButton *reloadButton = [[UIButton alloc] init];
    [reloadButton setImage:[UIImage imageNamed:@"WebRefresh"] forState:UIControlStateNormal];
    [reloadButton addTarget:self action:@selector(navButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [reloadButton setBackgroundColor:[UIColor clearColor]];
    [reloadButton setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];
    reloadButton.tag = reloadAction;
    reloadButton.translatesAutoresizingMaskIntoConstraints = NO;
    [leftNavView addSubview:reloadButton];
    
    UIButton *forwardButton = [[UIButton alloc] init];
    [forwardButton setImage:[UIImage imageNamed:@"WebForward"] forState:UIControlStateNormal];
    [forwardButton addTarget:self action:@selector(navButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [forwardButton setBackgroundColor:[UIColor clearColor]];
    [forwardButton setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -30)];
    forwardButton.tag = forwardAction;
    forwardButton.alpha = 0.5;
    forwardButton.translatesAutoresizingMaskIntoConstraints = NO;
    [leftNavView addSubview:forwardButton];
    
    NSDictionary *navViews = NSDictionaryOfVariableBindings(backButton, reloadButton, forwardButton, leftNavView);

    [leftNavView addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-32-[backButton]-32-[reloadButton]-32-[forwardButton]|"
                            options:NSLayoutFormatAlignAllCenterY
                            metrics:nil
                            views:navViews]];
    [leftNavView
     addConstraints: [NSLayoutConstraint
                      constraintsWithVisualFormat:@"V:|[backButton]|"
                      options:0
                      metrics:nil
                      views:navViews]];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftNavView];
    self.navigationItem.leftBarButtonItem = leftItem;
    leftNavView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *metrics = @{@"width":@(DEVICE_WIDTH/2)};
    [self.navigationController.navigationBar
     addConstraints:[NSLayoutConstraint
                     constraintsWithVisualFormat:@"V:|[leftNavView]|"
                     options:0
                     metrics:metrics
                     views:navViews]];
}

- (void)initProgressView
{
    progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    progressView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:progressView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(progressView);
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|[progressView(==2.5)]"
                               options:0
                               metrics:nil
                               views:views]];
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|[progressView]|"
                               options:0
                               metrics:nil
                               views:views]];
}

- (void)initWKWebView
{
    self.mConfig = [[WKWebViewConfiguration alloc] init];
    [self addUserScriptToUserContentController:mConfig.userContentController];
    
    mWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:self.mConfig];
    mWebView.navigationDelegate = self;
    mWebView.UIDelegate = self;
    mWebView.allowsBackForwardNavigationGestures = YES;
    mWebView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view insertSubview:mWebView belowSubview:progressView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(mWebView);
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|[mWebView]|"
                               options:0
                               metrics:nil
                               views:views]];
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|[mWebView]|"
                               options:0
                               metrics:nil
                               views:views]];
    
    [self.mWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    NSURL *url = [NSURL URLWithString:homeURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [mWebView loadRequest:requestObj];
}

//MARK: - user script related
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
            if (mWebView.canGoBack && ![[mWebView.URL absoluteString] isEqualToString:[NSString stringWithFormat:@"%@/",self.homeURL]])
            {
                NSLog(@"%@",[mWebView.URL absoluteString]);
                [self.navigationController.navigationBar viewWithTag:backAction].alpha = 1;
            } else
            {
                [self.navigationController.navigationBar viewWithTag:backAction].alpha = 0.5;
            }
            break;
        case forwardAction:
            [self navForward];
            if (mWebView.canGoForward)
            {
                [self.navigationController.navigationBar viewWithTag:forwardAction].alpha = 1;
            } else
            {
                [self.navigationController.navigationBar viewWithTag:forwardAction].alpha = 0.5;
            }
            break;
        case reloadAction:
            [mWebView reload];
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
    }
}

- (void)navForward
{
    if (mWebView.canGoForward)
    {
        [self.mWebView goForward];
        [self.navigationController.navigationBar viewWithTag:backAction].alpha = 1;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end