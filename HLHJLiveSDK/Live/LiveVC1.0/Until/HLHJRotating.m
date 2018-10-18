//
//  HLHJRotating.m
//  HLHJLiveSDK
//
//  Created by mac on 2018/5/22.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJRotating.h"

@implementation HLHJRotating

// 开始旋转
-(void)hlhjstartRotating {
    CABasicAnimation* rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotateAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    rotateAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2];   // 旋转一周
    rotateAnimation.duration = 10.0;                                 // 旋转时间10秒
    rotateAnimation.repeatCount = MAXFLOAT;                          // 重复次数，这里用最大次数
    
    [self.layer addAnimation:rotateAnimation forKey:nil];
    
}
// 停止旋转
-(void)hlhjstopRotating {
    
    CFTimeInterval pausedTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.layer.speed = 0.0;                                          // 停止旋转
    self.layer.timeOffset = pausedTime;                              // 保存时间，恢复旋转需要用到
}
// 恢复旋转
-(void)hlhjresumeRotate {
    
    if (self.layer.timeOffset == 0) {
        [self hlhjstartRotating];
        return;
    }
    
    CFTimeInterval pausedTime = self.layer.timeOffset;
    self.layer.speed = 1.0;                                         // 开始旋转
    self.layer.timeOffset = 0.0;
    self.layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;                                             // 恢复时间
    self.layer.beginTime = timeSincePause;                          // 从暂停的时间点开始旋转
}

@end
