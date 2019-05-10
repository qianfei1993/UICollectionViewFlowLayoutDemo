//
//  BaseCollectionViewFlowLayout.h
//  BaseCollectionView
//
//  Created by damai on 2019/4/26.
//  Copyright © 2019 personal. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BaseCollectionViewFlowLayout;
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FlowLayoutType) {
    FlowLayoutTypeNormal,              // 正常布局
    FlowLayoutTypeVerticalEqualWidth,  // 垂直瀑布流--Item等宽不等高
    FlowLayoutTypeVerticalEqualHeight, // 垂直瀑布流--Item等高不等宽
    FlowLayoutTypeHorizontalScrambled, // 水平瀑布流--补充最短行排列
    FlowLayoutTypeHorizontalOrder,     // 水平瀑布流--顺序排列
};

@protocol BaseCollectionViewFlowLayoutDelegate <UICollectionViewDelegate>

// 定义每一组的总列数
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout columnCountForSection:(NSInteger)section;

@end

@interface BaseCollectionViewFlowLayout : UICollectionViewFlowLayout
@property (nonatomic, weak) id <BaseCollectionViewFlowLayoutDelegate> baseDelegate;

//总列数，默认3 《垂直布局使用属性》
@property (nonatomic, assign) NSUInteger columnCount;
//总行数，默认3 《水平布局使用属性》
@property (nonatomic, assign) NSUInteger rowCount;

#pragma mark- 构造方法

/**
 垂直瀑布流初始化方法
 
 @param type        布局类型
 @param columnOrRowCount        列数或者行数
 @param columnSpacing        列间距
 @param rowSpacing        行间距
 @param edgeInsets        外边距

 @return BaseCollectionViewFlowLayout       布局对象
 */

- (instancetype)initWithFlowLayoutType:(FlowLayoutType)type withColumnOrRowCount:(NSUInteger)columnOrRowCount withColumnSpacing:(CGFloat)columnSpacing withRowSpacing:(CGFloat)rowSpacing withEdgeInsets:(UIEdgeInsets)edgeInsets;

@end

NS_ASSUME_NONNULL_END
