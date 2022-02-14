//
//  ViewController.m
//  TowardComponent
//
//  Created by xiaomai on 2022/2/14.
//

#import "ViewController.h"
#import "XMScreenToward.h"

@interface ViewController ()<TowardDelegate> {
    UILabel *testUI;
    UIButton *startBtn;
    UIButton *endBtn;
    XMScreenToward *screentoward;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self creatTestUI];
    
    [self setXMScreenToward];
}

- (void)creatTestUI {
    testUI = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 150, 40)];
    testUI.text = @"TestUI";
    testUI.textAlignment = NSTextAlignmentCenter;
    testUI.backgroundColor= [UIColor orangeColor];
    [self.view addSubview:testUI];

    
    startBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [startBtn setTitle:@"开始" forState:UIControlStateNormal];
    startBtn.frame = CGRectMake(100, testUI.frame.origin.y+40+23, 150, 40);
    startBtn.backgroundColor= [UIColor grayColor];
    [self.view addSubview:startBtn];
    [startBtn addTarget:self action:@selector(startBtnActon) forControlEvents:UIControlEventTouchUpInside];
    
    endBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [endBtn setTitle:@"停止" forState:UIControlStateNormal];
    endBtn.frame = CGRectMake(100, startBtn.frame.origin.y+40+23, 150, 40);
    endBtn.backgroundColor= [UIColor grayColor];
    [self.view addSubview:endBtn];
    [endBtn addTarget:self action:@selector(endBtnActon) forControlEvents:UIControlEventTouchUpInside];
}

- (void)startBtnActon {
    [screentoward startHandling];//开始监听
}

- (void)endBtnActon {
    [screentoward stopHandling];//开始监听
}

- (void)setXMScreenToward {
    screentoward = [XMScreenToward sharedInstance];
    [screentoward registerHandler:self];
}

#pragma mark --TowardDelegate
- (void)deviceMotionNotAvailable {
    NSLog(@"检测到没有设备传感器");
}

- (void)deviceMotionToWardDown {
    NSLog(@"检测到了屏幕方向朝下翻转");
    
    //TO DO
    testUI.hidden = !testUI.hidden;
}

- (void)deviceMotionToWardUp {
    NSLog(@"检测到了屏幕方向朝上翻转");
}

@end
