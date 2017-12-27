//
//  YJAddressCell.m
//  YJJingDongAddressDemo
//
//  Created by xiangtai on 2017/12/26.
//  Copyright © 2017年 xiangtai. All rights reserved.
//

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#import "YJAddressCell.h"

@interface YJAddressCell ()

@property (nonatomic , weak) UIImageView *selectImageView;

@end

@implementation YJAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews {
    
    UIImage *selectImage = [UIImage imageNamed:@"orderPay_selected_icon"];
    UIImageView *selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - selectImage.size.width, (44 - selectImage.size.height) / 2, selectImage.size.width, selectImage.size.height)];
    selectImageView.image = selectImage;
    [self.contentView addSubview:selectImageView];
    self.selectImageView = selectImageView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.selectImageView.hidden = !selected;
}

@end
