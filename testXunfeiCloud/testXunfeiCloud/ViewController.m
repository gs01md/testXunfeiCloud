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

//其它
#import "iflyMSC/IFlySpeechUtility.h"
#import "iflyMSC/IFlySpeechConstant.h"



@interface ViewController ()<
IFlyRecognizerViewDelegate,
IFlySpeechRecognizerDelegate
>
{
    IFlyRecognizerView      *_iflyRecognizerView;
    
    IFlySpeechRecognizer * m_flySpeechRecognizer;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self startRecognizerNoView];
}

- (void) startRecognizerNoView {

    if (!m_flySpeechRecognizer) {
        
        NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",@""];
        [IFlySpeechUtility createUtility:initString];
        
        //初始化语音识别控件
        m_flySpeechRecognizer = [IFlySpeechRecognizer sharedInstance] ;
        
        m_flySpeechRecognizer.delegate = self;
        [m_flySpeechRecognizer setParameter: @"iat" forKey: [IFlySpeechConstant IFLY_DOMAIN]];
        
        //[m_flySpeechRecognizer setParameter: @"iat" forKey: [IFlySpeechConstant LANGUAGE]];
        
        
        [m_flySpeechRecognizer setParameter: @"plain" forKey: [IFlySpeechConstant RESULT_TYPE]];
        
        //asr_audio_path保存录音文件名，如不再需要，设置value为nil表示取消，默认目录是documents
        [m_flySpeechRecognizer setParameter:nil forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    }
    
    
    
    //启动识别服务--每次识别完成，或者隔一段时间，就要重启启动一次
    [m_flySpeechRecognizer startListening];

}

- (void) startRecognizer {
    
    if (!_iflyRecognizerView) {
        
        NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",@""];
        [IFlySpeechUtility createUtility:initString];
        
        //初始化语音识别控件
        _iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
        
        [self.view addSubview:_iflyRecognizerView];
        _iflyRecognizerView.delegate = self;
        [_iflyRecognizerView setParameter: @"iat" forKey: [IFlySpeechConstant IFLY_DOMAIN]];
        //asr_audio_path保存录音文件名，如不再需要，设置value为nil表示取消，默认目录是documents
        [_iflyRecognizerView setParameter:nil forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    }
    
    
    
    //启动识别服务--每次识别完成，或者隔一段时间，就要重启启动一次
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
    
    //NSLog(@"%@",error);
    
    [self startRecognizerNoView];
}


#pragma mark - 无界面版本的代理
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast{
    
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic       = [results objectAtIndex:0];
    for (NSString *key in dic){
        [result appendFormat:@"%@",key];//合并结果
    }
    
    if (result.length>0) {
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"消息" message:result preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];

        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    

}


@end
