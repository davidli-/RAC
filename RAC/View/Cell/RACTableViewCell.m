//
//  RACTableViewCell.m
//  RAC
//
//  Created by Macmafia on 2019/1/17.
//  Copyright © 2019 Macmafia. All rights reserved.
//

#import "RACTableViewCell.h"

@implementation RACTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)onClicked:(id)sender {
    NSLog(@"~~~");
}

@end
