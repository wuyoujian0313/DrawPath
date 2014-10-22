//
//  DrawPathView.m
//  DrawPath
//
//  Created by wuyj on 14-8-21.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "DrawPathView.h"

@interface DrawPathView ()
@property (nonatomic, retain) NSArray *vertexPoints;
@property (nonatomic, retain) NSArray *pathInfos;

@end

@implementation DrawPathView

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame towerNumber:0];
}

- (id)initWithFrame:(CGRect)frame towerNumber:(NSInteger)towerNumber
{
    self = [super initWithFrame:frame];
    if (self) {
        self.towerNumber = towerNumber;
        self.lineWidth = 6;
        
        self.lineInvalidColor = [UIColor grayColor];
        self.lineValidColor = [UIColor blueColor];
        
        [self calculateVertex];
        // Initialization code
    }
    return self;
}

-(void)dealloc
{
    [_vertexPoints release];
    self.vertexPoints = nil;
    
    [_pathInfos release];
    self.pathInfos = nil;
    
    [super dealloc];
}


- (void)calculateVertex
{
    // 计算边对角
    CGFloat sideAngle = M_PI*2/self.towerNumber;
    
    // 计算开始的角度
    CGFloat startAngle = 0;
    
	CGFloat w = self.bounds.size.width/2;
	CGFloat h = self.bounds.size.height/2;
	CGFloat x = self.bounds.origin.x + w;
	CGFloat y = self.bounds.origin.y + h;
    
    // 往里缩一点
    w *= 0.8;
	h *= 0.8;
    
    NSMutableArray *vertexs = [NSMutableArray arrayWithCapacity:0];
    
    // 计算序号0的piont
    CGPoint startPoint = CGPointMake(x, y-h);
    NSValue * startPointValue = [NSValue valueWithCGPoint:startPoint];
    [vertexs addObject:startPointValue];
    
    // 计算其他序号的piont
    for (int i = 1; i < self.towerNumber; i++) {
        
        startAngle += sideAngle;
        CGFloat dx = x + w * sinf(startAngle);
        CGFloat dy = y - h * cosf(startAngle);
        
        CGPoint dPoint = CGPointMake(dx, dy);
        NSValue * dPointValue = [NSValue valueWithCGPoint:dPoint];
        [vertexs addObject:dPointValue];
    }
    
    self.vertexPoints = vertexs;
}


- (NSArray* )getVertexs
{
    return [self.vertexPoints copy];
}

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

- (void)reloadPaths:(NSArray* )pathInfos
{
    self.pathInfos = pathInfos;
    [self setNeedsDisplay];
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    if (self.pathInfos != nil && [self.pathInfos count] > 0) {

        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, self.lineWidth);
        
        for (int i = 0; i < [self.pathInfos count]; i ++) {
            NSDictionary *tempPath = [self.pathInfos objectAtIndex:i];
            NSValue *tempPathPoint = [tempPath objectForKey:@"path"];
            CGPoint tempPoint = [tempPathPoint CGPointValue];
            
            BOOL flag = [[tempPath objectForKey:@"flag"] boolValue];
            UIColor *lineColor = flag ? self.lineValidColor : self.lineInvalidColor;
            CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
            CGContextSetLineCap(context,kCGLineCapRound);
            
            NSInteger startIndex = (NSInteger)tempPoint.x;
            if (startIndex < [self.vertexPoints count]) {
                CGPoint startPoint = [[self.vertexPoints objectAtIndex:startIndex] CGPointValue];
                CGContextMoveToPoint(context, startPoint.x, startPoint.y); 
            }
            
            
            NSInteger endIndex = (NSInteger)tempPoint.y;
            if (endIndex < [self.vertexPoints count]) {
                CGPoint endPoint = [[self.vertexPoints objectAtIndex:endIndex] CGPointValue];
                CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
            }
            
            CGContextStrokePath(context); 
        }
    }
}


@end
