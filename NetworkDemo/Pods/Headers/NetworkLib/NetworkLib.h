//
//  NetworkLib.h
//  NetworkLib
//
//  Created by 羅建凱 on 2014/9/22.
//  Copyright (c) 2014年 intowow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "AFDownloadRequestOperation.h"

@interface NetworkLib : NSObject
@property (nonatomic, assign) float progressivePercent;

- (AFDownloadRequestOperation *) startDownloadWithURL:(NSString *)url
                                               ToFile:(NSString *)fileName
                                          withSuccess:(void (^)(id responseObject))success
                                              failure:(void (^)(NSError *error))failure
                                             progress:(void (^)(AFDownloadRequestOperation *op, float percent))progressive;

- (void) pauseDownload:(AFDownloadRequestOperation *)op;
- (void) resumeDownload:(AFDownloadRequestOperation *)op;
- (void) cancelDownload:(AFDownloadRequestOperation *)op;

- (void) testDownloadStart;
@end
