//
//  BaseCollectionViewFlowLayout.m
//  UICollectionViewFlowLayoutDemo
//
//  Created by damai on 2019/5/13.
//  Copyright © 2019 personal. All rights reserved.
//

#import "BaseCollectionViewFlowLayout.h"
@interface BaseCollectionViewFlowLayout()

@property (nonatomic, weak) id<UICollectionViewDelegateFlowLayout> flowLayoutDelegate;
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
- (void)initWithConfig {
    // 设置默认值
   
}


- (instancetype)initWithColumnOrRowCount:(NSUInteger)columnOrRowCount withColumnSpacing:(CGFloat)columnSpacing withRowSpacing:(CGFloat)rowSpacing withEdgeInsets:(UIEdgeInsets)edgeInsets{
    if (self = [super init]) {
        [self initWithConfig];
        self.columnCount = columnOrRowCount;
        self.rowCount = columnOrRowCount;
//        self.type = type;
        self.sectionInset = edgeInsets;
        self.minimumLineSpacing = rowSpacing;
        self.minimumInteritemSpacing = columnSpacing;
    }
    return self;
}

- (void)invalidateLayout{
    [super invalidateLayout];
    
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
}

// 返回所有单元格和视图的布局属性
- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSArray<UICollectionViewLayoutAttributes *> *attributes = [super layoutAttributesForElementsInRect:rect].copy;
    return attributes;
}
// 返回指定indexPath的item的布局属性
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attribute = [super layoutAttributesForItemAtIndexPath:indexPath];
    return attribute;
}
// 返回指定indexPath的sectionView的布局属性
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
     UICollectionViewLayoutAttributes *attribute = [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
    return attribute;
}
// 返回集合视图内容的宽度和高度
- (CGSize)collectionViewContentSize {
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
        columnSpacing = self.minimumInteritemSpacing;
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
