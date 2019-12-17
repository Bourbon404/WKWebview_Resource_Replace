//
//  BZWKURLProtocol.m
//  TMP
//
//  Created by 郑伟 on 2018/11/15.
//  Copyright © 2018 BourbonZ. All rights reserved.
//

#import "BZWKURLProtocol.h"

static NSString* const kBZWKURLProtocolKey = @"kBZWKURLProtocolKey";

@interface BZWKURLProtocol ()<NSURLSessionDelegate>
@property (nonnull,strong) NSURLSessionDataTask *task;
@end
@implementation BZWKURLProtocol


+ (BOOL)canInitWithRequest:(NSURLRequest *)request {

    if ([request.URL.absoluteString containsString:@".mp4"] ||
        [request.URL.absoluteString containsString:@".jpeg"]
        ) {
        //看看是否已经处理过了，防止无限循环
        if ([NSURLProtocol propertyForKey:kBZWKURLProtocolKey inRequest:request]) {
            return NO;
        }
        return YES;
    }
    return NO;
}


+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    
    //request截取重定向
//    if ([request.URL.absoluteString containsString:@".ttf"]) {
//        NSURL* url1 = [NSURL URLWithString:sourIconUrl];
//        mutableReqeust = [NSMutableURLRequest requestWithURL:url1];
//    }
//
    return mutableReqeust;
}

- (void)startLoading {
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    //给我们处理过的请求设置一个标识符, 防止无限循环,
    [NSURLProtocol setProperty:@YES forKey:kBZWKURLProtocolKey inRequest:mutableReqeust];
    
    //这里最好加上缓存判断，加载本地离线文件， 这个直接简单的例子。
    NSString *filePath = @"";
    NSString *mimeType = @"";
    if ([mutableReqeust.URL.absoluteString containsString:@".jpeg"]) {
        
        filePath = [[NSBundle mainBundle] pathForResource:@"IMG_4909" ofType:@"PNG"];
        mimeType = @"image/png";
        
    } else if ([mutableReqeust.URL.absoluteString containsString:@".mp4"]) {
        filePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"video.mp4"];
        mimeType = @"video/mpeg4";
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSData* data = [NSData dataWithContentsOfFile:filePath];
        NSURLResponse* response = [[NSURLResponse alloc] initWithURL:self.request.URL MIMEType:mimeType expectedContentLength:data.length textEncodingName:nil];
        [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowedInMemoryOnly];
        [self.client URLProtocol:self didLoadData:data];
        [self.client URLProtocolDidFinishLoading:self];
    } else {
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
       
        self.task = [session dataTaskWithRequest:self.request];
        [self.task resume];
    }
}

- (void)stopLoading {
    if (self.task != nil) {
        [self.task  cancel];
    }
}


- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    
    //允许请求加载
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    //加载数据
    [[self client] URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
    [self.client URLProtocolDidFinishLoading:self];
}

@end
