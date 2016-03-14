//
//  ChinaPlckerView.m
//  地址选择器
//
//  Created by zhuming on 16/2/15.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "ChinaPlckerView.h"

// 屏幕的高度
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

// 屏幕的宽度
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width

//键盘高度 253
#define IT_KEYBOARD_HEIGHT 253

#define ROW_HEIGHT  30

//设置RGB颜色值
#define COLOR(R,G,B,A)	[UIColor colorWithRed:(CGFloat)R/255.0 green:(CGFloat)G/255.0 blue:(CGFloat)B/255.0 alpha:A]

@interface ChinaPlckerView ()<UIPickerViewDataSource,UIPickerViewDelegate>
/**
 *  地址选择器
 */
@property (nonatomic,strong)UIPickerView *pickerView;
/**
 *  确定按钮
 */
@property (nonatomic,strong)UIButton *sureButton;
/**
 *  蒙蔽曾
 */
@property (nonatomic,strong)UIView *hideView;
/**
 *  选择器视图
 */
@property (nonatomic,strong)UIView *addPickVview;
/**
 *  数据模型
 */
@property (nonatomic,strong)ChinaArea *chinaModel;
/**
 *  选择的省份ID
 */
@property (nonatomic,strong)NSString *selectedProvinceID;
/**
 *  选择的城市ID
 */
@property (nonatomic,strong)NSString *selectedCityID;
/**
 *  选择的区域ID
 */
@property (nonatomic,strong)NSString *selectedAreaID;

@end

@implementation ChinaPlckerView

/**
 *  添加城市选择器
 *
 *  @param delegate 代理
 *  @param views    父视图
 *
 *  @return 城市选择器
 */
+(ChinaPlckerView *)customChinaPicker:(id)delegate superView:(UIView*)views{
    
    UIView *oldView = [views viewWithTag:0x123];
    if ([oldView isKindOfClass:[ChinaPlckerView class]]) {
        ChinaPlckerView *navView =  (ChinaPlckerView *)oldView;
        navView.delegate = delegate;
        [navView showChinaPickerView];
        return navView;
    }
    ChinaPlckerView *navView = [[ChinaPlckerView alloc] init];
    navView.delegate = delegate;
    [navView showChinaPickerView];
    navView.tag = 0x123;
    [views addSubview:navView];
    return navView;
}
/**
 *  重写父类的init方法
 *
 *  @return self
 */
- (instancetype)init{
    if (self = [super init]) {
        [self initPickerView];
    }
    return self;
}
/**
 *  确定按钮按下
 */
- (void)btnClick{
    if ([_delegate respondsToSelector:@selector(chinaPlckerViewDelegateChinaModel:)]) {
        [_delegate chinaPlckerViewDelegateChinaModel:self.chinaModel];
    }
    [self hideChinaPickerView];
}
/**
 *  触摸屏幕其他地方收起选择器
 */
- (void)tapClick{
    [self hideChinaPickerView];
}
/**
 *  创建城市选择器
 */
- (void)initPickerView{
    // 模型的初始化
    self.chinaModel = [[ChinaArea alloc] init];
    
    // 默认
    self.selectedProvinceID = @"2";  // 北京市
    self.selectedCityID = @"52";     // 北京市
    self.selectedAreaID = @"500";    // 东城区
    
    self.chinaModel.provinceModel = ((ProvinceModel *)[self.chinaModel getProvinceDataByID:self.selectedProvinceID]);
    self.chinaModel.cityModel = ((CityModel *)[self.chinaModel getCityDataByID:self.selectedCityID]);
    self.chinaModel.areaModel = ((AreaModel *)[self.chinaModel getAreaDataByID:self.selectedAreaID]);
    
    // 初始化视图
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.userInteractionEnabled = YES;
    self.hidden = YES;
    self.backgroundColor = [UIColor clearColor];
    // 蒙蔽层
    self.hideView = [[UIView alloc] init];
    self.hideView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.hideView.backgroundColor = COLOR(45, 47, 56, 0.0f);
    [self addSubview:self.hideView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [self.hideView addGestureRecognizer:tap];
    //添加选择器
    self.addPickVview = [[UIView alloc]init];
    self.addPickVview.frame = CGRectMake(0,  kScreenHeight -  IT_KEYBOARD_HEIGHT, kScreenWidth, IT_KEYBOARD_HEIGHT);
    self.addPickVview.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.addPickVview];
    //确认按钮
    CGFloat titleHeight =  IT_KEYBOARD_HEIGHT - 216;
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth,titleHeight)];
    //titleView.backgroundColor = [UIColor blueColor];
    [self.addPickVview addSubview:titleView];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(kScreenWidth - 70, 0, 60, titleHeight);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitle:@"确定" forState:UIControlStateHighlighted];
    [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [sureBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:sureBtn];
    // UIPickerView
    UIPickerView  *pickerView = [[UIPickerView alloc] init];
    pickerView.frame = CGRectMake(0, CGRectGetMaxY(titleView.frame), kScreenWidth, 216);
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.backgroundColor = [UIColor whiteColor];
    [self.addPickVview addSubview:pickerView];
    self.pickerView = pickerView;
    
    [self.pickerView selectRow:0 inComponent:0 animated:YES];
    [self.pickerView selectRow:0 inComponent:1 animated:YES];
    [self.pickerView selectRow:0 inComponent:2 animated:YES];
}
#pragma mark - UIPickerViewDataSource,UIPickerViewDelegate
/**
 *  设置pickerView的列数
 *
 *  @param pickerView pickerView description
 *
 *  @return pickerView的列数
 */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
/**
 *  设置每一列显示的数量
 *
 *  @param pickerView pickerView description
 *  @param component  列
 *
 *  @return 美列的数量
 */
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) { // 省份
        return [self.chinaModel getAllProvinceData].count;
    }
    else if (component == 1){ // 城市
        return [self.chinaModel getCityDataByParentID:self.selectedProvinceID].count;
    }
    else{ // 区域
        return [self.chinaModel getAreaDataByParentID:self.selectedCityID].count;
    }
}
/**
 *  设置每一列的宽度
 *
 *  @param pickerView pickerView description
 *  @param component  列
 *
 *  @return 每列的宽度
 */
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return (kScreenWidth - 20)/3;
}
/**
 *  设置每一行的高度
 *
 *  @param pickerView pickerView description
 *  @param component  列
 *
 *  @return 每一行的高度
 */
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return ROW_HEIGHT;
}
/**
 *  设置每一行的显示视图
 *
 *  @param pickerView pickerView description
 *  @param row        每一类的row
 *  @param component  列
 *  @param view       view description
 *
 *  @return 每一列每一行的视图
 */
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    if (component == 0) { // 省份
        if (!view) {
            view = [[UIView alloc] init];
        }
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.frame = CGRectMake(0, 0, (kScreenWidth - 20)/3, ROW_HEIGHT);
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.text = ((ProvinceModel *)[self.chinaModel getAllProvinceData][row]).NAME;
        textLabel.font = [UIFont systemFontOfSize:14];
        textLabel.textColor = COLOR(51, 51, 51, 1);
        [view addSubview:textLabel];
        return view;
    }
    else if (component == 1){ // 城市
        if (!view) {
            view = [[UIView alloc] init];
        }
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.frame = CGRectMake(0, 0, (kScreenWidth - 20)/3, ROW_HEIGHT);
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.text = ((CityModel *)[self.chinaModel getCityDataByParentID:self.selectedProvinceID][row]).NAME;
        textLabel.font = [UIFont systemFontOfSize:14];
        textLabel.textColor = COLOR(51, 51, 51, 1);
        [view addSubview:textLabel];
        return view;
    }
    else{ // 区域
        if (!view) {
            view = [[UIView alloc] init];
        }
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.frame = CGRectMake(0, 0, (kScreenWidth - 20)/3, ROW_HEIGHT);
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.text = ((AreaModel *)[self.chinaModel getAreaDataByParentID:self.selectedCityID][row]).NAME;
        textLabel.font = [UIFont systemFontOfSize:14];
        textLabel.textColor = COLOR(51, 51, 51, 1);
        [view addSubview:textLabel];
        return view;
    }
}
/**
 *  pickerView选中代理
 *
 *  @param pickerView pickerView description
 *  @param row        选中的row
 *  @param component  列
 */
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (component) {
        case 0:{ // 选择省份
            self.selectedProvinceID = ((ProvinceModel *)[self.chinaModel getAllProvinceData][row]).ID;
            [pickerView reloadComponent:1]; // 重载城市
            [pickerView selectRow:0 inComponent:1 animated:YES];
            self.chinaModel.provinceModel = (ProvinceModel *)[self.chinaModel getAllProvinceData][row];
            // 选择了省份就自动定位到该省的第一个市
            self.selectedCityID = ((CityModel *)[self.chinaModel getCityDataByParentID:self.selectedProvinceID][0]).ID;
            self.chinaModel.cityModel = (CityModel *)[self.chinaModel getCityDataByParentID:self.selectedProvinceID][0];
            
            // 选择了省份就自动定位到该省的第一个市的第一个区
            [pickerView  reloadComponent:2]; // 重载区域
            [pickerView selectRow:0 inComponent:2 animated:YES];
            // 海南 有的市没有区  真是坑啊
            if ([self.chinaModel getAreaDataByParentID:self.selectedCityID].count > 0) {
                self.chinaModel.areaModel = (AreaModel *)[self.chinaModel getAreaDataByParentID:self.selectedCityID][0];
            }
            else{
                self.chinaModel.areaModel.NAME = @"";
                self.chinaModel.areaModel.ID = @"";
                self.chinaModel.areaModel.PARENT_AREA_ID = @"9";
                self.chinaModel.areaModel.GRADE = @"3";
            }
            break;
        }
        case 1:{ // 选择城市
            self.selectedCityID = ((CityModel *)[self.chinaModel getCityDataByParentID:self.selectedProvinceID][row]).ID;
            [pickerView  reloadComponent:2]; // 重载区域
            [pickerView selectRow:0 inComponent:2 animated:YES];
            self.chinaModel.cityModel = (CityModel *)[self.chinaModel getCityDataByParentID:self.selectedProvinceID][row];
            // 选择了市就定位到该市的第一个区
            // 海南 有的市没有区  真是坑啊
            if ([self.chinaModel getAreaDataByParentID:self.selectedCityID].count > 0) {
                self.chinaModel.areaModel = (AreaModel *)[self.chinaModel getAreaDataByParentID:self.selectedCityID][0];
            }
            else{
                self.chinaModel.areaModel.NAME = @"";
                self.chinaModel.areaModel.ID = @"";
                self.chinaModel.areaModel.PARENT_AREA_ID = @"9";
                self.chinaModel.areaModel.GRADE = @"3";
            }
            
            break;
        }
        case 2: // 选择区域
            // 海南 有的市没有区  真是坑啊
            if ([self.chinaModel getAreaDataByParentID:self.selectedCityID].count > 0) {
                self.chinaModel.areaModel = (AreaModel *)[self.chinaModel getAreaDataByParentID:self.selectedCityID][row];
            }
            else{
                self.chinaModel.areaModel.NAME = @"";
                self.chinaModel.areaModel.ID = @"";
                self.chinaModel.areaModel.PARENT_AREA_ID = @"9";
                self.chinaModel.areaModel.GRADE = @"3";
            }
            break;
        default:
            break;
    }

    if ([_delegate respondsToSelector:@selector(chinaPlckerViewDelegateChinaModel:)]) {
        [_delegate chinaPlckerViewDelegateChinaModel:self.chinaModel];
    }
}

#pragma mark - 显示
-(void)showChinaPickerView
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    self.hidden = NO;
    [UIView animateWithDuration:0.25f animations:^{
        float pikceY =  kScreenHeight - IT_KEYBOARD_HEIGHT;
        self.addPickVview.frame = CGRectMake(0, pikceY, kScreenWidth, IT_KEYBOARD_HEIGHT);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25f animations:^{
            self.hideView.backgroundColor = COLOR(45, 47, 56, 0.2f);
        } completion:^(BOOL finished) {
            
        }];
    }];
}
#pragma mark - 隐藏
-(void)hideChinaPickerView
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [UIView animateWithDuration:0.25f animations:^{
        float pikceY =  kScreenHeight;
        self.addPickVview.frame = CGRectMake(0, pikceY, kScreenWidth, IT_KEYBOARD_HEIGHT);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25f animations:^{
            self.hideView.backgroundColor = COLOR(45, 47, 56, 0.0f);
        } completion:^(BOOL finished) {
            self.hidden = YES;
        }];
    }];
    
    if ([_delegate respondsToSelector:@selector(chinaPickerViewDelegateHidden)]) {
        [_delegate chinaPickerViewDelegateHidden];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
