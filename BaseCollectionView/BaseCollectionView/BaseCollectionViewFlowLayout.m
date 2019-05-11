//
//  BaseCollectionViewFlowLayout.m
//  BaseCollectionView
//
//  Created by damai on 2019/4/26.
//  Copyright © 2019 personal. All rights reserved.
//

#import "BaseCollectionViewFlowLayout.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
@interface BaseCollectionViewFlowLayout()

@property (nonatomic, weak) id<UICollectionViewDelegateFlowLayout> flowLayoutDelegate;

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
// 列间距，默认3
@property (nonatomic, assign) CGFloat columnSpacing;
// 行间距，默认3
@property (nonatomic, assign) CGFloat rowSpacing;
// 外边距，默认3
@property (nonatomic, assign) UIEdgeInsets edgeInsets;

@property (nonatomic, assign) FlowLayoutType type;/** 布局类型 */
@end

@implementation BaseCollectionViewFlowLayout

- (instancetype)init{
    
    if (self = [super init]) {
        [self initWithConfig];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        [self initWithConfig];
    }
    return self;
}

#pragma mark- 构造方法
- (instancetype)initWithFlowLayoutType:(FlowLayoutType)type withColumnOrRowCount:(NSUInteger)columnOrRowCount withColumnSpacing:(CGFloat)columnSpacing withRowSpacing:(CGFloat)rowSpacing withEdgeInsets:(UIEdgeInsets)edgeInsets{
    if (self = [super init]) {
        [self initWithConfig];
        self.columnCount = columnOrRowCount;
        self.rowCount = columnOrRowCount;
        self.columnSpacing = columnSpacing;
        self.rowSpacing = rowSpacing;
        self.edgeInsets = edgeInsets;
        self.type = type;
        self.sectionInset = edgeInsets;
        self.minimumLineSpacing = rowSpacing;
        self.minimumInteritemSpacing = columnSpacing;
    }
    return self;
}

- (void)initWithConfig {
    
    // 设置默认值
    self.columnCount = 3;
    self.rowCount = 3;
    self.columnSpacing = 10;
    self.rowSpacing = 20;
    self.edgeInsets = UIEdgeInsetsMake(20, 10, 20, 10);
    self.type = FlowLayoutTypeNormal;
}

// 更新当前布局
- (void)prepareLayout {
    
    [super prepareLayout];
    
    // 清除布局属性
    [self.headerAttributes removeAllObjects];
    [self.footerAttributes removeAllObjects];
    [self.sectionItemAttributes removeAllObjects];
    [self.sectionColumnsHeights removeAllObjects];
    [self.sectionRowsWidths removeAllObjects];
    // 获取分组
    NSInteger sections = [self getSections];
    // 内容高度
    self.contentHeight = 0;
    // 内容宽度
    self.contentWidth = 0;
    
    if (sections < 1) {
        return;
    }
    
    // 垂直瀑布流----可分组
    // Item等宽不等高
    if (self.type == FlowLayoutTypeVerticalEqualWidth) {
        [self prepareLayoutVerticalEqualWidth:sections];
    }
    // Item等高不等宽
    if (self.type == FlowLayoutTypeVerticalEqualHeight) {
        [self prepareLayoutVerticalEqualHeight:sections];
    }
    
    // 水平瀑布流----不可分组
    // 补充最短行排列
    if (self.type == FlowLayoutTypeHorizontalScrambled) {
        [self prepareLayoutHorizontalWithType:FlowLayoutTypeHorizontalScrambled];
    }
    // 顺序排列
    if (self.type == FlowLayoutTypeHorizontalOrder) {
        [self prepareLayoutHorizontalWithType:FlowLayoutTypeHorizontalOrder];
    }
}

// 返回所有单元格和视图的布局属性
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{

    NSArray<UICollectionViewLayoutAttributes *> *attributes = [super layoutAttributesForElementsInRect:rect].copy;
    if (self.type != FlowLayoutTypeNormal) {
        return [self layoutAttributesForElements:attributes];
    }
    return attributes;
}
/*
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attribute = [super layoutAttributesForItemAtIndexPath:indexPath];
    attribute = self.sectionItemAttributes[indexPath.section][indexPath.item];
    return attribute;
}

// 返回指定indexPath的sectionView的布局属性
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{

    UICollectionViewLayoutAttributes *attribute = [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        attribute = self.headerAttributes[indexPath.section];
    } else if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
        attribute = self.footerAttributes[indexPath.section];
    }
    return attribute;
}
*/
// 返回集合视图内容的宽度和高度
- (CGSize)collectionViewContentSize {
    
    if (self.type == FlowLayoutTypeNormal) {
        return [super collectionViewContentSize];
    }
    
    if (self.type == FlowLayoutTypeVerticalEqualWidth) {
        return CGSizeMake(self.collectionView.frame.size.width, self.contentHeight);
    }
    
    if (self.type == FlowLayoutTypeVerticalEqualHeight) {
        
        return CGSizeMake(self.collectionView.frame.size.width, self.contentHeight);
    }
    
    if (self.type == FlowLayoutTypeHorizontalScrambled) {
        return CGSizeMake(self.contentWidth+self.edgeInsets.right, self.collectionView.frame.size.height);
    }
    
    if (self.type == FlowLayoutTypeHorizontalOrder) {
        return CGSizeMake(self.contentWidth + self.edgeInsets.right, self.collectionView.frame.size.height);
    }
   return [super collectionViewContentSize];
}

//如果返回YES，那么collectionView显示的范围发生改变时，就会重新刷新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    CGRect oldBounds = self.collectionView.bounds;
    if (CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds)) {
        return YES;
    }
    return NO;
}

//返回停止滚动的点
-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    CGPoint point = [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
    return point;
}

#pragma mark - Private
#pragma mark —————设置代理—————
- (id<UICollectionViewDelegateFlowLayout>)flowLayoutDelegate {
    if (!_flowLayoutDelegate) {
        _flowLayoutDelegate = (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
    }
    return _flowLayoutDelegate;
}

- (id <BaseCollectionViewFlowLayoutDelegate> )baseDelegate {
    return (id <BaseCollectionViewFlowLayoutDelegate> )self.collectionView.delegate;
}

#pragma mark —————设置prepareLayout—————
// 垂直瀑布流--Item等宽不等高
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
        self.contentHeight = self.edgeInsets.top + self.edgeInsets.bottom;
        
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
            UICollectionViewLayoutAttributes *oldAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
            UICollectionViewLayoutAttributes *attributes = [self verticalAttributesAtIndexPath:indexPath withSectionItemSize:CGSizeMake(itemWidth, oldAttributes.size.height) withSectionInset:temSectionInset withSectionColumnSpacing:temColumnSpacing withSectionRowSpacing:temRowSpacing];
            [itemAttributes addObject:attributes];
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

// 垂直瀑布流--Item等宽不等高
- (void)prepareLayoutVerticalEqualHeight:(NSInteger)sections{
    
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
        CGFloat temRowSpacing = [self getSectionRowSpacing:section];
        
        // 获取每一组的单元格的列间距
        CGFloat temColumnSpacing = [self getSectionColumnSpacing:section];
        
        // 获取每一组的外边距
        UIEdgeInsets temSectionInset = [self getSectionInset:section];
        
        // 更新X值
        self.sectionRowsWidths[section] = @(temSectionInset.left);
        
        // 设置每一组默认内容高度
        self.contentHeight = self.edgeInsets.top + self.edgeInsets.bottom;
        
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
            UICollectionViewLayoutAttributes *oldAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
            UICollectionViewLayoutAttributes *attributes = [self verticalTypeAttributesAtIndexPath:indexPath withSectionItemSize:oldAttributes.size withSectionInset:temSectionInset withSectionColumnSpacing:temColumnSpacing withSectionRowSpacing:temRowSpacing];
            [itemAttributes addObject:attributes];
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


// 水平瀑布流，不分组
- (void)prepareLayoutHorizontalWithType:(FlowLayoutType)type{
    
    CGFloat left = 0.0;
    left += self.edgeInsets.left;
    // 设置每一列默认宽度
    for (NSUInteger i = 0; i < self.rowCount; i++) {
        [self.sectionRowsWidths addObject:@(self.edgeInsets.left)];
    }
    
    CGFloat collectionViewheightHeight = self.collectionView.bounds.size.height;
    // item的高度 = (collectionView的高度 - 内边距与行间距) / 行数
    CGFloat itemHeight = (collectionViewheightHeight - self.edgeInsets.top - self.edgeInsets.bottom - (self.rowCount - 1) * self.rowSpacing) / self.rowCount;
    
    // 获取item布局属性
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    NSMutableArray *itemAttributes = [NSMutableArray arrayWithCapacity:itemCount];
    for (NSInteger i = 0; i < itemCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *oldAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
        UICollectionViewLayoutAttributes *attributes = [self horizontalAttributesAtIndexPath:indexPath withSectionItemSize:CGSizeMake(oldAttributes.size.width, itemHeight) withAlignType:type];
        [itemAttributes addObject:attributes];
    }
    self.sectionItemAttributes[0] = itemAttributes;
}


#pragma mark —————返回item布局属性—————
// 返回指定索引出的item的布局属性------《垂直不瀑布流，纵向滑动》
- (UICollectionViewLayoutAttributes *)verticalAttributesAtIndexPath:(NSIndexPath *)indexPath withSectionItemSize:(CGSize)sectionItemSize withSectionInset:(UIEdgeInsets)sectionInset withSectionColumnSpacing:(CGFloat)sectionColumnSpacing withSectionRowSpacing:(CGFloat)sectionRowSpacing{
    
    // 垂直瀑布流
    if (self.type == FlowLayoutTypeVerticalEqualWidth) {
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
     return [super layoutAttributesForItemAtIndexPath:indexPath];
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
    if ((lastItemX + itemWidth) > collectionViewWidth) {
        lastItemX = sectionInset.left;
        lastItemY += (sectionRowSpacing + itemHeight);
        self.contentHeight += (sectionRowSpacing + itemHeight);
    }
    // 设置frame
    newAttributes.frame = CGRectMake(lastItemX, lastItemY, itemWidth, itemHeight);
    // 更新X坐标
    lastItemX += (sectionColumnSpacing + itemWidth);
    
    self.sectionRowsWidths[indexPath.section] = @(lastItemX);
    self.sectionColumnsHeights[indexPath.section] = @(lastItemY);
    return newAttributes;
}

// 返回指定索引出的item的布局属性------《水平瀑布流，横向滑动》
- (UICollectionViewLayoutAttributes *)horizontalAttributesAtIndexPath:(NSIndexPath *)indexPath withSectionItemSize:(CGSize)sectionItemSize withAlignType:(FlowLayoutType)type{
    
    // 创建布局属性
    UICollectionViewLayoutAttributes *newAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat itemWidth = sectionItemSize.width;
    CGFloat itemHeight = sectionItemSize.height;
    
    // 找出每一组最短的那一行,追加item
    
    CGFloat minRowWidth = [self.sectionRowsWidths.firstObject floatValue];
    NSInteger destRow = 0;
    
    if (type == FlowLayoutTypeHorizontalScrambled) {
        for (int i = 0; i < self.sectionRowsWidths.count; i++) {
            // 取得第i行的宽度
            CGFloat rowWidth = [self.sectionRowsWidths[i] floatValue];
            if (minRowWidth > rowWidth) {
                minRowWidth = rowWidth;
                destRow = i;
            }
        }
    }
    
    if (type == FlowLayoutTypeHorizontalOrder) {
        for (int i = 0; i < self.sectionRowsWidths.count; i++) {
            // 取得第i行的宽度
            if (indexPath.item % self.rowCount == i) {
                CGFloat rowWidth = [self.sectionRowsWidths[i] floatValue];
                minRowWidth = rowWidth;
                destRow = i;
            }
        }
    }
    
    CGFloat itemX = minRowWidth;
    CGFloat itemY = self.edgeInsets.top + destRow * (itemHeight + self.rowSpacing);
    if (itemX != self.edgeInsets.left) {
        itemX += self.columnSpacing;
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


// 返回所有单元格和视图的布局属性
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElements:(NSArray<UICollectionViewLayoutAttributes *> *)attributes{
    
    NSMutableArray *totalAttributes = [NSMutableArray array];
    for (NSArray *arr in self.sectionItemAttributes) {
        [totalAttributes addObjectsFromArray:arr];
    }
    [totalAttributes addObjectsFromArray:self.headerAttributes];
    [totalAttributes addObjectsFromArray:self.footerAttributes];
    return  totalAttributes;
}



#pragma mark —————获取值—————
// 获取分组
- (NSInteger)getSections{
    
    NSInteger sections = [self.collectionView numberOfSections];
    return sections;
}

// 获取每一组Header高度
- (CGFloat)getSectionHeaderHeight:(NSInteger)section{
    CGFloat sectionHeaderHeight = 0.f;
    if ([self.flowLayoutDelegate respondsToSelector:@selector(collectionView:layout:referenceSizeForHeaderInSection:)]) {
        
        CGSize size = [self.flowLayoutDelegate collectionView:self.collectionView layout:self referenceSizeForHeaderInSection:section];
        sectionHeaderHeight = size.height;
    }else{
        sectionHeaderHeight = self.headerReferenceSize.height;
    }
    return sectionHeaderHeight;
}

// 获取每一组Footer高度
- (CGFloat)getSectionFooterHeight:(NSInteger)section{
    CGFloat sectionFooterHeight = 0.f;
    //获取每一组Footer高度
    if ([self.flowLayoutDelegate respondsToSelector:@selector(collectionView:layout:referenceSizeForFooterInSection:)]) {
        CGSize size = [self.flowLayoutDelegate collectionView:self.collectionView layout:self referenceSizeForFooterInSection:section];
        sectionFooterHeight = size.height;
    }else{
        sectionFooterHeight = self.footerReferenceSize.height;
    }
    return sectionFooterHeight;
}

// 获取每一组的列数
- (NSInteger)getSectionColumnCount:(NSInteger)section{
    
    NSInteger columnCount = 2;
    if ([self.baseDelegate respondsToSelector:@selector(collectionView:layout:columnCountForSection:)]) {
        columnCount = [self.baseDelegate collectionView:self.collectionView layout:self columnCountForSection:section];
    } else {
        columnCount = self.columnCount;
    }
    return columnCount;
}

// 获取每一组的单元格的行间距
- (CGFloat)getSectionRowSpacing:(NSInteger)section{
    CGFloat rowSpacing = 0.f;
    if ([self.flowLayoutDelegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
        rowSpacing = [self.flowLayoutDelegate collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:section];
    }else{
        rowSpacing = self.minimumLineSpacing;
    }
    return rowSpacing;
}

// 获取每一组的单元格的列间距
- (CGFloat)getSectionColumnSpacing:(NSInteger)section{
    CGFloat columnSpacing = 0.f;
    if ([self.flowLayoutDelegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        columnSpacing = [self.flowLayoutDelegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:section];
    }else{
        columnSpacing = self.minimumLineSpacing;
    }
    return columnSpacing;
}

// 获取每一组的内边距
- (UIEdgeInsets)getSectionInset:(NSInteger)section{
    UIEdgeInsets sectionInset;
    if ([self.flowLayoutDelegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        sectionInset = [self.flowLayoutDelegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
    }else{
        sectionInset = self.sectionInset;
    }
    return sectionInset;
}


#pragma mark —————初始化数组—————
// 初始化可变数组
- (NSMutableArray *)headerAttributes {
    if (!_headerAttributes) {
        _headerAttributes = [NSMutableArray array];
    }
    return _headerAttributes;
}

- (NSMutableArray *)footerAttributes{
    if (!_footerAttributes) {
        _footerAttributes = [NSMutableArray array];
    }
    return _footerAttributes;
}

- (NSMutableArray *)sectionItemAttributes{
    if (!_sectionItemAttributes) {
        _sectionItemAttributes = [NSMutableArray array];
    }
    return _sectionItemAttributes;
}

- (NSMutableArray *)sectionRowsWidths{
    if (!_sectionRowsWidths) {
        _sectionRowsWidths = [NSMutableArray array];
    }
    return _sectionRowsWidths;
}

- (NSMutableArray *)sectionColumnsHeights{
    if (!_sectionColumnsHeights) {
        _sectionColumnsHeights = [NSMutableArray array];
    }
    return _sectionColumnsHeights;
}


@end
