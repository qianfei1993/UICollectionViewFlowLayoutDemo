//
//  HorizontalScaleViewController.m
//  UICollectionViewFlowLayoutDemo
//
//  Created by damai on 2019/5/13.
//  Copyright © 2019 personal. All rights reserved.
//

#import "HorizontalScaleViewController.h"
#import "Header.h"
#import "FirstCollectionViewCell.h"
#import "TypeHorizontalScaleFlowLayout.h"
@interface HorizontalScaleViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) BaseCollectionView *collectionView;
@property (nonatomic, strong) TypeHorizontalScaleFlowLayout *flowLayout1;
@property (nonatomic, strong) TypeHorizontalScaleFlowLayout *flowLayout2;
@end

@implementation HorizontalScaleViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupRightBarButtonItem];
    [self setupWithCollectionView];
}

- (void)setupRightBarButtonItem{
    
    UIButton *rightBarButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightBarButton setTitle:@"切换大小" forState:UIControlStateNormal];
    [rightBarButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBarButton addTarget:self action:@selector(rightBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBarButton];
}

- (void)rightBarButtonAction:(UIButton*)sender{
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.collectionView.collectionViewLayout = self.flowLayout2;
    }else{
        self.collectionView.collectionViewLayout = self.flowLayout1;
    }
    [self.collectionView reloadData];
}

- (void)setupWithCollectionView{

    self.collectionView = [[BaseCollectionView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, kScreenWidth, kScreenHeight-kNavBarHeight) collectionViewLayout:self.flowLayout1];
    [self.view addSubview:self.collectionView];
    self.collectionView.bounces = YES;
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    // 隐藏水平滚动条
    self.collectionView.showsHorizontalScrollIndicator = NO;
    // 取消弹簧效果
    self.collectionView.bounces = NO;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"FirstCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"FirstCollectionViewCellID"];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    NSArray *arr = self.collectionView.dataArray[section];
    return 50;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FirstCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FirstCollectionViewCellID" forIndexPath:indexPath];
    cell.contentView.backgroundColor = kRandomColor;
    cell.titleLabel.text = [NSString stringWithFormat:@"%ld--",(long)indexPath.item];
    return cell;
}

-(TypeHorizontalScaleFlowLayout *)flowLayout1{
    if (!_flowLayout1) {
        _flowLayout1 = [[TypeHorizontalScaleFlowLayout alloc]initWithScrollDirection:UICollectionViewScrollDirectionHorizontal withItemSize:CGSizeMake(kScreenWidth-40, kScreenHeight-kNavBarHeight-60) withColumnSpacing:20 withRowSpacing:0 withEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 20)];
    }
    return _flowLayout1;
}
- (TypeHorizontalScaleFlowLayout *)flowLayout2{
    if (!_flowLayout2) {
        _flowLayout2 = [[TypeHorizontalScaleFlowLayout alloc]initWithScrollDirection:UICollectionViewScrollDirectionHorizontal withItemSize:CGSizeMake(kScreenWidth-80, kScreenHeight-kNavBarHeight-60) withColumnSpacing:20 withRowSpacing:0 withEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 40)];
    }
    return _flowLayout2;
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
