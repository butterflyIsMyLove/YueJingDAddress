//
//  ViewController.m
//  YJJingDongAddressDemo
//
//  Created by xiangtai on 2017/12/21.
//  Copyright © 2017年 xiangtai. All rights reserved.
//

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#import "ViewController.h"
#import "YJAddressView.h"

@interface ViewController ()

@property (nonatomic , strong)YJAddressView *addressView;

@end

@implementation ViewController

- (IBAction)chooseAddressClick:(id)sender {
    
    [self.addressView show];
    [self.addressView setAddressSelectBlock:^(NSString *pro, NSString *city, NSString *area) {
        
        UIButton *button = (UIButton *)sender;
        NSString *address = [NSString stringWithFormat:@"%@%@%@",pro,city,area];
        [button setTitle:address forState:UIControlStateNormal];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (YJAddressView *)addressView {
    if (!_addressView) {
        _addressView = [[YJAddressView alloc] init];
        
    }
    return _addressView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
