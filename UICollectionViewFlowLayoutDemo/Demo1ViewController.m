//
//  Demo1ViewController.m
//  UICollectionViewFlowLayoutDemo
//
//  Created by damai on 2019/5/14.
//  Copyright © 2019 personal. All rights reserved.
//

#import "Demo1ViewController.h"
#import "Header.h"
#import "FirstCollectionViewCell.h"
#import "TestFlowLayout.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define ITEM_ZOOM 0.05
#define THE_ACTIVE_DISTANCE 230
#define LEFT_OFFSET 60
@interface Demo1ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) BaseCollectionView *collectionView;

@end

@implementation Demo1ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupWithCollectionView];
}

- (void)setupWithCollectionView{
    
    TestFlowLayout *flowLayout = [[TestFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 20;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 50, 0, 50);
    flowLayout.itemSize = CGSizeMake(kScreenWidth-100, kScreenHeight-kNavBarHeight);
    
    self.collectionView = [[BaseCollectionView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, kScreenWidth, kScreenHeight-kNavBarHeight) collectionViewLayout:flowLayout];
    
    [self.view addSubview:self.collectionView];
    
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
    return 50;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FirstCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FirstCollectionViewCellID" forIndexPath:indexPath];
    cell.contentView.backgroundColor = kRandomColor;
    cell.titleLabel.text = [NSString stringWithFormat:@"%ld--",(long)indexPath.item];
    return cell;
}


@end
