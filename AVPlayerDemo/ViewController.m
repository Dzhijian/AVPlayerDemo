//
//  ViewController.m
//  AVPlayerDemo
//
//  Created by 邓志坚 on 2018/10/10.
//  Copyright © 2018 邓志坚. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface ViewController ()

// 播放器
@property (nonatomic, strong) AVPlayer *myPlayer;
// 播放单元
@property (nonatomic, strong) AVPlayerItem *playerItem;
// 播放界面
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@property (nonatomic, strong) NSURL *url;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpAVPlayer];
}


-(void)setUpAVPlayer{
    self.url = [NSURL URLWithString:@"http://pgdqlz2dz.bkt.clouddn.com/test.mp4"];
    self.playerItem = [AVPlayerItem playerItemWithURL:_url];
    self.myPlayer = [AVPlayer playerWithPlayerItem:_playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.myPlayer];
    self.playerLayer.frame = CGRectMake(0, 100, self.view.bounds.size.width, 200);
    [self.view.layer addSublayer:self.playerLayer];
    
//    [self.myPlayer play];
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        switch (_playerItem.status) {
                case AVPlayerItemStatusReadyToPlay:
                //推荐将视频播放放在这里
                [self.myPlayer play];
                break;
                
                case AVPlayerItemStatusUnknown:
                NSLog(@"AVPlayerItemStatusUnknown");
                break;
                
                case AVPlayerItemStatusFailed:
                NSLog(@"AVPlayerItemStatusFailed");
                break;
                
            default:
                break;
        }
        
    }
}

@end
