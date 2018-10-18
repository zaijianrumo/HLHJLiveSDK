//
//  TMCommonDefine.h
//  CordovaLib
//
//  Created by ZhouYou on 2017/12/25.
//

#ifndef TMCommonDefine_h
#define TMCommonDefine_h

//根据RGB值获取颜色
#define TMColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//根据RGB值和alpha值获取颜色
#define TMCOLOR_RGB_ALPHA(rgbValue,i) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:(i)]

//debug日志信息
#define TMLog(msg, ...)\
{\
NSLog(@"[ %@:(%d)] %@<-- %@ -->",[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__,[NSString stringWithUTF8String:__FUNCTION__], [NSString stringWithFormat:(msg), ##__VA_ARGS__]);\
}

//weak self
#define TMWS(weakSelf)  __weak __typeof(&*self)weakSelf = self

#define TMSCREEN_RECT     [UIScreen mainScreen].bounds
#define TMSCREEN_WITH     [UIScreen mainScreen].bounds.size.width
#define TMSCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height

#define TMFORMAT(fmt,...)[NSString stringWithFormat:fmt,##__VA_ARGS__]

#define TMBundle(bundle)    [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:(bundle) ofType:@"bundle"]]

#endif /* TMCommonDefine_h */
