//
//  NormalTypeViewController.m
//  BaseCollectionView
//
//  Created by damai on 2019/5/5.
//  Copyright © 2019 personal. All rights reserved.
//

#import "NormalTypeViewController.h"
#import "Header.h"
#import "FirstCollectionViewCell.h"
@interface NormalTypeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet BaseCollectionView *collectionView;
@property (nonatomic, assign) NSInteger page; /** 分页 */
@end

@implementation NormalTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
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
    
    [self.collectionView addMJHeader:^{
        self.page = 0;
        [self loadData];
    }];
    
    [self.collectionView addMJFooter:^{
        self.page++ ;
        [self loadData];
    }];
    BaseCollectionViewFlowLayout *flowLayout = [[BaseCollectionViewFlowLayout alloc]initWithFlowLayoutType:FlowLayoutTypeNormal withColumnOrRowCount:0 withColumnSpacing:10 withRowSpacing:10 withEdgeInsets:UIEdgeInsetsMake(20, 15, 20, 15)];
//    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
//    flowLayout.minimumLineSpacing = 10;
//    flowLayout.minimumInteritemSpacing = 10;
//    flowLayout.sectionInset = UIEdgeInsetsMake(20, 15, 20, 15);
    flowLayout.itemSize = CGSizeMake((kScreenWidth - 50)/3, 100);
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"FirstCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"FirstCollectionViewCellID"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderViewID"];
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
        
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HeaderViewID" forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor yellowColor];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:headerView.bounds];
        titleLabel.text = [NSString stringWithFormat:@"第%ld个分区的区头",(long)indexPath.section];
        [headerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [headerView addSubview:titleLabel];
        return headerView;
    }
    // 尾部视图
    if(kind == UICollectionElementKindSectionFooter){
        
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"FooterViewID" forIndexPath:indexPath];
        footerView.backgroundColor = [UIColor blueColor];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:footerView.bounds];
        titleLabel.text = [NSString stringWithFormat:@"第%ld个分区的区尾",(long)indexPath.section];
        [footerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [footerView addSubview:titleLabel];
        return footerView;
    }
    return nil;
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
            NSArray *array = @[@"假数据1", @"假数据2", @"假数据3",@"假数据4", @"假数据5", @"假数据6",@"假数据7", @"假数据8", @"假数据9"];
            [self.collectionView.dataArray addObject:array];
        }
        if (self.page > 0) {
            NSMutableArray *mulArr = [NSMutableArray array];
            for (int i = 0; i < 5; i++) {
                NSString *str = [NSString stringWithFormat:@"新增数据%ld",(long)self.page];
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

/*
- (NSMutableArray*)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithObjects:@"NSStNSStrinngNSStringring", @"NSMutableString", @"NSArray", @"UITapGestureRecognizer", @"IBOutlet", @"IBAction", @"UIView", @"UIStatusBar", @"UITableViewController", @"UIStepper", @"UISegmentedControl", @"UICollectionViewController", @"UISearchBar", @"UIToolbar", @"UIPageControl", @"UIActionSheet", @"NSMutableArray", @"NSDictionary", @"NSMutableDictionary", @"NSSet", @"NSMutableSet", @"NSData", @"NSMutableData", @"NSDate", @"NSCalendar", @"UIButton", @"UILabel", @"UITextField", @"UITextView", @"UIImageView", @"UITableView", @"UICollectionView", @"UIViewController", nil];
    }
    return _dataArray;
}

*/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
