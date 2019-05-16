//
//  Drag1ViewController.m
//  UICollectionViewFlowLayoutDemo
//
//  Created by damai on 2019/5/16.
//  Copyright © 2019 personal. All rights reserved.
//

#import "Drag1ViewController.h"

#import "Header.h"
#import "FirstCollectionViewCell.h"
#import "TypeNormalFlowLayout.h"
@interface Drag1ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) BaseCollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray; /** 数据源 */
@property (nonatomic,strong)NSMutableArray *cellAttributesArray;
@property (nonatomic,assign)BOOL isChange;
@end

@implementation Drag1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupWithCollectionView];
}

- (void)setupWithCollectionView{
    
    TypeNormalFlowLayout *flowLayout = [[TypeNormalFlowLayout alloc]initWithColumnOrRowCount:0 withColumnSpacing:10 withRowSpacing:10 withEdgeInsets:UIEdgeInsetsMake(20, 15, 20, 15)];
    flowLayout.itemSize = CGSizeMake((kScreenWidth - 50)/3, 100);
    self.collectionView = [[BaseCollectionView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, kScreenWidth, kScreenHeight-kNavBarHeight) collectionViewLayout:flowLayout];
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"FirstCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"FirstCollectionViewCellID"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderViewID"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterViewID"];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FirstCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FirstCollectionViewCellID" forIndexPath:indexPath];
    cell.contentView.backgroundColor = kRandomColor;
    cell.titleLabel.text = [NSString stringWithFormat:@"%ld--%@",(long)indexPath.item,self.dataArray[indexPath.item]];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    if (indexPath.item == self.dataArray.count) {
        
        [cell removeGestureRecognizer:longPress];
    }else {
        [cell addGestureRecognizer:longPress];
    }
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

//
//- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
//    return YES;
//}
//
//
//- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath{
//    id objc = [self.dataArray objectAtIndex:sourceIndexPath.item];
//    //从资源数组中移除该数据
//    [self.dataArray removeObject:objc];
//    //将数据插入到资源数组中的目标位置上
//    [self.dataArray insertObject:objc atIndex:destinationIndexPath.item];
//    [self.collectionView baseReloadData];
//}


- (void)longPressAction:(UILongPressGestureRecognizer *)longPress {
    
    FirstCollectionViewCell *cell = (FirstCollectionViewCell *)longPress.view;
    NSIndexPath *cellIndexpath = [_collectionView indexPathForCell:cell];
    
    [_collectionView bringSubviewToFront:cell];
    
    _isChange = NO;
    
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan: {
            [self.cellAttributesArray removeAllObjects];
            for (int i = 0; i < self.dataArray.count; i++) {
                [self.cellAttributesArray addObject:[_collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]]];
            }
            
        }
            break;
            
        case UIGestureRecognizerStateChanged: {
            
            cell.center = [longPress locationInView:_collectionView];
            
            for (UICollectionViewLayoutAttributes *attributes in self.cellAttributesArray) {
                if (CGRectContainsPoint(attributes.frame, cell.center) && cellIndexpath != attributes.indexPath) {
                    _isChange = YES;
                    NSString *imgStr = self.dataArray[cellIndexpath.row];
                    [self.dataArray removeObjectAtIndex:cellIndexpath.row];
                    [self.dataArray insertObject:imgStr atIndex:attributes.indexPath.row];
                    [self.collectionView moveItemAtIndexPath:cellIndexpath toIndexPath:attributes.indexPath];
                }
            }
        }
            break;
            
        case UIGestureRecognizerStateEnded: {
            
            if (!_isChange) {
                cell.center = [_collectionView layoutAttributesForItemAtIndexPath:cellIndexpath].center;
                [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
            }
        }
            
            break;
            
        default:
            break;
    }
    
}

- (NSMutableArray*)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithObjects:@"御神风御神风御神风御神风御神风御神风御神风御神风御神风御神风御神风御神风御神风御神风御神风", @"悟剑声", @"任云踪",@"白衣剑少", @"靖沧浪", @"擎海潮",@"南风不竞", @"寒烟翠", @"玄真君", @"太虚子", @"花非花", @"织梦师", @"地冥", @"人觉", @"天迹", @"无神论", @"非常君", @"玉逍遥", @"一页书", @"脱俗仙子谈无欲", @"清香白莲素还真", @"任平生", @"映红雪", @"应无骞", @"剑颠命夫子", @"法儒", @"君奉天", @"离凡", @"剑随风", @"乱世狂刀乱世狂刀乱世狂刀乱世狂刀乱世狂刀乱世狂刀乱世狂刀乱世狂刀乱世狂刀乱世狂刀", @"疏雨孟尝", @"风采铃", @"剑君十二恨", @"秦假仙", @"鷇音子", @"柳生剑影", @"最光阴", @"佛剑分说", @"傲笑红尘", @"弃天帝", @"慕少艾", @"莫召奴", @"凝渊", @"剑子仙迹", @"青阳子", nil];
    }
    return _dataArray;
}

- (NSMutableArray *)cellAttributesArray {
    if(_cellAttributesArray == nil) {
        _cellAttributesArray = [[NSMutableArray alloc] init];
    }
    return _cellAttributesArray;
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
