//
//  BookTableViewCell.m
//  疯子助手
//
//  Created by 紫贝壳 on 2016/11/15.
//  Copyright © 2016年 紫贝壳. All rights reserved.
//

#import "BookTableViewCell.h"

@implementation BookTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    self.textlab = [[UILabel alloc]initWithFrame:self.bounds];
    [self.contentView addSubview:self.textlab];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
