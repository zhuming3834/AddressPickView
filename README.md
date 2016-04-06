# AddressPickView
这个地址选择器是在公司项目原来使用的一个基础上面修改的。使用了新的数据源和代理返回类型。<br>
使用效果图<br>
![](https://github.com/zhuming3834/AddressPickView/blob/master/2016-02-16%2010_51_41.gif)<br>
###具体使用
1.包含头文件#import "ChinaPlckerView.h"  <br>
2.关联代理ChinaPlckerViewDelegate <br>
3.调用方法<br>
```OC
[ChinaPlckerView customChinaPicker:self superView:self.view]; 
```
4.实现代理方法<br>
```OC
#pragma mark - ChinaPlckerViewDelegate  
- (void)chinaPlckerViewDelegateChinaModel:(ChinaArea *)chinaModel{  
    // 省  
    self.provinceLabel.text = [NSString stringWithFormat:@"NAME:%@ ID:%@ GRADE:%@ PARENT_AREA_ID:%@",chinaModel.provinceModel.NAME,chinaModel.provinceModel.ID,chinaModel.provinceModel.GRADE,chinaModel.provinceModel.PARENT_AREA_ID];  
    // 市  
    self.cityLabel.text = [NSString stringWithFormat:@"NAME:%@ ID:%@ GRADE:%@ PARENT_AREA_ID:%@",chinaModel.cityModel.NAME,chinaModel.cityModel.ID,chinaModel.cityModel.GRADE,chinaModel.cityModel.PARENT_AREA_ID];  
    // 区  
    self.areaLabel.text = [NSString stringWithFormat:@"NAME:%@ ID:%@ GRADE:%@ PARENT_AREA_ID:%@",chinaModel.areaModel.NAME,chinaModel.areaModel.ID,chinaModel.areaModel.GRADE,chinaModel.areaModel.PARENT_AREA_ID];  
}  
```
关于控件的具体实现和数据库的使用，可以参看我的博客<br>
[《【iOS】UIPickerView -- 地址选择器:省/市/区》](http://blog.csdn.net/zhuming3834/article/details/50673882)

