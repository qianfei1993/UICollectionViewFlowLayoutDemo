//
//  TypeHorizontalScrambledFlowLayout.m
//  UICollectionViewFlowLayoutDemo
//
//  Created by damai on 2019/5/13.
//  Copyright © 2019 personal. All rights reserved.
//

#import "TypeHorizontalScrambledFlowLayout.h"

@implementation TypeHorizontalScrambledFlowLayout
// 更新当前布局
- (void)prepareLayout {
    
    [super prepareLayout];
    
    CGFloat left = 0.0;
    left += self.sectionInset.left;
    // 设置每一列默认宽度
    for (NSUInteger i = 0; i < self.rowCount; i++) {
        [self.sectionRowsWidths addObject:@(self.sectionInset.left)];
    }
    
    CGFloat collectionViewheightHeight = self.collectionView.bounds.size.height;
    // item的高度 = (collectionView的高度 - 内边距与行间距) / 行数
    //CGFloat itemHeight = (collectionViewheightHeight - self.sectionInset.top - self.sectionInset.bottom - (self.rowCount - 1) * self.minimumLineSpacing) / self.rowCount;
    // 获取item布局属性
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    NSMutableArray *itemAttributes = [NSMutableArray arrayWithCapacity:itemCount];
    for (NSInteger i = 0; i < itemCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        //UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
//        UICollectionViewLayoutAttributes *newAttributes = [self horizontalAttributesAtIndexPath:indexPath withSectionItemSize:CGSizeMake(attributes.size.width, itemHeight)];
        UICollectionViewLayoutAttributes *newAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [itemAttributes addObject:newAttributes];
    }
    self.sectionItemAttributes[0] = itemAttributes;
    
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
    
    UICollectionViewLayoutAttributes *attribute = [super layoutAttributesForItemAtIndexPath:indexPath];
    // 创建布局属性
    UICollectionViewLayoutAttributes *newAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat collectionViewheightHeight = self.collectionView.bounds.size.height;
    CGFloat itemWidth = attribute.size.width;
    //CGFloat itemHeight = attribute.size.height;
    // item的高度 = (collectionView的高度 - 内边距与行间距) / 行数
    CGFloat itemHeight = (collectionViewheightHeight - self.sectionInset.top - self.sectionInset.bottom - (self.rowCount - 1) * self.minimumLineSpacing) / self.rowCount;
    
    // 找出每一组最短的那一行,追加item
    CGFloat minRowWidth = [self.sectionRowsWidths.firstObject floatValue];
    NSInteger destRow = 0;
    
    for (int i = 0; i < self.sectionRowsWidths.count; i++) {
        // 取得第i行的宽度
        CGFloat rowWidth = [self.sectionRowsWidths[i] floatValue];
        if (minRowWidth > rowWidth) {
            minRowWidth = rowWidth;
            destRow = i;
        }
    }
    CGFloat itemX = minRowWidth;
    CGFloat itemY = self.sectionInset.top + destRow * (itemHeight + self.minimumLineSpacing);
    if (itemX != self.sectionInset.left) {
        itemX += self.minimumInteritemSpacing;
    }
    newAttributes.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
    
    // 更新最短那一行的宽度
    self.sectionRowsWidths[destRow] = @(CGRectGetMaxX(newAttributes.frame));
    
    // 记录内容的宽度 - 即最宽那一行的宽度
    CGFloat maxRowWidth = [self.sectionRowsWidths[destRow] doubleValue];
    if (self.contentWidth < maxRowWidth) {
        self.contentWidth = maxRowWidth;
    }
    return newAttributes;
}
// 返回集合视图内容的宽度和高度
- (CGSize)collectionViewContentSize {
    //return CGSizeMake(self.collectionView.frame.size.width, self.contentHeight);
     return CGSizeMake(self.contentWidth+self.sectionInset.right, self.collectionView.frame.size.height);
}

// 返回指定索引出的item的布局属性------《水平瀑布流，横向滑动》
- (UICollectionViewLayoutAttributes *)horizontalAttributesAtIndexPath:(NSIndexPath *)indexPath withSectionItemSize:(CGSize)sectionItemSize{
    
    // 创建布局属性
    UICollectionViewLayoutAttributes *newAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat itemWidth = sectionItemSize.width;
    CGFloat itemHeight = sectionItemSize.height;
    
    // 找出每一组最短的那一行,追加item
    
    CGFloat minRowWidth = [self.sectionRowsWidths.firstObject floatValue];
    NSInteger destRow = 0;
    
    for (int i = 0; i < self.sectionRowsWidths.count; i++) {
        // 取得第i行的宽度
        CGFloat rowWidth = [self.sectionRowsWidths[i] floatValue];
        if (minRowWidth > rowWidth) {
            minRowWidth = rowWidth;
            destRow = i;
        }
    }
    
    CGFloat itemX = minRowWidth;
    CGFloat itemY = self.sectionInset.top + destRow * (itemHeight + self.minimumLineSpacing);
    if (itemX != self.sectionInset.left) {
        itemX += self.minimumInteritemSpacing;
    }
    newAttributes.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
    
    // 更新最短那一行的宽度
    self.sectionRowsWidths[destRow] = @(CGRectGetMaxX(newAttributes.frame));
    
    // 记录内容的宽度 - 即最宽那一行的宽度
    CGFloat maxRowWidth = [self.sectionRowsWidths[destRow] doubleValue];
    if (self.contentWidth < maxRowWidth) {
        self.contentWidth = maxRowWidth;
    }
    return newAttributes;
}

@end
