//
//  ZJPlayVideoViewController.m
//  AVPlayerDemo
//
//  Created by 邓志坚 on 2018/10/10.
//  Copyright © 2018 邓志坚. All rights reserved.
//

#import "ZJPlayVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface ZJPlayVideoViewController ()

// 播放器
@property (nonatomic, strong) AVPlayer *myPlayer;
// 播放单元
@property (nonatomic, strong) AVPlayerItem *playerItem;
// 播放界面
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@property (nonatomic, strong) NSURL *url;
@end

@implementation ZJPlayVideoViewController

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
    
    //[self.myPlayer play];
    // 监听 playerItem 状态改变时 播放视频
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    /**
     *  - (id)addPeriodicTimeObserverForInterval:(CMTime)interval queue:(nullable dispatch_queue_t)queue usingBlock:(void (^)(CMTime time))block;
     *  监听播放进度,系统方法
     *  参数一: interval ,CMTime类型
     *  参数二: queue,传入 nil, 默认在主线程中调用
     *  block回调 : time 为CMTime类型
     
     typedef struct{
         CMTimeValue    value;     // 帧数
         CMTimeScale    timescale;  // 帧率（影片每秒有几帧）
         CMTimeFlags    flags;
         CMTimeEpoch    epoch;
         } CMTime;
     
     */
    __weak typeof(self) weakSelf = self;
    [self.myPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:nil usingBlock:^(CMTime time) {
        
        AVPlayerItem *item = weakSelf.playerItem;
        if (item.currentTime.timescale <= 0) {
            return;
        }
        // 获取当前播放时间，可以用value/timescale的方式
        NSInteger currentTime = item.currentTime.value/item.currentTime.timescale;
        NSLog(@"当前播放时间%ld",currentTime);
    }];
    
    // loadedTimeRange 缓存时间
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    // 监听playbackBufferEmpty我们可以获取当缓存不够，视频加载不出来的情况：
    [self.playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    
    // playbackLikelyToKeepUp 监听缓存足够时播放状态
    // bplaybackLikelyToKeepUp和playbackBufferEmpty是一对，用于监听缓存足够播放的状态
    [self.playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    
    /**
     *  播放相关通知
     *  1.声音类
     *  //声音被打断的通知（电话打来）
        AVAudioSessionInterruptionNotification
        //耳机插入和拔出的通知
        AVAudioSessionRouteChangeNotification
     *
     *  2. 播放类
     *  //播放完成
        AVPlayerItemDidPlayToEndTimeNotification
        //播放失败
        AVPlayerItemFailedToPlayToEndTimeNotification
        //异常中断
        AVPlayerItemPlaybackStalledNotification
     *
     *  3.系统状态
     *  //进入后台
        UIApplicationWillResignActiveNotification
        //返回前台
        UIApplicationDidBecomeActiveNotification
     */
 
    
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        switch (_playerItem.status) {
                // 视频将准备播放
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
        
    }else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSArray *array = _playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
        NSLog(@"当前缓冲时间--->：%f",totalBuffer);
        
    }else if([keyPath isEqualToString:@"playbackBufferEmpty"]){
        // 缓存不够,自动暂停播放
        NSLog(@"缓存不够,自动暂停播放");
    }else if([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        //由于 AVPlayer 缓存不足就会自动暂停，所以缓存充足了需要手动播放，才能继续播放
        NSLog(@"缓存足够,继续播放");
        [_myPlayer play];
    }
   
    /**
     * AVURLAsset
     * 播放视频只需一个url就能进行这样太不安全了，别人可以轻易的抓包盗链，为此我们需要为视频链接做一个请求头的认证，这个功能可以借助AVURLAsset完成。
     *
     * AVPlayerItem除了可以用URL初始化，还可以用AVAsset初始化，而AVAsset不能直接使用，我们看下AVURLAsset的一个初始化方法
     * + (instancetype)URLAssetWithURL:(NSURL *)URL options:(nullable NSDictionary<NSString *, id> *)options;
     * AVURLAssetPreferPreciseDurationAndTimingKey.这个key对应的value是一个布尔值, 用来表明资源是否需要为时长的精确展示,以及随机时间内容的读取进行提前准备。
     */
}

-(void)dealloc{
    // 销毁观察者
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [self.playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    NSLog(@"ZJPlayVideoViewController 销毁了");
}
@end
