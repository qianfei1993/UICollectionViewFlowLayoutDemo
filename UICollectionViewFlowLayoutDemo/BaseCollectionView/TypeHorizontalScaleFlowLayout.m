//
//  TypeHorizontalScaleFlowLayout.m
//  UICollectionViewFlowLayoutDemo
//
//  Created by damai on 2019/5/13.
//  Copyright © 2019 personal. All rights reserved.
//

#import "TypeHorizontalScaleFlowLayout.h"

@interface TypeHorizontalScaleFlowLayout ()
@property (nonatomic, assign) CGFloat previousOffsetX;
@property (nonatomic, assign) CGFloat previousOffsetY;
@end
@implementation TypeHorizontalScaleFlowLayout

- (instancetype)initWithScrollDirection:(UICollectionViewScrollDirection)direction withItemSize:(CGSize)itemSize withColumnSpacing:(CGFloat)columnSpacing withRowSpacing:(CGFloat)rowSpacing withEdgeInsets:(UIEdgeInsets)edgeInsets{
    if (self = [super init]) {
        if (direction == UICollectionViewScrollDirectionHorizontal) {
            self.minimumLineSpacing = columnSpacing;
            self.minimumInteritemSpacing = rowSpacing;
        }else{
            self.minimumLineSpacing = rowSpacing;
            self.minimumInteritemSpacing = columnSpacing;
        }
        self.scrollDirection = direction;
        self.sectionInset = edgeInsets;
        self.itemSize = itemSize;
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    //屏幕X中间线
    CGFloat centerX = self.collectionView.contentOffset.x  + self.collectionView.bounds.size.width /2.0f;
    //屏幕Y中间线
    CGFloat centerY = self.collectionView.contentOffset.y  + self.collectionView.bounds.size.height * 0.5;
    //刷新cell缩放
    for (UICollectionViewLayoutAttributes *attribute in array) {
        CGFloat distance = 0;
        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            distance = fabs(attribute.center.x - centerX);
        }else{
            distance = fabs(attribute.center.y - centerY);
        }
        //移动的距离和屏幕宽的比例
        CGFloat screenScale = distance /self.collectionView.bounds.size.width;
        //卡片移动到固定范围内 -π/4 到 π/4
        CGFloat scale = fabs(cos(screenScale * M_PI/4));
        //设置cell的缩放 按照余弦函数曲线  越居中越接近于1
        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            attribute.transform = CGAffineTransformMakeScale(1.0,scale);
        }else{
            attribute.transform = CGAffineTransformMakeScale(scale, 1.0);
        }
    }
    return array;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        
        if (self.sectionInset.left == self.minimumLineSpacing) {
            // 分页以1/3处
            if (proposedContentOffset.x > self.previousOffsetX + self.itemSize.width / 3.0) {
                self.previousOffsetX += self.collectionView.frame.size.width - self.sectionInset.left;
            } else if (proposedContentOffset.x < self.previousOffsetX  - self.itemSize.width / 3.0) {
                self.previousOffsetX -= self.collectionView.frame.size.width - self.sectionInset.left;
            }
        }else{
            // 分页以1/3处
            if (proposedContentOffset.x > self.previousOffsetX + self.itemSize.width / 3.0) {
                self.previousOffsetX += self.collectionView.frame.size.width - self.minimumLineSpacing - self.sectionInset.left;
            } else if (proposedContentOffset.x < self.previousOffsetX  - self.itemSize.width / 3.0) {
                self.previousOffsetX -= self.collectionView.frame.size.width - self.minimumLineSpacing - self.sectionInset.left;
            }
        }
        proposedContentOffset.x = self.previousOffsetX;
        return proposedContentOffset;
        
    }else{
        
        if (self.sectionInset.top == self.minimumLineSpacing) {
            
            // 分页以1/3处
            if (proposedContentOffset.y > self.previousOffsetY + self.itemSize.height / 5.0) {
                self.previousOffsetY += self.collectionView.frame.size.height - self.sectionInset.top;
            } else if (proposedContentOffset.y < self.previousOffsetY  - self.itemSize.height / 5.0) {
                self.previousOffsetY -= self.collectionView.frame.size.height - self.sectionInset.top;
            }
            
        }else{
          
            // 分页以1/3处
            if (proposedContentOffset.y > self.previousOffsetY + self.itemSize.height / 5.0) {
                self.previousOffsetY += self.collectionView.frame.size.height - self.minimumLineSpacing - self.sectionInset.top;
            } else if (proposedContentOffset.y < self.previousOffsetY  - self.itemSize.height / 5.0) {
                self.previousOffsetY -= self.collectionView.frame.size.height - self.minimumLineSpacing - self.sectionInset.top;
            }
        }
        
        proposedContentOffset.y = self.previousOffsetY;
        
        return proposedContentOffset;
    }
}

@end
