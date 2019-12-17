//
//  BZGCDWebServer.m
//  WKWebview
//
//  Created by 郑伟 on 2019/12/17.
//  Copyright © 2019 BourbonZ. All rights reserved.
//

#import "BZGCDWebServer.h"
#import "GCDWebServer.h"
#import "GCDWebServerDataResponse.h"
@implementation BZGCDWebServer {
    GCDWebServer *imageServer;
    GCDWebServer *videoServer;
}

- (instancetype)init {
    if (self = [super init]) {
        imageServer = [[GCDWebServer alloc] init];
        [imageServer addGETHandlerForBasePath:@"/" directoryPath:[NSBundle mainBundle].bundlePath indexFilename:nil cacheAge:0 allowRangeRequests:YES];

        [imageServer addDefaultHandlerForMethod:@"GET" requestClass:[GCDWebServerRequest class] asyncProcessBlock:^(__kindof GCDWebServerRequest * _Nonnull request, GCDWebServerCompletionBlock  _Nonnull completionBlock) {
          

            NSString *path = @"";
            NSString *contentType = @"";
            if ([request.URL.absoluteString containsString:@".jpeg"]) {
                path = [[NSBundle mainBundle] pathForResource:@"IMG_4909" ofType:@"PNG"];
                contentType = @"image/png";
            }

            NSData *data = [NSData dataWithContentsOfFile:path];
            GCDWebServerDataResponse *response = [GCDWebServerDataResponse responseWithData:data contentType:contentType];
            completionBlock(response);
        }];
        
        videoServer = [[GCDWebServer alloc] init];
        [videoServer addGETHandlerForBasePath:@"/" directoryPath:NSHomeDirectory() indexFilename:nil cacheAge:0 allowRangeRequests:YES];
    }
    return self;
}

- (void)start {
    [imageServer startWithPort:8080 bonjourName:nil];
    [videoServer startWithPort:8081 bonjourName:nil];

}

@end
