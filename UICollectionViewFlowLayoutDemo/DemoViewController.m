//
//  DemoViewController.m
//  BaseCollectionView
//
//  Created by damai on 2019/5/6.
//  Copyright © 2019 personal. All rights reserved.
//

#import "DemoViewController.h"
#import "Header.h"
#import "FirstCollectionViewCell.h"
#import "CollectionReusableHeaderView.h"
#import "TypeVerticalOrderFlowLayout.h"
@interface DemoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) BaseCollectionView *collectionView;
@property (nonatomic, assign) NSInteger page; /** 分页 */
@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupRightBarButtonItem];
    [self setupWithCollectionView];
}

- (void)setupRightBarButtonItem{
    
    UIButton *rightBarButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightBarButton setTitle:@"清除数据" forState:UIControlStateNormal];
    [rightBarButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBarButton addTarget:self action:@selector(rightBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBarButton];
}

- (void)rightBarButtonAction:(UIButton*)sender{
    [self.collectionView.dataArray removeAllObjects];
    [self.collectionView baseReloadData];
}

- (void)setupWithCollectionView{
    
    __weak typeof(self) weakSelf = self;
    
    TypeVerticalOrderFlowLayout *flowLayout = [[TypeVerticalOrderFlowLayout alloc]initWithColumnOrRowCount:3 withColumnSpacing:10 withRowSpacing:20 withEdgeInsets:UIEdgeInsetsMake(20, 15, 20, 15)];
    self.collectionView = [[BaseCollectionView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, kScreenWidth, kScreenHeight-kNavBarHeight) collectionViewLayout:flowLayout];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView addMJHeader:^{
        weakSelf.page = 0;
        [weakSelf loadData];
    }];
    
    [self.collectionView addMJFooter:^{
        weakSelf.page++ ;
        [weakSelf loadData];
    }];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"FirstCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"FirstCollectionViewCellID"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionReusableHeaderView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderViewID"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterViewID"];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return self.collectionView.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *arr = self.collectionView.dataArray[section];
    return arr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FirstCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FirstCollectionViewCellID" forIndexPath:indexPath];
    cell.contentView.backgroundColor = kRandomColor;
    NSArray *arr = self.collectionView.dataArray[indexPath.section];
    cell.titleLabel.text = [NSString stringWithFormat:@"%ld--%@",(long)indexPath.item,arr[indexPath.item]];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    // 头部视图
    if (kind == UICollectionElementKindSectionHeader){
        
        CollectionReusableHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HeaderViewID" forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor yellowColor];
        headerView.textLabel.text = [NSString stringWithFormat:@"第%ld个分区的区头",indexPath.section];
        return headerView;
    }
    // 尾部视图
    if(kind == UICollectionElementKindSectionFooter){
        
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"FooterViewID" forIndexPath:indexPath];
        footerView.backgroundColor = [UIColor blueColor];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:footerView.bounds];
        titleLabel.text = [NSString stringWithFormat:@"第%ld个分区的区尾",indexPath.section];
        [footerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [footerView addSubview:titleLabel];
        return footerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = self.collectionView.dataArray[indexPath.section];
    NSString *str = arr[indexPath.item];
    CGSize size = [self stringSize:str];
    return CGSizeMake(size.width, size.height);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(kScreenWidth, 55);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{

    return CGSizeMake(kScreenWidth, 44);
}


//模拟数据
- (void)loadData{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.page == 0) {
            [self.collectionView.dataArray removeAllObjects];
            NSArray *array = @[@"御神风", @"悟剑声",@"黑衣剑少", @"地冥", @"人觉", @"天迹", @"任云踪",@"白衣剑少",@"离凡", @"靖沧浪", @"擎海潮",@"法儒",@"南风不竞", @"寒烟翠", @"玄真君"];
            [self.collectionView.dataArray addObject:array];
        }
        if (self.page > 0) {
            NSMutableArray *mulArr = [NSMutableArray array];
            for (int i = 0; i < 5; i++) {
                NSString *str = [NSString stringWithFormat:@"新增数据"];
                [mulArr addObject:str];
            }
            [self.collectionView.dataArray addObject:mulArr.copy];
        }
        [self.collectionView baseReloadData];
        if (self.page > 3) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
    });
}
- (CGSize)stringSize:(NSString *)string{
    if (string.length == 0) return CGSizeZero;
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 80;
    CGSize contentSize = [string sizeForFont:[UIFont systemFontOfSize:15] size:CGSizeMake(width, 100) mode:NSLineBreakByWordWrapping];
    CGSize size = CGSizeMake(MIN(contentSize.width + 20,width)+50, contentSize.height+10);
    return size;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
