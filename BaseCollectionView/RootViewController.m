//
//  RootViewController.m
//  BaseCollectionView
//
//  Created by damai on 2019/5/5.
//  Copyright © 2019 personal. All rights reserved.
//

#import "RootViewController.h"
#import "NormalTypeViewController.h"
#import "VerticalTypeViewController.h"
#import "HorizontalViewController.h"
#import "VerticalAligmentViewController.h"
#import "HorizontalAlignmentViewController.h"
#import "MixViewController.h"
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
    
    for (NSUInteger i = 0; i < 5; i++) {
        
        NSString *str = [NSString stringWithFormat:@"%ld",i];
        self.testArr[i] = str;
        [self.testArr1 addObject:@(i)];
        NSLog(@"before %ld",i);
    }
    
    for (NSUInteger i = 0; i < 5; i++) {
        NSLog(@"last %ld",i);
    }
    NSLog(@"%@===%@",self.testArr,self.testArr1);
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
        
        NSString *str = self.testArr[0];
        str = @"5";
        self.testArr[0] = str;
//        self.testArr[0] = @(5);
        NSLog(@"%@",self.testArr);
        //
        // 普通样式
        [self.navigationController pushViewController:[NormalTypeViewController new] animated:YES];
    }
    
    if (indexPath.row == 1) {
        // 垂直瀑布流
        [self.navigationController pushViewController:[VerticalTypeViewController new] animated:YES];
    }
    
    if (indexPath.row == 2) {
        // 水平瀑布流
        [self.navigationController pushViewController:[HorizontalViewController new] animated:YES];
    }
    
    if (indexPath.row == 3) {
        // 垂直顺序布局
        [self.navigationController pushViewController:[VerticalAligmentViewController new] animated:YES];
    }
    
    if (indexPath.row == 4) {
        // 水平顺序布局
        [self.navigationController pushViewController:[HorizontalAlignmentViewController new] animated:YES];
    }
    
    if (indexPath.row == 5) {
        // 混合布局
        [self.navigationController pushViewController:[MixViewController new] animated:YES];
    }
    
    
}


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithObjects:@"普通样式",@"垂直瀑布流-纵向滑动",@"水平瀑布流-横向滑动",@"垂直顺序布局-横向滑动",@"水平顺序布局-纵向滑动",@"混合布局", nil];
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
