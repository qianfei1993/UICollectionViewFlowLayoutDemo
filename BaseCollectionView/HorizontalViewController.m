//
//  HorizontalViewController.m
//  BaseCollectionView
//
//  Created by damai on 2019/5/5.
//  Copyright © 2019 personal. All rights reserved.
//

#import "HorizontalViewController.h"
#import "Header.h"
#import "SecondCollectionViewCell.h"
@interface HorizontalViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) BaseCollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArray; /** 数据源 */
@end

@implementation HorizontalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNewShops];
    [self setupWithCollectionView];
}

- (void)setupWithCollectionView{
    
    BaseCollectionViewFlowLayout *flowLayout = [[BaseCollectionViewFlowLayout alloc]initWithFlowLayoutType:FlowLayoutTypeHorizontalScrambled withColumnOrRowCount:3 withColumnSpacing:10 withRowSpacing:20 withEdgeInsets:UIEdgeInsetsMake(20, 15, 20, 15)];
    
    self.collectionView = [[BaseCollectionView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, kScreenWidth, kScreenHeight-kNavBarHeight) collectionViewLayout:flowLayout];
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"SecondCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"SecondCollectionViewCellID"];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
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
    cell.contentView.backgroundColor = kRandomColor;
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.item];
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataArray[indexPath.item];
    NSString *w = dict[@"w"];
    NSString *h = dict[@"h"];
    return [self sizeWithimgHeight:h.floatValue withImgWidth:w.floatValue];
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
    CGFloat itemW = (kScreenHeight-kNavBarHeight - 40 - 20)/3;
    CGFloat itemH = itemW / width * height;
    return CGSizeMake(itemH, itemW);
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
