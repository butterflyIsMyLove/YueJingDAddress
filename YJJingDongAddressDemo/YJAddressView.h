//
//  YJAddressView.h
//  YJJingDongAddressDemo
//
//  Created by xiangtai on 2017/12/21.
//  Copyright © 2017年 xiangtai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AddressViewSelectProCityAreaBlock)(NSString *pro,NSString *city,NSString *area);

@interface YJAddressView : UIView

- (void)show;
- (void)setAddressSelectBlock:(AddressViewSelectProCityAreaBlock)addressSelectBlock;

@end
