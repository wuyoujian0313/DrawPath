//
//  DrawPathView.m
//  DrawPath
//
//  Created by wuyj on 14-8-21.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "DrawPathView.h"

@implementation DrawPathItem
@end

@interface DrawPathView ()
// 大厦的个数
@property (nonatomic, assign) NSInteger towerNumber;
@property (nonatomic, retain) NSArray *vertexPoints;
@property (nonatomic, retain) NSArray *pathInfos;

@end

@implementation DrawPathView

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame towerNumber:0];
}

- (UIColor *)colorWithHex:(NSInteger)hexValue
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0x00FF00) >> 8))/255.0
                            blue:((float)(hexValue & 0x0000FF))/255.0
                           alpha:1.0];
    
}

- (id)initWithFrame:(CGRect)frame towerNumber:(NSInteger)towerNumber
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.towerNumber = towerNumber;
        self.lineWidth = 6;
        
        self.lineInvalidColor = [UIColor grayColor];
        self.lineValidColor = [self colorWithHex:0x1ba9ba];
        
        [self calculateVertex1];
        // Initialization code
    }
    return self;
}

-(void)dealloc
{
    [_vertexPoints release];
    [_pathInfos release];
    [_lineInvalidColor release];
    [_lineValidColor release];

    [super dealloc];
}

- (void)calculateVertex1 {
    CGFloat r = self.bounds.size.width/2;  // 半径
    CGFloat x0 = self.bounds.origin.x + r; // 圆心x
    CGFloat y0 = self.bounds.origin.y + r; // 圆心y
    
    NSMutableArray *vertexs = [NSMutableArray arrayWithCapacity:0];
    
    CGFloat X1 = x0; // 已知一个顶点x
    CGFloat Y1 = r + y0; // 已知一个顶点y
    
    float angle = 2*M_PI/self.towerNumber;
    float b = atanf((Y1-y0)/(X1-x0));//反正切函数
    
    float x,y;
    for(int i = 0; i < self.towerNumber;i++) {
        x = r*cos(angle*i+b)+x0;
        y = r*sin(angle*i+b)+y0;
        
        CGPoint dPoint = CGPointMake(x, y);
        NSValue * dPointValue = [NSValue valueWithCGPoint:dPoint];
        [vertexs addObject:dPointValue];
    }
    
    self.vertexPoints = vertexs;
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

//===============================================================================================
// item：NSDictionary
// key1 = @"path" value:CGPoint类型 两个顶点的序号，例如，CGPonit pt = CGMakePoint(0,1),就表示:百度大厦 到 首创
// key2 = @"flag"  value: NSNumber , 这个路径是否标蓝 YES 标蓝；NO 标灰
//===============================================================================================
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
            DrawPathItem *tempPath = [self.pathInfos objectAtIndex:i];
            NSValue *tempPathPoint = [tempPath path];
            CGPoint tempPoint = [tempPathPoint CGPointValue];
            
            BOOL flag = [[tempPath flag] boolValue];
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
