//
//  ViewController.m
//  DrawPath
//
//  Created by wuyj on 14-8-21.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "ViewController.h"
#import "DrawPathView.h"
#include <objc/runtime.h>


@interface ViewController ()

@end


@interface NSString (TestEx)
-(NSString*)lowercaseStringNew;

@end

@implementation NSString (TestEx)

-(NSString*)lowercaseStringNew{
    NSLog(@"lowercaseStringNew");
    return [self lowercaseStringNew];
}

@end

@implementation ViewController




-(void)test
{
    Method origMethod1 = class_getInstanceMethod([NSString class], @selector(lowercaseString));
    Method newMethod1 = class_getInstanceMethod([NSString class], @selector(lowercaseStringNew));
    
    method_exchangeImplementations(origMethod1, newMethod1);
}

- (void)changeAction
{
    [self test];
    
    NSString* str = @"QWER";
    NSString *str1 = [str lowercaseString];
    
    static NSInteger i = 1;
    if (i >= 0 && i < 5) {
        i ++;
    }else{
        i = 0;
    }
    
    DrawPathView *drawPath = (DrawPathView*)[self.view viewWithTag:100];
    NSArray *paths = [self getPaths:i];
    [drawPath reloadPaths:paths];
}

- (NSArray*)getPaths:(NSInteger)index
{
    NSMutableArray * paths = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    
    for (int i = 0; i < 6; i ++) {
        if (i != index) {
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
            NSValue *line = [NSValue valueWithCGPoint:CGPointMake(index, i)];
            if (i == 2) {
                NSNumber *flag = [NSNumber numberWithBool:YES];
                [dic setObject:flag forKey:@"flag"];
            }else{
                NSNumber *flag = [NSNumber numberWithBool:NO];
                [dic setObject:flag forKey:@"flag"];
            }
            
            
            [dic setObject:line forKey:@"path"];
            [paths addObject:dic];
        }
        
    }
    return paths;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(120, 20, 80, 30)];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitle:@"change" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(changeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    [self.view setBackgroundColor:[UIColor grayColor]];
	// Do any additional setup after loading the view, typically from a nib.
    
    DrawPathView *drawPath = [[DrawPathView alloc] initWithFrame:CGRectMake(10, 80, 300, 300) towerNumber:6];
    [drawPath setTag:100];
    [drawPath setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:drawPath];
    
    NSArray *paths = [self getPaths:0];

    [drawPath reloadPaths:paths];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
