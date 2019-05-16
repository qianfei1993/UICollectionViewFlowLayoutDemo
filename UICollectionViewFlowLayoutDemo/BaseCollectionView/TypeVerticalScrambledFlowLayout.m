//
//  TypeVerticalScrambledFlowLayout.m
//  UICollectionViewFlowLayoutDemo
//
//  Created by damai on 2019/5/13.
//  Copyright © 2019 personal. All rights reserved.
//

#import "TypeVerticalScrambledFlowLayout.h"

@implementation TypeVerticalScrambledFlowLayout

// 更新当前布局
- (void)prepareLayout {
    
    [super prepareLayout];
    
    // 获取分组
    NSInteger sections = [self getSections];
    // 内容高度
    self.contentHeight = 0;
    // 内容宽度
    self.contentWidth = 0;
    
    if (sections < 1) {
        return;
    }
    [self prepareLayoutVerticalEqualWidth:sections];
   
}
// 返回所有单元格和视图的布局属性
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSMutableArray *totalAttributes = [NSMutableArray array];
    for (NSArray *arr in self.sectionItemAttributes) {
        [totalAttributes addObjectsFromArray:arr];
    }
    [totalAttributes addObjectsFromArray:self.headerAttributes];
    [totalAttributes addObjectsFromArray:self.footerAttributes];
    return  totalAttributes;
}
// 返回指定indexPath的item的布局属性
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    /*
    UICollectionViewLayoutAttributes *attribute = [super layoutAttributesForItemAtIndexPath:indexPath];
    // 创建布局属性
    UICollectionViewLayoutAttributes *newAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    UIEdgeInsets sectionInset = [self getSectionInset:indexPath.section];
    CGFloat sectionColumnSpacing = [self getSectionColumnSpacing:indexPath.section];
    CGFloat sectionRowSpacing = [self getSectionRowSpacing:indexPath.section];
    CGFloat itemWidth = attribute.size.width;
    CGFloat itemHeight = attribute.size.height;
    // 找出每一组最短的那一列,追加item
    NSMutableArray *columnHeights = self.sectionColumnsHeights[indexPath.section];
    __block CGFloat minColumnHeight =  [columnHeights.firstObject floatValue];
    __block NSInteger shortColumn = 0;
    
    [columnHeights enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 取得第i列的高度
        CGFloat columnHeight = [obj floatValue];
        if (minColumnHeight > columnHeight) {
            minColumnHeight = columnHeight;
            shortColumn = idx;
        }
    }];
    CGFloat itemX = sectionInset.left + shortColumn * (itemWidth + sectionColumnSpacing);
    CGFloat itemY = [self.sectionColumnsHeights[indexPath.section][shortColumn] floatValue];
    
    // 设置frame
    newAttributes.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
    // 更新最短那一列的高度
    columnHeights[shortColumn] = @(CGRectGetMaxY(newAttributes.frame)+sectionRowSpacing);
    self.sectionColumnsHeights[indexPath.section] = columnHeights;
    return newAttributes;
  */
    return self.sectionItemAttributes[indexPath.section][indexPath.item];
}
// 返回集合视图内容的宽度和高度
- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.frame.size.width, self.contentHeight);
}

#pragma mark - Private
#pragma mark —————设置prepareLayout—————
// 垂直瀑布流--Item等宽不等高-顺序排列
- (void)prepareLayoutVerticalEqualWidth:(NSInteger)sections{
    
    // 内容高度
    self.contentHeight = 0;
    // 默认Y值
    CGFloat top = 0.f;
    // 遍历分组,设置值
    for (int section = 0; section < sections; section++) {
        
        // 获取每一组列数
        NSInteger sectionColumnCount = [self getSectionColumnCount:section];
        
        // 初始化每一组中每一列默认Y值
        NSMutableArray *columnsHeights = [NSMutableArray array];
        for (NSUInteger i = 0; i < sectionColumnCount; i++) {
            CGFloat deftop = 0.f;
            [columnsHeights addObject:@(deftop)];
        }
        self.sectionColumnsHeights[section] = columnsHeights;
        
        // 获取每一组的单元格的行间距
        CGFloat temRowSpacing = [self getSectionRowSpacing:section];
        
        // 获取每一组的单元格的列间距
        CGFloat temColumnSpacing = [self getSectionColumnSpacing:section];
        
        // 获取每一组的外边距
        UIEdgeInsets temSectionInset = [self getSectionInset:section];
        
        // 设置每一组默认内容高度
        self.contentHeight = temSectionInset.top + temSectionInset.bottom;
        
        // 获取每一组Header高度
        CGFloat temHeaderHeight = [self getSectionHeaderHeight:section];
        // 获取Header布局属性
        if (temHeaderHeight > 0) {
            UICollectionViewLayoutAttributes *headerAttribute = [super layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            headerAttribute.frame = CGRectMake(0, top, self.collectionView.frame.size.width, temHeaderHeight);
            self.headerAttributes[section] = headerAttribute;
            top = CGRectGetMaxY(headerAttribute.frame);
        }
        
        top += temSectionInset.top;
        // 更新列高
        for (NSInteger idx = 0; idx < sectionColumnCount; idx++) {
            self.sectionColumnsHeights[section][idx] = @(top);
        }
        
        // 设置每一组单元格的Size
        CGFloat collectionViewWidth = self.collectionView.bounds.size.width;
        // item的宽度 = (collectionView的宽度 - 内边距与列间距) / 列数
        CGFloat itemWidth = (collectionViewWidth - temSectionInset.left - temSectionInset.right - (sectionColumnCount - 1) * temColumnSpacing) / sectionColumnCount;
        
        // 获取每一组item数量
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        // 设置每一组单元格布局属性
        NSMutableArray *itemAttributes = [NSMutableArray arrayWithCapacity:itemCount];
        for (NSInteger i = 0; i < itemCount; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:section];
            // 获取item布局属性
            UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
//            UICollectionViewLayoutAttributes *newAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            UICollectionViewLayoutAttributes *newAttributes = [self verticalAttributesAtIndexPath:indexPath withSectionItemSize:CGSizeMake(itemWidth, attributes.size.height) withSectionInset:temSectionInset withSectionColumnSpacing:temColumnSpacing withSectionRowSpacing:temRowSpacing];
            [itemAttributes addObject:newAttributes];
        }
        self.sectionItemAttributes[section] = itemAttributes;
        
        // 获取最长的一列
        NSMutableArray *columnHeights = self.sectionColumnsHeights[section];
        __block CGFloat maxColumnHeight =  [columnHeights.firstObject floatValue];
        [columnHeights enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            // 取得第i列的高度
            CGFloat columnHeight = [obj floatValue];
            if (maxColumnHeight < columnHeight) {
                maxColumnHeight = columnHeight;
            }
        }];
        top = maxColumnHeight - temRowSpacing + temSectionInset.bottom;
        for (NSInteger idx = 0; idx < sectionColumnCount; idx++) {
            self.sectionColumnsHeights[section][idx] = @(top);
        }
        
        //获取每一组Footer高度
        CGFloat temFooterHeight = [self getSectionFooterHeight:section];
        
        // 获取Footer布局属性
        if (temFooterHeight > 0) {
            UICollectionViewLayoutAttributes *footerAttribute = [super layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            footerAttribute.frame = CGRectMake(0, top, self.collectionView.frame.size.width, temFooterHeight);
            self.footerAttributes[section] = footerAttribute;
            top = CGRectGetMaxY(footerAttribute.frame);
            self.contentHeight = CGRectGetMaxY(footerAttribute.frame);
        }
        for (NSInteger idx = 0; idx < sectionColumnCount; idx++) {
            self.sectionColumnsHeights[section][idx] = @(top);
        }
    }
}

#pragma mark —————返回item布局属性—————
// 返回指定索引出的item的布局属性------《垂直不瀑布流，纵向滑动》
- (UICollectionViewLayoutAttributes *)verticalAttributesAtIndexPath:(NSIndexPath *)indexPath withSectionItemSize:(CGSize)sectionItemSize withSectionInset:(UIEdgeInsets)sectionInset withSectionColumnSpacing:(CGFloat)sectionColumnSpacing withSectionRowSpacing:(CGFloat)sectionRowSpacing{
    
    // 创建布局属性
    UICollectionViewLayoutAttributes *newAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat itemWidth = sectionItemSize.width;
    CGFloat itemHeight = sectionItemSize.height;
    // 找出每一组最短的那一列,追加item
    NSMutableArray *columnHeights = self.sectionColumnsHeights[indexPath.section];
    __block CGFloat minColumnHeight =  [columnHeights.firstObject floatValue];
    __block NSInteger shortColumn = 0;
    
    [columnHeights enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 取得第i列的高度
        CGFloat columnHeight = [obj floatValue];
        if (minColumnHeight > columnHeight) {
            minColumnHeight = columnHeight;
            shortColumn = idx;
        }
    }];
    
    CGFloat itemX = sectionInset.left + shortColumn * (itemWidth + sectionColumnSpacing);
    CGFloat itemY = [self.sectionColumnsHeights[indexPath.section][shortColumn] floatValue];
    
    // 设置frame
    newAttributes.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
    // 更新最短那一列的高度
    columnHeights[shortColumn] = @(CGRectGetMaxY(newAttributes.frame)+sectionRowSpacing);
    self.sectionColumnsHeights[indexPath.section] = columnHeights;
    return newAttributes;
}

@end
