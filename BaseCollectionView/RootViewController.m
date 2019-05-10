//
//  RootViewController.m
//  BaseCollectionView
//
//  Created by damai on 2019/5/5.
//  Copyright © 2019 personal. All rights reserved.
//

#import "RootViewController.h"
#import "NormalTypeViewController.h"
#import "VerticalEqualWidthViewController.h"
#import "HorizontalScrambledViewController.h"
#import "HorizontalOrderViewController.h"
#import "VerticalEqualHeightViewController.h"
#import "DemoViewController.h"
@interface RootViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray; /** 数据源 */
@property (nonatomic, strong) NSMutableArray *testArr; /** 数据源 */
@property (nonatomic, strong) NSMutableArray *testArr1; /** 数据源 */
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithTableView];
}
#pragma mark —————UITableView—————
- (void)initWithTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1 ;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.dataArray[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    
    if (indexPath.row == 0) {
        // 普通样式
        [self.navigationController pushViewController:[NormalTypeViewController new] animated:YES];
    }
    
    if (indexPath.row == 1) {
        // 垂直瀑布流--Item等宽不等高
        [self.navigationController pushViewController:[VerticalEqualWidthViewController new] animated:YES];
    }
    
    if (indexPath.row == 2) {
        // 垂直瀑布流--Item等高不等宽
        [self.navigationController pushViewController:[VerticalEqualHeightViewController new] animated:YES];
    }
    
    if (indexPath.row == 3) {
        // 水平瀑布流--补充最短行排列
        [self.navigationController pushViewController:[HorizontalScrambledViewController new] animated:YES];
        
    }
    
    if (indexPath.row == 4) {
        // 水平瀑布流--顺序排列
        [self.navigationController pushViewController:[HorizontalOrderViewController new] animated:YES];
    }
    
    if (indexPath.row == 5) {
        // 垂直瀑布流--Item等高不等宽
        [self.navigationController pushViewController:[DemoViewController new] animated:YES];
    }
    
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithObjects:@"普通样式",@"垂直瀑布流--Item等宽不等高",@"垂直瀑布流--Item等高不等宽",@"水平瀑布流--补充最短行排列",@"水平瀑布流--顺序排列",@"垂直瀑布流--Item等高不等宽-仿数据加载", nil];
    }
    return _dataArray;
}

- (NSMutableArray *)testArr{
    if (!_testArr) {
        _testArr = [NSMutableArray array];
    }
    return _testArr;
}

- (NSMutableArray *)testArr1{
    if (!_testArr1) {
        _testArr1 = [NSMutableArray array];
    }
    return _testArr1;
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
