//
//  RACHttpRequestManager.m
//  RAC
//
//  Created by Macmafia on 2019/1/18.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "RACHttpRequestManager.h"
#import "RACModel.h"

static RACHttpRequestManager *mManager;

@implementation RACHttpRequestManager

+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mManager = [[self alloc] init];
    });
    return mManager;
}

- (RACSignal*)fetchRequest
{
    RACSignal *s = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"++on RACSignal in fetch~");
        //模拟网络请求 5秒后返回数据
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"++++Http responsed!");
            NSMutableArray *mutArr = [NSMutableArray arrayWithCapacity:15];
            for (int i = 0; i < 15; i++) {
                RACModel *model = [[RACModel alloc] init];
                model.title = [NSString stringWithFormat:@"%d",i];
                [mutArr addObject:model];
            }
            [subscriber sendNext:mutArr];
        });
        return [RACDisposable disposableWithBlock:^{
        }];
    }];
    
    return s;
}

- (RACSignal*)RAC_request
{
    return [[[self rac_GET:@"https://www.baidu.com" parameters:@{@"name":@"Dav"}]
             catch:^RACSignal *(NSError *error) {
                 //处理Error
                 NSError *errorT = [NSError errorWithDomain:@"Domain" code:404 userInfo:@{@"message":@"Not found~"}];
                 return [RACSignal error:errorT];
             }]
            reduceEach:^id(NSData *data,NSURLResponse *response){
                NSLog(@"++++返回数据~");
                return data;
            }];
}

- (void)dealloc{
    NSLog(@"++%@ dealloced~",[self class]);
}
@end
