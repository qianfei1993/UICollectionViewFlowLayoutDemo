//
//  MixCollectionViewFlowLayout.m
//  BaseCollectionView
//
//  Created by damai on 2019/5/7.
//  Copyright © 2019 personal. All rights reserved.
//

#import "MixCollectionViewFlowLayout.h"

@implementation MixCollectionViewFlowLayout
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
    
//    _itemAttributes = [NSMutableArray array];
//    // 设置默认值
//    self.columnCount = 3;
//    self.rowCount = 3;
//    self.columnSpacing = 10;
//    self.rowSpacing = 20;
//    self.edgeInsets = UIEdgeInsetsMake(20, 10, 20, 10);
//    self.type = FlowLayoutTypeNormal;
}


@end
