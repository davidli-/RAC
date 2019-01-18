//
//  ViewControllerII.h
//  RAC
//
//  Created by Macmafia on 2019/1/16.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RACSubject.h"

NS_ASSUME_NONNULL_BEGIN

@interface ViewControllerII : UIViewController
@property (nonatomic, strong) RACSubject *rac_delegate;//代替协议
@end

NS_ASSUME_NONNULL_END
