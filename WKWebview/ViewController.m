//
//  ViewController.m
//  WKWebview
//
//  Created by 郑伟 on 2019/12/17.
//  Copyright © 2019 BourbonZ. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

#import "BZWKURLProtocol.h"
#import "NSURLProtocol+WKWebView.h"

#import "BZWKURLSchemeHandler.h"

#import "BZGCDWebServer.h"
@interface ViewController ()
@property (nonatomic, strong) WKWebView *wkView;
@end

@implementation ViewController {
    BZGCDWebServer *server;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"video" ofType:@"mp4"];
    NSString *targetPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"video.mp4"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:targetPath]) {
        [[NSFileManager defaultManager] copyItemAtPath:videoPath toPath:targetPath error:nil];
    }
    
    
    

    
    

    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];

//    [NSURLProtocol registerClass:[BZWKURLProtocol class]];
//    [BZWKURLProtocol wk_registerScheme:@"https"];
//
//
    BZWKURLSchemeHandler *handler = [[BZWKURLSchemeHandler alloc] init];
    [config setURLSchemeHandler:(handler) forURLScheme:@"bz"];
//
//    server = [[BZGCDWebServer alloc] init];
//    [server start];


    self.wkView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    [self.view addSubview:self.wkView];

    NSString *htmlStr = [[NSBundle mainBundle] pathForResource:@"tmp" ofType:@"html"];
    NSURL *fileURL = [NSURL fileURLWithPath:htmlStr];
    [self.wkView loadFileURL:fileURL allowingReadAccessToURL:fileURL];
    
}


@end
