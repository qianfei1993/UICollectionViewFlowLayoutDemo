//
//  NSString+Size.h
//  BaseCollectionView
//
//  Created by damai on 2019/4/29.
//  Copyright © 2019 personal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSString (Size)

- (CGSize)sizeForFont:(UIFont *)font size:(CGSize)size mode:(NSLineBreakMode)lineBreakMode;

- (CGSize)sizeWithFont:(UIFont *)font withSize:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
