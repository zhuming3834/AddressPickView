//
//  ViewController.m
//  地址选择器
//
//  Created by zhuming on 16/2/15.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "ViewController.h"
#import "ChinaPlckerView.h"

@interface ViewController ()<ChinaPlckerViewDelegate>
/**
 *  省份显示Label
 */
@property (weak, nonatomic) IBOutlet UILabel *provinceLabel;
/**
 *  城市显示Label
 */
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
/**
 *  地区显示Label
 */
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
/**
 *  点击按钮显示地址选择器
 *
 *  @param sender sender description
 */
- (IBAction)btnClick:(UIButton *)sender {
    [ChinaPlckerView customChinaPicker:self superView:self.view];
}
#pragma mark - ChinaPlckerViewDelegate
- (void)chinaPlckerViewDelegateChinaModel:(ChinaArea *)chinaModel{
    // 省
    self.provinceLabel.text = [NSString stringWithFormat:@"NAME:%@ ID:%@ GRADE:%@ PARENT_AREA_ID:%@",chinaModel.provinceModel.NAME,chinaModel.provinceModel.ID,chinaModel.provinceModel.GRADE,chinaModel.provinceModel.PARENT_AREA_ID];
    // 市
    self.cityLabel.text = [NSString stringWithFormat:@"NAME:%@ ID:%@ GRADE:%@ PARENT_AREA_ID:%@",chinaModel.cityModel.NAME,chinaModel.cityModel.ID,chinaModel.cityModel.GRADE,chinaModel.cityModel.PARENT_AREA_ID];
    // 区
    self.areaLabel.text = [NSString stringWithFormat:@"NAME:%@ ID:%@ GRADE:%@ PARENT_AREA_ID:%@",chinaModel.areaModel.NAME,chinaModel.areaModel.ID,chinaModel.areaModel.GRADE,chinaModel.areaModel.PARENT_AREA_ID];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end














