//
//  BaseCollectionView.h
//  BaseCollectionView
//
//  Created by damai on 2019/4/26.
//  Copyright © 2019 personal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^mjheaderBlock) (void);
typedef void(^mjfooterBlock) (void);
@interface BaseCollectionView : UICollectionView

// 添加MJHeader
- (void)addMJHeader:(mjheaderBlock)block;

// 添加MJFooter
- (void)addMJFooter:(mjfooterBlock)block;

//TableVIew  ReloadData
- (void)baseReloadData;

@property(nonatomic,strong)NSMutableArray *dataArray; /** 数据源 */
@end

NS_ASSUME_NONNULL_END
