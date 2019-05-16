//
//  TestFlowLayout.m
//  UICollectionViewFlowLayoutDemo
//
//  Created by damai on 2019/5/15.
//  Copyright © 2019 personal. All rights reserved.
//

#import "TestFlowLayout.h"

@implementation TestFlowLayout
- (void)prepareLayout {
    [super prepareLayout];

}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
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
            self.previousOffsetX += self.collectionView.frame.size.width - 30 - self.sectionInset.left;
        } else if (proposedContentOffset.x < self.previousOffsetX  - self.itemSize.width / 3.0) {
            self.previousOffsetX -= self.collectionView.frame.size.width - 30 - self.sectionInset.left;
        }
    }
    proposedContentOffset.x = self.previousOffsetX;
    return proposedContentOffset;
}

@end
