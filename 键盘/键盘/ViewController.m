//
//  ViewController.m
//  键盘
//
//  Created by YT_lwf on 2018/3/23.
//  Copyright © 2018年 YT_lwf. All rights reserved.
//

#import "ViewController.h"
#import "KeyboardBar.h"


@interface ViewController (){
    UILabel * content;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    
    content = [[UILabel alloc] initWithFrame:CGRectMake(16, 100, 200, 100)];
    content.backgroundColor = [UIColor cyanColor];
    content.font = [UIFont systemFontOfSize:14];
    content.textColor = [UIColor redColor];
    [self.view addSubview:content];
    
    KeyboardBar * keyb =  [[KeyboardBar alloc] initWithFrame:CGRectMake(0, 400, CGRectGetWidth(self.view.bounds), 49)];
    [self.view addSubview:keyb];
}

@end
