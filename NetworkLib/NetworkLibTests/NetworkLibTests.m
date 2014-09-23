//
//  NetworkLibTests.m
//  NetworkLibTests
//
//  Created by 羅建凱 on 2014/9/22.
//  Copyright (c) 2014年 intowow. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NetworkLib.h"


@interface NetworkLibTests : XCTestCase

@end

@implementation NetworkLibTests
- (void)testGetReposForRoylo
{
    __block id JSON;
    hxRunInMainLoop(^(BOOL *done) {
        NetworkLib *nl = [[NetworkLib alloc] init];
        [nl getGithubReposForUser:@"roylo" withSuccess:^(id responseObject) {
            NSLog(@"Response: %@", responseObject);
            JSON = responseObject;
            *done = YES;
        } failure:^(NSError *error) {
            *done = YES;
        }];
    });
    XCTAssertNotNil(JSON, @"");
}

- (void)testGetRepoForNotExistingUser
{
    __block id JSON;
    hxRunInMainLoop(^(BOOL *done) {
        NetworkLib *nl = [[NetworkLib alloc] init];
        [nl getGithubReposForUser:@"roylo23435342" withSuccess:^(id responseObject) {
            NSLog(@"Response: %@", responseObject);
            JSON = responseObject;
            *done = YES;
        } failure:^(NSError *error) {
            *done = YES;
        }];
    });
}

static inline void hxRunInMainLoop(void(^block)(BOOL *done)) {
    __block BOOL done = NO;
    block(&done);
    while (!done) {
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.1]];
    }
}

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

@end
