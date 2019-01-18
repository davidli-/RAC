//
//  RACViewModel.h
//  RAC
//
//  Created by Macmafia on 2019/1/18.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RACCommand.h"
#import "RACSignal.h"

NS_ASSUME_NONNULL_BEGIN

@interface RACViewModel : NSObject

//属性对外只读
@property (nonatomic, readonly) NSUInteger cellNums;
@property (nonatomic, readonly) BOOL reloadData;
@property (nonatomic, readonly, strong) RACCommand *fetchCommand;

- (NSString*)convertedTextAtIndexPath:(NSIndexPath*)indexPath;

@end

NS_ASSUME_NONNULL_END
