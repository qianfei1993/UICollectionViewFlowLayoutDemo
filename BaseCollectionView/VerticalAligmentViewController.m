//
//  VerticalAligmentViewController.m
//  BaseCollectionView
//
//  Created by damai on 2019/5/6.
//  Copyright © 2019 personal. All rights reserved.
//

#import "VerticalAligmentViewController.h"
#import "Header.h"
#import "FirstCollectionViewCell.h"
@interface VerticalAligmentViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) BaseCollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray; /** 数据源 */
@property (nonatomic, assign) BOOL isSection; /** 是否分组 */
@end

@implementation VerticalAligmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
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
    
    BaseCollectionViewFlowLayout *flowLayout = [[BaseCollectionViewFlowLayout alloc]initWithFlowLayoutType:FlowLayoutTypeHorizontalOrder withColumnOrRowCount:4 withColumnSpacing:10 withRowSpacing:20 withEdgeInsets:UIEdgeInsetsMake(20, 15, 20, 15)];
    self.collectionView = [[BaseCollectionView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, kScreenWidth, 500) collectionViewLayout:flowLayout];
    [self.view addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"FirstCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"FirstCollectionViewCellID"];
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
    
    FirstCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FirstCollectionViewCellID" forIndexPath:indexPath];
    cell.contentView.backgroundColor = kRandomColor;
    cell.titleLabel.text = [NSString stringWithFormat:@"%ld--%@",indexPath.item,self.dataArray[indexPath.item]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = self.dataArray[indexPath.item];
    CGSize size = [str sizeForFont:[UIFont systemFontOfSize:15] size:CGSizeMake(kScreenWidth-30, 100) mode:NSLineBreakByWordWrapping];
    return CGSizeMake(size.width + 20, size.height + 16);
}

- (NSMutableArray*)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithObjects:@"NSStNSStrinngNSStringring", @"NSMutableString", @"NSArray", @"UITapGestureRecognizer", @"IBOutlet", @"IBAction", @"UIView", @"UIStatusBar", @"UITableViewController", @"UIStepper", @"UISegmentedControl", @"UICollectionViewController", @"UISearchBar", @"UIToolbar", @"UIPageControl", @"UIActionSheet", @"NSMutableArray", @"NSDictionary", @"NSMutableDictionary", @"NSSet", @"NSMutableSet", @"NSData", @"NSMutableData", @"NSDate", @"NSCalendar", @"UIButton", @"UILabel", @"UITextField", @"UITextView", @"UIImageView", @"UITableView", @"UICollectionView", @"UIViewController", @"UIImageView", @"UITableView", @"UICollectionView", @"UIViewController", @"UIImageView", @"UITableView", @"UICollectionView", @"UIViewController", @"UIImageView", @"UITableView", @"UICollectionView", @"UIViewController", nil];
    }
    return _dataArray;
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
