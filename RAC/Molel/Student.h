//
//  Student.h
//  RAC
//
//  Created by Macmafia on 2019/1/17.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^StudentBlock)();

@interface Student : NSObject

@property (copy , nonatomic) NSString *name;
@property (copy , nonatomic) StudentBlock block;

@end

NS_ASSUME_NONNULL_END
