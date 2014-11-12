//
//  DrawPathView.h
//  DrawPath
//
//  Created by wuyj on 14-8-21.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface DrawPathItem: NSObject
@property (nonatomic, retain) NSNumber *flag;
@property (nonatomic, retain) NSValue  *path;
@end

/*
 百度大厦序号为0,
 奎科大厦序号为1,
 文思海辉序号为2,
 腾飞高科岭序号为3,
 鹏寰大厦序号为4,
 首创空间序号为5,

 以后要增加依次排
 */

typedef NS_ENUM(NSInteger, TowerIndex)
{
    TowerIndexNone = NSIntegerMax,//
    TowerIndexDasha = 3,
    TowerIndexKuiKe = 4,
    TowerIndexWeiSi = 5,
    TowerIndexKeJiYuan = 6,
    TowerIndexTengFei = 0,
    TowerIndexPengHuan = 1,
    TowerIndexShouChuang = 2,
};


@interface DrawPathView : UIView

// 路线的宽度，默认是6
@property (nonatomic, assign) NSInteger lineWidth;
// 未选中的路线
@property (nonatomic, retain) UIColor   *lineInvalidColor;
// 选中的路线
@property (nonatomic, retain) UIColor   *lineValidColor;


- (id)initWithFrame:(CGRect)frame towerNumber:(NSInteger)towerNumber;

// 顶点的CGPoint数组，坐标是本视图的bounds
- (NSArray* )getVertexs;

//====================================================================================================  
// item: DrawPathItem
// path: CGPoint类型（使用NSValue打包） 两个顶点的序号，例如，CGPonit pt = CGMakePoint(0,1),表示:百度大厦 到 首创
// flag: NSNumber类型, 这个路径是否标蓝 YES 标蓝；NO 标灰
//====================================================================================================
- (void)reloadPaths:(NSArray* )pathInfos;

@end
