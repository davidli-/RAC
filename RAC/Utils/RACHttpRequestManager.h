//
//  RACHttpRequestManager.h
//  RAC
//
//  Created by Macmafia on 2019/1/18.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReactiveCocoa.h"
#import "AFHTTPRequestOperationManager+RACSupport.h"

NS_ASSUME_NONNULL_BEGIN

@interface RACHttpRequestManager : AFHTTPRequestOperationManager

+ (instancetype)shareManager;
- (RACSignal*)fetchRequest;

@end

NS_ASSUME_NONNULL_END
