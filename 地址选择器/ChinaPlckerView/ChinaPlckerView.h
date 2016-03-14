//
//  ChinaPlckerView.h
//  地址选择器
//
//  Created by zhuming on 16/2/15.
//  Copyright © 2016年 zhuming. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ChinaArea.h"

@protocol ChinaPlckerViewDelegate <NSObject>

@optional
/**
 *  获取地址选择器的数据模型
 *
 *  @param chinaModel ChinaArea数据模型
 */
- (void)chinaPlckerViewDelegateChinaModel:(ChinaArea *)chinaModel;
/**
 *  收起选择器
 */
- (void)chinaPickerViewDelegateHidden;

@end

@interface ChinaPlckerView : UIView

@property (nonatomic,assign) id<ChinaPlckerViewDelegate> delegate;
/**
 *  添加城市选择器
 *
 *  @param delegate 代理
 *  @param views    父视图
 *
 *  @return 城市选择器
 */
+(ChinaPlckerView *)customChinaPicker:(id)delegate superView:(UIView*)views;

@end
