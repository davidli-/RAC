//
//  RACViewModel.m
//  RAC
//
//  Created by Macmafia on 2019/1/18.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "RACViewModel.h"
#import "ReactiveCocoa.h"
#import "RACHttpRequestManager.h"
#import "RACEXTScope.h"
#import "RACModel.h"

@interface RACViewModel()
//属性对内可读可写
@property (nonatomic, readwrite) NSUInteger cellNums;
@property (nonatomic, readwrite) BOOL reloadData;
@property (nonatomic, readwrite, strong) RACCommand *fetchCommand;
@property (nonatomic, strong) NSArray *mItemsArr;
@end

@implementation RACViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        //创建指令
        self.fetchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            NSLog(@"++++fetch~");
            return [[RACHttpRequestManager shareManager] fetchRequest];
        }];
        //订阅
        @weakify(self)
        [[self.fetchCommand.executionSignals switchToLatest] subscribeNext:^(NSArray *dataArr) {
            @strongify(self)
            if (dataArr) {
                self.mItemsArr = dataArr;
            }
        }];
        //监听数据源变化
        [RACObserve(self, mItemsArr) subscribeNext:^(NSArray *x) {
            @strongify(self)
            self.cellNums = x.count;
            self.reloadData = YES;//通知V层更新TableView
        }];
    }
    return self;
}

- (NSString *)convertedTextAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.mItemsArr.count) {
        return @"0";
    }
    RACModel *model = self.mItemsArr[indexPath.row];
    NSString *str = model.title;
    return [str copy];
}

- (void)dealloc{
    NSLog(@"++%@ dealloced~",[self class]);
}
@end
