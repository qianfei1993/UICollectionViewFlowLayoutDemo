//
//  VerticalTypeViewController.m
//  BaseCollectionView
//
//  Created by damai on 2019/5/5.
//  Copyright © 2019 personal. All rights reserved.
//

#import "VerticalTypeViewController.h"
#import "Header.h"
#import "SecondCollectionViewCell.h"
@interface VerticalTypeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,BaseCollectionViewFlowLayoutDelegate>
@property (nonatomic, strong) BaseCollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArray; /** 数据源 */
@property (nonatomic, assign) BOOL isSection; /** 是否分组 */
@end

@implementation VerticalTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNewShops];
    [self setupRightBarButtonItem];
    [self setupWithCollectionView];
}

- (void)setupRightBarButtonItem{
    
    UIButton *rightBarButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightBarButton setTitle:@"添加分组" forState:UIControlStateNormal];
    [rightBarButton setTitle:@"取消分组" forState:UIControlStateSelected];
    [rightBarButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBarButton addTarget:self action:@selector(rightBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBarButton];
}

- (void)rightBarButtonAction:(UIButton*)sender{
    sender.selected = !sender.selected;
    self.isSection = sender.selected;
    [self.collectionView reloadData];
}

- (void)setupWithCollectionView{
    
    BaseCollectionViewFlowLayout *flowLayout = [[BaseCollectionViewFlowLayout alloc]initWithFlowLayoutType:FlowLayoutTypeVerticalEqualWidth withColumnOrRowCount:3 withColumnSpacing:10 withRowSpacing:20 withEdgeInsets:UIEdgeInsetsMake(20, 15, 20, 15)];
    //UIEdgeInsetsMake(20, 15, 20, 15)
    self.collectionView = [[BaseCollectionView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, kScreenWidth, kScreenHeight-kNavBarHeight) collectionViewLayout:flowLayout];
    [self.view addSubview:self.collectionView];
//    [self.collectionView addMJHeader:^{
//        [weakSelf loadNewShops];
//    }];
//    [self.collectionView addMJFooter:^{
//        [weakSelf loadNewShops];
//    }];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"SecondCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"SecondCollectionViewCellID"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderViewID"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterViewID"];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    if (self.isSection) {
        return 2;
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SecondCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SecondCollectionViewCellID" forIndexPath:indexPath];
    if (!cell) {
        cell = [[SecondCollectionViewCell alloc]init];
    }
    cell.contentView.backgroundColor = kRandomColor;
    NSDictionary *dict = self.dataArray[indexPath.item];
    NSString *imgStr = [NSString stringWithFormat:@"%@",dict[@"img"]];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imgStr]];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.item];
    cell.contentView.backgroundColor = kRandomColor;
    return cell;
    
}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    
//}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataArray[indexPath.item];
    NSString *w = dict[@"w"];
    NSString *h = dict[@"h"];
    return [self sizeWithimgHeight:h.floatValue withImgWidth:w.floatValue];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    // 头部视图
    if (kind == UICollectionElementKindSectionHeader){
        
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HeaderViewID" forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor yellowColor];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:headerView.bounds];
        titleLabel.text = [NSString stringWithFormat:@"第%ld个分区的区头",indexPath.section];
        [headerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [headerView addSubview:titleLabel];
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(kScreenWidth, 55);
    }
    return CGSizeMake(kScreenWidth, 55);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return CGSizeMake(kScreenWidth, 44);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout columnCountForSection:(NSInteger)section{
    
    if (section == 0) {
        return 3;
    }
    return 4;
}

/**
 * 加载新的商品
 */
- (void)loadNewShops{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"shop" ofType:@"plist"];
        self.dataArray = [[NSArray alloc]initWithContentsOfFile:path];
        // 刷新表格
        [self.collectionView baseReloadData];
    });
}

// 高度/宽度 = 压缩后高度/压缩后宽度
- (CGSize)sizeWithimgHeight:(float)height withImgWidth:(float)width{
    CGFloat itemW = (kScreenWidth - 30 - 20)/3;
    CGFloat itemH = itemW / width * height;
    return CGSizeMake(itemW, itemH);
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
