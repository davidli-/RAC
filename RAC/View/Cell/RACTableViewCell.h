//
//  RACTableViewCell.h
//  RAC
//
//  Created by Macmafia on 2019/1/17.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RACTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *btn;


@end

NS_ASSUME_NONNULL_END
