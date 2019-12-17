//
//  BZWKURLSchemeHandler.m
//  WKWebview
//
//  Created by 郑伟 on 2019/12/17.
//  Copyright © 2019 BourbonZ. All rights reserved.
//

#import "BZWKURLSchemeHandler.h"

@implementation BZWKURLSchemeHandler


- (void)webView:(WKWebView *)webView startURLSchemeTask:(id <WKURLSchemeTask>)urlSchemeTask {
    
    NSURLRequest *request = urlSchemeTask.request;
    
    if ([request.URL.absoluteString containsString:@".mp4"]) {
        NSString *filePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"video.mp4"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSURLResponse *response = [[NSURLResponse alloc] initWithURL:urlSchemeTask.request.URL MIMEType:@"video/mp4" expectedContentLength:data.length textEncodingName:nil];
        [urlSchemeTask didReceiveResponse:response];
        [urlSchemeTask didReceiveData:data];
        
    } else {
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"IMG_4909" ofType:@"PNG"];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSURLResponse *response = [[NSURLResponse alloc] initWithURL:urlSchemeTask.request.URL MIMEType:@"image/png" expectedContentLength:data.length textEncodingName:nil];
        [urlSchemeTask didReceiveResponse:response];
        [urlSchemeTask didReceiveData:data];
    }
    
    [urlSchemeTask didFinish];
}

- (void)webView:(WKWebView *)webView stopURLSchemeTask:(id <WKURLSchemeTask>)urlSchemeTask {
    
}

@end
