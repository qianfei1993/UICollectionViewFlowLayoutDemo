//
//  VerticalOrderViewController.m
//  BaseCollectionView
//
//  Created by damai on 2019/5/6.
//  Copyright © 2019 personal. All rights reserved.
//

#import "VerticalOrderViewController.h"
#import "Header.h"
#import "FirstCollectionViewCell.h"
#import "TypeVerticalOrderFlowLayout.h"
@interface VerticalOrderViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) BaseCollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray; /** 数据源 */
@property (nonatomic, assign) NSInteger sectionNum; /** 分组 */
@property (nonatomic, strong) UILabel *textLabel;
@end

@implementation VerticalOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupRightBarButtonItem];
    [self setupWithCollectionView];
}

- (void)setupRightBarButtonItem{
    _sectionNum = 1;
    UIButton *rightBarButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightBarButton setTitle:@"增加分组" forState:UIControlStateNormal];
    [rightBarButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBarButton addTarget:self action:@selector(rightBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *rightBarButton1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightBarButton1 setTitle:@"减少分组" forState:UIControlStateNormal];
    [rightBarButton1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBarButton1 addTarget:self action:@selector(rightBarButton1Action:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:rightBarButton];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:rightBarButton1];
    self.navigationItem.rightBarButtonItems = @[item,item1];
}

- (void)rightBarButtonAction:(UIButton*)sender{
    
    _sectionNum++;
    [self.collectionView reloadData];
}
- (void)rightBarButton1Action:(UIButton*)sender{
    if (_sectionNum > 1) {
        _sectionNum--;
        [self.collectionView reloadData];
    }
}
- (void)setupWithCollectionView{
    
    TypeVerticalOrderFlowLayout *flowLayout = [[TypeVerticalOrderFlowLayout alloc]initWithColumnOrRowCount:3 withColumnSpacing:10 withRowSpacing:20 withEdgeInsets:UIEdgeInsetsMake(20, 15, 20, 15)];
    self.collectionView = [[BaseCollectionView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, kScreenWidth, kScreenHeight-kNavBarHeight) collectionViewLayout:flowLayout];
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"FirstCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"FirstCollectionViewCellID"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderViewID"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterViewID"];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _sectionNum;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FirstCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FirstCollectionViewCellID" forIndexPath:indexPath];
    cell.contentView.backgroundColor = kRandomColor;
    cell.titleLabel.text = [NSString stringWithFormat:@"%ld--%@",(long)indexPath.item,self.dataArray[indexPath.item]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = self.dataArray[indexPath.item];
    CGSize size = [self stringSize:str];
    return CGSizeMake(size.width, size.height);
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

- (NSMutableArray*)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithObjects:@"御神风御神风御神风御神风御神风御神风御神风御神风御神风御神风御神风御神风御神风御神风御神风", @"悟剑声", @"任云踪",@"白衣剑少", @"靖沧浪", @"擎海潮",@"南风不竞", @"寒烟翠", @"玄真君", @"太虚子", @"花非花", @"织梦师", @"地冥", @"人觉", @"天迹", @"无神论", @"非常君", @"玉逍遥", @"一页书", @"脱俗仙子谈无欲", @"清香白莲素还真", @"任平生", @"映红雪", @"应无骞", @"剑颠命夫子", @"法儒", @"君奉天", @"离凡", @"剑随风", @"乱世狂刀乱世狂刀乱世狂刀乱世狂刀乱世狂刀乱世狂刀乱世狂刀乱世狂刀乱世狂刀乱世狂刀", @"疏雨孟尝", @"风采铃", @"剑君十二恨", @"秦假仙", @"鷇音子", @"柳生剑影", @"最光阴", @"佛剑分说", @"傲笑红尘", @"弃天帝", @"慕少艾", @"莫召奴", @"凝渊", @"剑子仙迹", @"青阳子", nil];
    }
    return _dataArray;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    return _textLabel;
}

- (CGSize)textContentSize:(NSString *)text {
    self.textLabel.font = [UIFont systemFontOfSize:15];
    self.textLabel.text = text;
    [self.textLabel sizeToFit];
    CGFloat labelWidth = MIN(self.collectionView.frame.size.width - 80, ceil(self.textLabel.frame.size.width));
    return CGSizeMake(labelWidth+50, ceil(self.textLabel.frame.size.height) );
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
