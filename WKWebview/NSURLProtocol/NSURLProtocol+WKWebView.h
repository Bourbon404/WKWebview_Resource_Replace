//
//  NSURLProtocol+WKWebView.h
//  TMP
//
//  Created by 郑伟 on 2018/11/15.
//  Copyright © 2018 BourbonZ. All rights reserved.
//

#import <WebKit/WebKit.h>
@interface NSURLProtocol (WKWebView)

+ (void)wk_registerScheme:(NSString*)scheme;

+ (void)wk_unregisterScheme:(NSString*)scheme;

@end


