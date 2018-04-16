//
//  ViewController.m
//  HelloMyAVFoundation
//
//  Created by user37 on 2018/2/26.
//  Copyright © 2018年 user37. All rights reserved.
//

#import "ViewController.h"
@import AVFoundation;
@interface ViewController ()

@end

@implementation ViewController
AVAudioPlayer *musicPlayer;
AVAudioRecorder *voiceRecoder;
AVAudioPlayer *voicePlayer;
- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"Dora.mp3" withExtension:nil];//withExtension 放副檔名
    musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    musicPlayer.numberOfLoops = -1;
    musicPlayer.volume = 0.2;
    [musicPlayer prepareToPlay];
    
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];

    //取得錄音權限
    [session requestRecordPermission:^(BOOL granted) {
        NSLog(@"User grant the permission: %@",granted?@"OK":@"NG");
    }];
}
- (IBAction)playMusicBtn:(id)sender {
    if (musicPlayer.isPlaying) {
        [musicPlayer pause];
    } else {
        [musicPlayer play];
    }
}
-(void)prepareRecording {
    //錄音設定
    NSDictionary *settings = @{AVFormatIDKey:@(kAudioFormatAppleIMA4),
                               AVSampleRateKey:@(22050.0),
                               AVNumberOfChannelsKey:@(1),
                               AVLinearPCMBitDepthKey:@(16),
                               AVLinearPCMIsBigEndianKey:@(false),
                               AVLinearPCMBitDepthKey:@(false)};
    //路徑
    NSURL *documentsURL = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask][0];
    NSURL *finURL = [documentsURL URLByAppendingPathComponent:@"record.caf"];
    voiceRecoder = [[AVAudioRecorder alloc] initWithURL:finURL settings:settings error:nil];
    //Audio Session
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
}
- (IBAction)recordBtn:(id)sender {
    if (voiceRecoder.isRecording) {
        [voiceRecoder stop];
        voiceRecoder = nil;
    } else {
        [self prepareRecording];
        [voiceRecoder record];
    }
}
- (IBAction)playRecordBtn:(id)sender {
    if (voicePlayer.isPlaying) {
        [voicePlayer stop];
        voicePlayer = nil;
    } else {
        NSURL *documentsURL = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask][0];
        NSURL *finURL = [documentsURL URLByAppendingPathComponent:@"record.caf"];
        voicePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:finURL error:nil];
        voicePlayer.numberOfLoops = -1;
        [voicePlayer play];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
