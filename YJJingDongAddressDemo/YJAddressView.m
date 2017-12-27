//
//  YJAddressView.m
//  YJJingDongAddressDemo
//
//  Created by xiangtai on 2017/12/21.
//  Copyright © 2017年 xiangtai. All rights reserved.
//

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

static const float contentViewHeight = 320;
static const float titlesScrollHeight = 35;
static const float contentScrollHeight = 250;
static const float titleWidth = 60;
static const float totalTitleHeight = 35;

#import "YJAddressView.h"
#import "YJAddressCell.h"

@interface YJAddressView ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic , weak)UIView *bgView;
@property (nonatomic , weak)UIScrollView *titlesScrollView;
@property (nonatomic , weak)UIScrollView *contentScrollView;
@property (nonatomic , weak)UIView *slideLineView;
@property (nonatomic , strong)NSMutableArray *titleArrs;
@property (nonatomic , strong)NSMutableArray *tableArrs;
@property (nonatomic , weak)UIView *corverView;

@property (nonatomic , strong)NSMutableDictionary *dataDic;
@property (nonatomic , strong)NSArray *provinces;
@property (nonatomic , strong)NSArray *citys;
@property (nonatomic , strong)NSArray *areas;

@property (nonatomic , copy)NSString *selectPro;
@property (nonatomic , copy)NSString *selectCity;
@property (nonatomic , copy)NSString *selectArea;

@property (nonatomic , copy)AddressViewSelectProCityAreaBlock addressSelectBlock;

@end

@implementation YJAddressView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, contentViewHeight);
        self.backgroundColor = [UIColor whiteColor];
        [self setupViews];
        [self getProvinceData];
    }
    return self;
}

#pragma mark - RequestDataMethod
- (void)getProvinceData {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    self.dataDic = data;
    self.provinces = self.dataDic.allKeys;
}

- (NSArray *)getCityDataWithSelectProvince:(NSString *)selectProvince {
    NSArray *cityArr = self.dataDic[selectProvince];
    NSArray *citys = [NSArray array];
    for (NSDictionary *cityDic in cityArr) {
        citys = cityDic.allKeys;
    }
    return citys;
}

- (NSArray *)getAreaDataWithWithSelectProvince:(NSString *)province withSelectCity:(NSString *)selectCity {
    NSArray *cityArr = self.dataDic[province];
    NSArray *areas = [NSArray array];
    for (NSDictionary *cityDic in cityArr) {
        areas = cityDic[selectCity];
    }
    return areas;
}

#pragma mark - initViews
- (void)setupCorverView {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *corverView = [[UIView alloc] initWithFrame:window.bounds];
    corverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [window addSubview:corverView];
    [corverView addSubview:self];
    self.corverView = corverView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [self.corverView addGestureRecognizer:tap];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"] || [NSStringFromClass([touch.view class]) isEqualToString:@"UIScrollView"] || [NSStringFromClass([touch.view class]) isEqualToString:@"UITableView"]) {
        return NO;
    }
    return  YES;
}

#pragma mark - Private Method
- (void)btnTitleClick:(UIButton *)btn {
    
    self.slideLineView.frame = CGRectMake(btn.frame.origin.x, btn.frame.size.height - 2, titleWidth, 2);
    [self.contentScrollView setContentOffset:CGPointMake((btn.tag - 100) * kScreenWidth, 0) animated:YES];
}

- (void)cancleBtnClick:(UIButton *)cancleBtn {
    [self dismiss];
}

- (void)show {
    [self setupCorverView];
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, kScreenHeight - contentViewHeight, kScreenWidth, contentViewHeight);
        self.userInteractionEnabled = NO;
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, contentViewHeight);
        self.userInteractionEnabled = NO;
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
        [self.corverView removeFromSuperview];
    }];
    
    if (self.selectPro && self.selectCity && self.selectArea) {
        self.addressSelectBlock(self.selectPro, self.selectCity, self.selectArea);
    }
    
}

#pragma mark - initView
- (void)setupViews {
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, totalTitleHeight)];
    topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:topView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, kScreenWidth - 80,totalTitleHeight)];
    titleLabel.text = @"配送至";
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor lightGrayColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:titleLabel];
    
    UIImage *shutImage = [UIImage imageNamed:@"shutbtn_background"];
    UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - shutImage.size.width - 10, (titlesScrollHeight - shutImage.size.height) / 2, shutImage.size.width,shutImage.size.height)];
    [cancleBtn setBackgroundImage:shutImage forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancleBtn addTarget:self action:@selector(cancleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:cancleBtn];
    
    UIScrollView *titlesScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, totalTitleHeight, kScreenWidth, titlesScrollHeight)];
    [self addSubview:titlesScrollView];
    self.titlesScrollView = titlesScrollView;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, titlesScrollHeight + totalTitleHeight - 1, kScreenWidth, 1)];
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:lineView];
    
    UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, titlesScrollHeight + totalTitleHeight, kScreenWidth, contentScrollHeight)];
    contentScrollView.pagingEnabled = YES;
    contentScrollView.delegate = self;
    [self addSubview:contentScrollView];
    self.contentScrollView = contentScrollView;
    
    [self addTableViewWithIndex:0 withAnimated:YES];
    [self addTitleItemWithIndex:0 withAddress:@"请选择"];
}

- (void)addTitleItemWithIndex:(NSInteger)index withAddress:(NSString *)address {
   
    for (UIButton *button in self.titlesScrollView.subviews) {
        [button removeFromSuperview];
    }

    for (int i = 0; i < self.titleArrs.count; i++) {
        
        NSString *btnTitle = self.titleArrs[i];
        UIButton *titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(titleWidth * i, 0, titleWidth, titlesScrollHeight)];
        [titleBtn setTitle:btnTitle forState:UIControlStateNormal];
        [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [titleBtn addTarget:self action:@selector(btnTitleClick:) forControlEvents:UIControlEventTouchUpInside];
        if ([btnTitle isEqualToString:@"请选择"]) {
            [titleBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        titleBtn.tag = i + 100;
        [self.titlesScrollView addSubview:titleBtn];
    }
    
    UIView *slideLineView = [[UIView alloc] initWithFrame:CGRectMake(titleWidth * (self.titleArrs.count - 1), titlesScrollHeight - 2, titleWidth, 2)];
    slideLineView.backgroundColor = [UIColor redColor];
    [self.titlesScrollView addSubview:slideLineView];
    self.slideLineView = slideLineView;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.contentScrollView) {   //  如果滚动的是self.contentScrollView 则调用此方法
        
        int offsetX = scrollView.contentOffset.x;
        if (offsetX % (int)kScreenWidth == 0) {
            self.slideLineView.frame = CGRectMake((scrollView.contentOffset.x / kScreenWidth) * titleWidth, titlesScrollHeight - 2, titleWidth, 2);
        }
    }
}

#pragma mark - UITableViewDelegate / UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (tableView.tag == 0) {
        return self.provinces.count;
    } else if (tableView.tag == 1) {
        NSArray *cityArr = [self getCityDataWithSelectProvince:self.selectPro];
        return cityArr.count;
    } else if (tableView.tag == 2) {
        NSArray *areaArr = [self getAreaDataWithWithSelectProvince:self.selectPro withSelectCity:self.selectCity];
        return areaArr.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    YJAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[YJAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:13];

    if (tableView.tag == 0) {
        cell.textLabel.text = self.provinces[indexPath.row];
    } else if (tableView.tag == 1) {
        NSArray *citys = [self getCityDataWithSelectProvince:self.selectPro];
        cell.textLabel.text = citys[indexPath.row];
    } else if (tableView.tag == 2) {
        NSArray *areas = [self getAreaDataWithWithSelectProvince:self.selectPro withSelectCity:self.selectCity];
        cell.textLabel.text = areas[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UIButton *button = [self.titlesScrollView viewWithTag:tableView.tag + 100];
    
    if (tableView.tag == 0) {
        self.selectPro = self.provinces[indexPath.row];
        if (![button.currentTitle isEqualToString:self.selectPro]) {
            [self.titleArrs insertObject:self.selectPro atIndex:tableView.tag];
        }
        
    } else if (tableView.tag == 1) {
        NSArray *citys = [self getCityDataWithSelectProvince:self.selectPro];
        self.selectCity = citys[indexPath.row];
        if (![button.currentTitle isEqualToString:self.selectCity]) {
            [self.titleArrs insertObject:self.selectCity atIndex:tableView.tag];
        }
    } else {
        NSArray *areaArr = [self getAreaDataWithWithSelectProvince:self.selectPro withSelectCity:self.selectCity];
        self.selectArea = areaArr[indexPath.row];
        if (![button.currentTitle isEqualToString:self.selectArea]) {
            [self.titleArrs replaceObjectAtIndex:self.titleArrs.count - 1 withObject:self.selectArea];
        }
    }
    
    if (self.titleArrs.count - tableView.tag > 1 && ![button.currentTitle isEqualToString:self.titleArrs[tableView.tag]]) {  // 当选择完省市区后 返回重新选择时
        NSRange range = NSMakeRange(tableView.tag + 1, self.titleArrs.count - tableView.tag - 1);
        NSRange tableRange = NSMakeRange(tableView.tag + 1, self.tableArrs.count - tableView.tag - 1);
        [self.titleArrs removeObjectsInRange:range];
        [self.tableArrs removeObjectsInRange:tableRange];
        [self.titleArrs insertObject:@"请选择" atIndex:tableView.tag + 1];
    }
 
    if (tableView.tag < 2) { //  0,1
        [self addTableViewWithIndex:tableView.tag + 1 withAnimated:YES];
        
    } else {
        [self dismiss];
    }
    [self addTitleItemWithIndex:tableView.tag withAddress:self.titleArrs[tableView.tag]];
    
}

- (void)addTableViewWithIndex:(NSInteger)index withAnimated:(BOOL)animated {
    
    if (self.tableArrs.count < 3) {
        UITableView *addTableView = [[UITableView alloc] initWithFrame:CGRectMake(index * kScreenWidth, 0, kScreenWidth, contentScrollHeight) style:UITableViewStylePlain];
        addTableView.delegate = self;
        addTableView.dataSource = self;
        addTableView.tag = index;
        [self.contentScrollView addSubview:addTableView];
        [self.tableArrs addObject:addTableView];
    }
    [self.contentScrollView setContentSize:CGSizeMake((index + 1) * kScreenWidth, contentScrollHeight)];
    [self.contentScrollView setContentOffset:CGPointMake(index * kScreenWidth, 0) animated:animated];
    
}

#pragma mark - Getter Method
- (NSMutableArray *)titleArrs {
    if (!_titleArrs) {
        _titleArrs = [NSMutableArray arrayWithObject:@"请选择"];
    }
    return _titleArrs;
}

- (NSMutableArray *)tableArrs {
    if (!_tableArrs) {
        _tableArrs = [NSMutableArray array];
    }
    return _tableArrs;
}

@end
