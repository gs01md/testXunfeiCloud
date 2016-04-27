//
//  ViewController.m
//  testXunfeiCloud
//
//  Created by WoodGao on 16/4/27.
//  Copyright © 2016年 wood. All rights reserved.
//

#import "ViewController.h"

//带界面的语音识别控件

#import "iflyMSC/IFlyRecognizerViewDelegate.h"

#import "iflyMSC/IFlyRecognizerView.h"



//不带界面的语音识别控件

#import "iflyMSC/IFlySpeechRecognizerDelegate.h"

#import "iflyMSC/IFlySpeechRecognizer.h"

#import "iflyMSC/IFlySpeechUtility.h"

#import "iflyMSC/IFlySpeechConstant.h"



@interface ViewController ()<
IFlyRecognizerViewDelegate
>
{
    IFlyRecognizerView      *_iflyRecognizerView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self startRecognizer];
}

- (void) startRecognizer {
    
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",@""];
    [IFlySpeechUtility createUtility:initString];
    
    //初始化语音识别控件
    _iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
    
    [self.view addSubview:_iflyRecognizerView];
    _iflyRecognizerView.delegate = self;
    [_iflyRecognizerView setParameter: @"iat" forKey: [IFlySpeechConstant IFLY_DOMAIN]];
    //asr_audio_path保存录音文件名，如不再需要，设置value为nil表示取消，默认目录是documents
    [_iflyRecognizerView setParameter:nil forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    //启动识别服务
    [_iflyRecognizerView start];
}




/*识别结果返回代理
 @param resultArray 识别结果
 @ param isLast 表示是否最后一次结果
 */
- (void)onResult: (NSArray *)resultArray isLast:(BOOL) isLast
{
    
    NSLog(@"%@",resultArray);
    
}
/*识别会话错误返回代理
 @ param  error 错误码
 */
- (void)onError: (IFlySpeechError *) error
{
    
    NSLog(@"%@",error);
    
    [self startRecognizer];
}

@end
