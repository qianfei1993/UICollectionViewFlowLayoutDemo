//
//  NSString+Size.h
//  APPTool
//
//  Created by 夏东健 on 2018/11/6.
//  Copyright © 2018年 夏东健. All rights reserved.
//  字符串高度计算相关方法

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface NSString (Size)

/**
 *  @brief 计算文字的高度
 *
 *  @param font  字体(默认为系统字体)
 *  @param width 约束宽度
 */
- (CGFloat)heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;
/**
 *  @brief 计算文字的宽度
 *
 *  @param font   字体(默认为系统字体)
 *  @param height 约束高度
 */
- (CGFloat)widthWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height;

/**
 *  @brief 计算文字的大小
 *
 *  @param font  字体(默认为系统字体)
 *  @param width 约束宽度
 */
- (CGSize)sizeWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;
/**
 *  @brief 计算文字的大小
 *
 *  @param font   字体(默认为系统字体)
 *  @param height 约束高度
 */
- (CGSize)sizeWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height;

/**
 *  @brief  反转字符串
 *
 *  @param strSrc 被反转字符串
 *
 *  @return 反转后字符串
 */
+ (NSString *)reverseString:(NSString *)strSrc;

/**
 设置字符串行间距
 
 @param font 字体
 @param paragraph 行间距
 @param width 宽度
 @param textString 字符串
 @return CGSize
 */
- (CGSize)heightWithFont:(UIFont *)font paragraph:(CGFloat)paragraph constrainedToWidth:(CGFloat)width textString:(NSString *)textString;


- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;
@end
