//
//  DrawPathView.h
//  DrawPath
//
//  Created by wuyj on 14-8-21.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TowerIndex)
{
    TowerIndexBaiDu = 0,
    TowerIndexShouChuang = 1,
    TowerIndexKuiKe = 2,
    TowerIndexPengHuan = 3,
    TowerIndexWeiSi = 4,
    TowerIndexTengFei = 5,
};


@interface DrawPathView : UIView

@property (nonatomic, assign) NSInteger towerNumber;
@property (nonatomic, assign) NSInteger lineWidth;
@property (nonatomic, retain) UIColor   *lineInvalidColor;
@property (nonatomic, retain) UIColor   *lineValidColor;

- (id)initWithFrame:(CGRect)frame towerNumber:(NSInteger)towerNumber;

// 顶点的CGPoint数组
- (NSArray* )getVertexs;

/*****************************************************************************************************
  
 item：NSDictionary
 key = @"path" value:CGPoint类型 两个顶点的序号，例如，CGPonit pt = CGMakePoint(0,1),就表示:百度大厦 到 首创
 百度大厦序号为0,
 首创空间序号为1,
 奎科大厦序号为2,
 鹏寰大厦序号为3,
 文思海辉序号为4,
 腾飞大厦序号为5,
 
 以后要增加依次排
 
 key = @"flag"  value: NSNumber , 这个路径是否标蓝 YES 标蓝；NO 标灰

******************************************************************************************************/

- (void)reloadPaths:(NSArray* )pathInfos;

@end
