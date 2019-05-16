//
//  BaseCollectionViewFlowLayout.h
//  UICollectionViewFlowLayoutDemo
//
//  Created by damai on 2019/5/13.
//  Copyright © 2019 personal. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BaseCollectionViewFlowLayoutDelegate <UICollectionViewDelegate>

// 定义每一组的总列数
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout columnCountForSection:(NSInteger)section;

@end


@interface BaseCollectionViewFlowLayout : UICollectionViewFlowLayout
// 每一组的总列数-代理
@property (nonatomic, weak) id <BaseCollectionViewFlowLayoutDelegate> baseDelegate;
// 布局类型
//@property (nonatomic, assign) FlowLayoutType type;
// 存放所有的头部视图布局属性
@property (nonatomic, strong) NSMutableArray *headerAttributes;
// 存放所有的尾部视图布局属性
@property (nonatomic, strong) NSMutableArray *footerAttributes;
// 存放所有的分组item布局属性
@property (nonatomic, strong) NSMutableArray *sectionItemAttributes;
// 用来记录每一组每一列的最小y值
@property (nonatomic, strong) NSMutableArray *sectionColumnsHeights;
// 用来记录每一组每一行的最小X值
@property (nonatomic, strong) NSMutableArray *sectionRowsWidths;
// 内容高度
@property (nonatomic, assign) CGFloat contentHeight;
// 内容宽度
@property (nonatomic, assign) CGFloat contentWidth;
//总列数，默认3 《垂直布局使用属性》
@property (nonatomic, assign) NSUInteger columnCount;
//总行数，默认3 《水平布局使用属性》
@property (nonatomic, assign) NSUInteger rowCount;


#pragma mark —————获取值—————
// 获取分组
- (NSInteger)getSections;
// 获取每一组Header高度
- (CGFloat)getSectionHeaderHeight:(NSInteger)section;
// 获取每一组Footer高度
- (CGFloat)getSectionFooterHeight:(NSInteger)section;
// 获取每一组的列数
- (NSInteger)getSectionColumnCount:(NSInteger)section;
// 获取每一组的单元格的行间距
- (CGFloat)getSectionRowSpacing:(NSInteger)section;
// 获取每一组的单元格的列间距
- (CGFloat)getSectionColumnSpacing:(NSInteger)section;
// 获取每一组的内边距
- (UIEdgeInsets)getSectionInset:(NSInteger)section;


#pragma mark —————初始化—————
/**
 垂直瀑布流初始化方法
 
 @param columnOrRowCount        列数或者行数
 @param columnSpacing        列间距
 @param rowSpacing        行间距
 @param edgeInsets        外边距
 
 @return BaseCollectionViewFlowLayout       布局对象
 */
- (instancetype)initWithColumnOrRowCount:(NSUInteger)columnOrRowCount withColumnSpacing:(CGFloat)columnSpacing withRowSpacing:(CGFloat)rowSpacing withEdgeInsets:(UIEdgeInsets)edgeInsets;



@end

NS_ASSUME_NONNULL_END
