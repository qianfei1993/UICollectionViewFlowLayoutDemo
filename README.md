# UICollectionViewFlowLayoutDemo
## 效果图
![](https://github.com/qianfei1993/UICollectionViewFlowLayoutDemo/blob/master/UICollectionViewFlowLayoutDemo/Resources/1.png)
![](https://github.com/qianfei1993/UICollectionViewFlowLayoutDemo/blob/master/UICollectionViewFlowLayoutDemo/Resources/2.png)
![](https://github.com/qianfei1993/UICollectionViewFlowLayoutDemo/blob/master/UICollectionViewFlowLayoutDemo/Resources/3.png)
![](https://github.com/qianfei1993/UICollectionViewFlowLayoutDemo/blob/master/UICollectionViewFlowLayoutDemo/Resources/4.png)
![](https://github.com/qianfei1993/UICollectionViewFlowLayoutDemo/blob/master/UICollectionViewFlowLayoutDemo/Resources/5.png)
![](https://github.com/qianfei1993/UICollectionViewFlowLayoutDemo/blob/master/UICollectionViewFlowLayoutDemo/Resources/6.png)
![](https://github.com/qianfei1993/UICollectionViewFlowLayoutDemo/blob/master/UICollectionViewFlowLayoutDemo/Resources/7.png)
![](https://github.com/qianfei1993/UICollectionViewFlowLayoutDemo/blob/master/UICollectionViewFlowLayoutDemo/Resources/8.png)

## 介绍&使用
#### UICollectionViewFlowLayoutDemo,封装的UICollectionView与UICollectionViewFlowLayout基类，集成下拉刷新，上拉加载，无数据页面，自定义布局属性，支持垂直瀑布流分组，配置公共项，但是并没有将delegate与dataSource独立出来，依赖MJRefresh与LYEmptyView第三方框架；
#### 创建UICollectionView继承自BaseCollectionView，设置布局属性，常规UICollectionView写法，需实现数据源与代理方法；
```
#pragma mark —————BaseCollectionView—————
- (void)initWithTableView{
    // 下拉刷新
    [self.collectionView addMJHeader:^{
        
    }];
    // 上拉加载
    [self.collectionView addMJFooter:^{
      
    }];
    // 配置布局
    BaseCollectionViewFlowLayout *flowLayout = [[BaseCollectionViewFlowLayout alloc]initWithFlowLayoutType:FlowLayoutTypeNormal withColumnOrRowCount:0 withColumnSpacing:10 withRowSpacing:10 withEdgeInsets:UIEdgeInsetsMake(20, 15, 20, 15)];
    flowLayout.itemSize = CGSizeMake((kScreenWidth - 50)/3, 100);
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}
```
