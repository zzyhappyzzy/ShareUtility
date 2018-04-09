//
//  ZZYImageManager.h
//  ShareUtility
//
//  Created by zhenzhaoyang on 2017/2/10.
//  Copyright © 2017年 zhenchy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZZYImageManager : NSObject


/**
 等比重画到指定像素范围内

 @param image 源图片
 @param size 尺寸(注意：单位是像素px，非point)
 @return 重画后的图片
 */
+ (UIImage *)redrawImage:(UIImage *)image toSize:(CGSize)sizePx;


/**
 修复图片方向

 @param img 源图
 @return 结果
 */
+ (UIImage *)fixOrientation:(UIImage *)img;


/**
 获取截图

 @param view 需要获取截图的视图
 @return 截图
 */
+ (UIImage *)getScreenshot:(UIView *)view;

@end
