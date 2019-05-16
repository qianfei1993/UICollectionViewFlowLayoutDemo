//
//  TypeVerticalOrderFlowLayout.m
//  UICollectionViewFlowLayoutDemo
//
//  Created by damai on 2019/5/13.
//  Copyright © 2019 personal. All rights reserved.
//

#import "TypeVerticalOrderFlowLayout.h"

@implementation TypeVerticalOrderFlowLayout
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
    [self prepareLayoutVerticalOrder:sections];
    
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
    
    UIEdgeInsets sectionInset = [self getSectionInset:indexPath.section];
    CGFloat sectionColumnSpacing = [self getSectionColumnSpacing:indexPath.section];
    CGFloat sectionRowSpacing = [self getSectionRowSpacing:indexPath.section];
    CGFloat itemWidth = attribute.size.width;
    CGFloat itemHeight = attribute.size.height;
    CGFloat collectionViewWidth = self.collectionView.frame.size.width - sectionInset.right;
    
    // 取值
    CGFloat lastItemX = [self.sectionRowsWidths[indexPath.section] floatValue];
    CGFloat lastItemY = [self.sectionColumnsHeights[indexPath.section] floatValue];
    
    // 换行
    if (indexPath.row == 0) {
        if ((lastItemX + itemWidth) > collectionViewWidth) {
            lastItemX = sectionInset.left;
            lastItemY += (sectionRowSpacing + itemHeight);
        }
    }
    if (indexPath.row > 0) {
        UICollectionViewLayoutAttributes *lastAttributes = [super layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.row-1 inSection:indexPath.section]];
        if ((lastItemX + itemWidth) > collectionViewWidth) {
            lastItemX = sectionInset.left;
            lastItemY += (sectionRowSpacing + lastAttributes.size.height);
        }
    }
    
    // 设置frame
    newAttributes.frame = CGRectMake(lastItemX, lastItemY, itemWidth, itemHeight);
    // 更新X坐标
    lastItemX += (sectionColumnSpacing + itemWidth);
    self.sectionRowsWidths[indexPath.section] = @(lastItemX);
    self.sectionColumnsHeights[indexPath.section] = @(lastItemY);
    return newAttributes;
  
    return self.sectionItemAttributes[indexPath.section][indexPath.item];
}
// 返回集合视图内容的宽度和高度
- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.frame.size.width, self.contentHeight);
}

#pragma mark - Private
#pragma mark —————设置prepareLayout—————
// 垂直瀑布流--Item不等宽不等高-顺序排列
- (void)prepareLayoutVerticalOrder:(NSInteger)sections{
    
    // 内容高度
    self.contentHeight = 0;
    // 默认Y值
    CGFloat top = 0.f;
    // 遍历分组,设置值
    for (int section = 0; section < sections; section++) {
        
        // 初始化每一组中默认Y值
        CGFloat defLeft = 0.f;
        self.sectionRowsWidths[section] = @(defLeft);
        
        // 初始化每一组中默认Y值
        CGFloat deftop = 0.f;
        self.sectionColumnsHeights[section] = @(deftop);
        
        // 获取每一组的单元格的行间距
//        CGFloat temRowSpacing = [self getSectionRowSpacing:section];
        
        // 获取每一组的单元格的列间距
//        CGFloat temColumnSpacing = [self getSectionColumnSpacing:section];
        
        // 获取每一组的外边距
        UIEdgeInsets temSectionInset = [self getSectionInset:section];
        
        // 更新X值
        self.sectionRowsWidths[section] = @(temSectionInset.left);
        
        // 设置每一组默认内容高度
        self.contentHeight = temSectionInset.top + temSectionInset.bottom;
        
        // 获取每一组Header高度
        CGFloat temHeaderHeight = [self getSectionHeaderHeight:section];
        
        // 获取Header布局属性
        if (temHeaderHeight > 0) {
            UICollectionViewLayoutAttributes *headerAttribute = [super layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            if (headerAttribute) {
                headerAttribute.frame = CGRectMake(0, top, self.collectionView.frame.size.width, temHeaderHeight);
                self.headerAttributes[section] = headerAttribute;
                top = CGRectGetMaxY(headerAttribute.frame);
            }
        }
        
        top += temSectionInset.top;
        
        // 更新列高
        self.sectionColumnsHeights[section] = @(top);
        
        // 获取每一组item数量
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        // 设置每一组单元格布局属性
        NSMutableArray *itemAttributes = [NSMutableArray arrayWithCapacity:itemCount];
        for (NSInteger i = 0; i < itemCount; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:section];
            // 获取item布局属性
//            UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
            UICollectionViewLayoutAttributes *newAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            
//            UICollectionViewLayoutAttributes *attributes = [self verticalTypeAttributesAtIndexPath:indexPath withSectionItemSize:attributes.size withSectionInset:temSectionInset withSectionColumnSpacing:temColumnSpacing withSectionRowSpacing:temRowSpacing];
            [itemAttributes addObject:newAttributes];
        }
        self.sectionItemAttributes[section] = itemAttributes;
        
        // 获取最后一个item的布局属性
        UICollectionViewLayoutAttributes *lastItemattribute = itemAttributes[itemCount-1];
        
        top = CGRectGetMaxY(lastItemattribute.frame) + temSectionInset.bottom;
        //获取每一组Footer高度
        CGFloat temFooterHeight = [self getSectionFooterHeight:section];
        
        // 获取Footer布局属性
        if (temFooterHeight > 0) {
            UICollectionViewLayoutAttributes *footerAttribute = [super layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            CGFloat footerY = [self.sectionColumnsHeights[section] floatValue] + lastItemattribute.size.height + temSectionInset.bottom;
            footerAttribute.frame = CGRectMake(0, footerY, self.collectionView.frame.size.width, temFooterHeight);
            self.footerAttributes[section] = footerAttribute;
            top = CGRectGetMaxY(footerAttribute.frame);
            self.contentHeight = CGRectGetMaxY(footerAttribute.frame);
        }
        // 更新列高
        self.sectionColumnsHeights[section] = @(top);
    }
}


// 返回指定索引出的item的布局属性------《纵向滑动--顺序布局》
- (UICollectionViewLayoutAttributes *)verticalTypeAttributesAtIndexPath:(NSIndexPath *)indexPath withSectionItemSize:(CGSize)sectionItemSize withSectionInset:(UIEdgeInsets)sectionInset withSectionColumnSpacing:(CGFloat)sectionColumnSpacing withSectionRowSpacing:(CGFloat)sectionRowSpacing{
    
    UICollectionViewLayoutAttributes *oldAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    // 创建布局属性
    UICollectionViewLayoutAttributes *newAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    // collectionView的宽度
    CGFloat collectionViewWidth = self.collectionView.frame.size.width - sectionInset.right;
    CGFloat itemWidth = oldAttributes.size.width;
    CGFloat itemHeight = oldAttributes.size.height;
    
    // 取值
    CGFloat lastItemX = [self.sectionRowsWidths[indexPath.section] floatValue];
    CGFloat lastItemY = [self.sectionColumnsHeights[indexPath.section] floatValue];
    
    // 换行
    if (indexPath.row == 0) {
        if ((lastItemX + itemWidth) > collectionViewWidth) {
            lastItemX = sectionInset.left;
            lastItemY += (sectionRowSpacing + itemHeight);
        }
    }
    if (indexPath.row > 0) {
        UICollectionViewLayoutAttributes *lastAttributes = [super layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.row-1 inSection:indexPath.section]];
        if ((lastItemX + itemWidth) > collectionViewWidth) {
            lastItemX = sectionInset.left;
            lastItemY += (sectionRowSpacing + lastAttributes.size.height);
        }
    }
    
    // 设置frame
    newAttributes.frame = CGRectMake(lastItemX, lastItemY, itemWidth, itemHeight);
    // 更新X坐标
    lastItemX += (sectionColumnSpacing + itemWidth);
    self.sectionRowsWidths[indexPath.section] = @(lastItemX);
    self.sectionColumnsHeights[indexPath.section] = @(lastItemY);
    return newAttributes;
}
@end
