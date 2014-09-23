//
//  NetworkLib.m
//  NetworkLib
//
//  Created by 羅建凱 on 2014/9/22.
//  Copyright (c) 2014年 intowow. All rights reserved.
//

#import "NetworkLib.h"
#import "AFDownloadRequestOperation.h"

@implementation NetworkLib
{
    NSString *downloadFileName;
    NSString *testFileLarge;
    NSString *testFileSmall;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        downloadFileName = @"testFile";
        testFileLarge = @"http://download.thinkbroadband.com/512MB.zip";
        testFileSmall = @"http://download.thinkbroadband.com/5MB.zip";
    }
    return self;
}

- (AFDownloadRequestOperation *)startDownloadWithURL:(NSString *)url ToFile:(NSString *)fileName withSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure progress:(void (^)(AFDownloadRequestOperation *, float))progressive
{
    /*
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"https://api.github.com/users/%@/repos", user] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    */
    NSLog(@"start download: %@", url);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    NSLog(@"file path: %@", path);
    AFDownloadRequestOperation *op = [[AFDownloadRequestOperation alloc] initWithRequest:request targetPath:path shouldResume:YES];
   
    [op setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:fileName, @"name", nil]];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    
    [op setProgressiveDownloadProgressBlock:^(AFDownloadRequestOperation *operation, NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile) {

        float progressivePercent = totalBytesReadForFile/(float)totalBytesExpectedToReadForFile;
        progressive(operation, progressivePercent);
    }];
    
    [op start];
    return op;
}

- (void)pauseDownload:(AFDownloadRequestOperation *)op
{
    [op pause];
}

- (void)resumeDownload:(AFDownloadRequestOperation *)op
{
    [op resume];
}

- (void)cancelDownload:(AFDownloadRequestOperation *)op
{
    //[TODO] need to check if file is exist
    if ([op isExecuting] == YES || [op isFinished] == YES) {
        NSLog(@"It's excuting or finished");
    }
    [op cancel];
}


- (void)testDownloadStart
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:testFileSmall]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:downloadFileName];
    NSLog(@"file path: %@", path);
    AFDownloadRequestOperation *operation = [[AFDownloadRequestOperation alloc] initWithRequest:request targetPath:path shouldResume:YES];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Successfully downloaded file to %@", path);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [operation setProgressiveDownloadProgressBlock:^(AFDownloadRequestOperation *operation, NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile) {
        /*
        NSLog(@"Operation%i: bytesRead: %d", 1, bytesRead);
        NSLog(@"Operation%i: totalBytesRead: %lld", 1, totalBytesRead);
        NSLog(@"Operation%i: totalBytesExpected: %lld", 1, totalBytesExpected);
        NSLog(@"Operation%i: totalBytesReadForFile: %lld", 1, totalBytesReadForFile);
        NSLog(@"Operation%i: totalBytesExpectedToReadForFile: %lld", 1, totalBytesExpectedToReadForFile);
        */
        float progressivePercent = totalBytesReadForFile/(float)totalBytesExpectedToReadForFile;
        NSLog(@"%f", progressivePercent);
    }];
    
    
    //[[NSOperationQueue mainQueue] addOperation:operation];
    [operation start];
}

@end
