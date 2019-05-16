//
//  TypeHorizontalScaleFlowLayout.h
//  UICollectionViewFlowLayoutDemo
//
//  Created by damai on 2019/5/13.
//  Copyright © 2019 personal. All rights reserved.
//

#import "BaseCollectionViewFlowLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface TypeHorizontalScaleFlowLayout : BaseCollectionViewFlowLayout

/**
 线性卡片布局
 
 @param itemSize        itemFrame
 @param columnSpacing        列间距
 @param rowSpacing        行间距
 @param edgeInsets        外边距
 
 @return BaseCollectionViewFlowLayout       布局对象
 */
- (instancetype)initWithScrollDirection:(UICollectionViewScrollDirection)direction withItemSize:(CGSize)itemSize withColumnSpacing:(CGFloat)columnSpacing withRowSpacing:(CGFloat)rowSpacing withEdgeInsets:(UIEdgeInsets)edgeInsets;

@end

NS_ASSUME_NONNULL_END
