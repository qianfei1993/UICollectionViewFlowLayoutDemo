//
//  TableViewController.m
//  UICollectionViewFlowLayoutDemo
//
//  Created by damai on 2019/5/13.
//  Copyright © 2019 personal. All rights reserved.
//

#import "TableViewController.h"
#import "NormalTypeViewController.h"
#import "VerticalScrambledViewController.h"
#import "VerticalOrderViewController.h"
#import "HorizontalScrambledViewController.h"
#import "HorizontalOrderViewController.h"
#import "DemoViewController.h"
#import "HorizontalScaleViewController.h"
#import "HorizontalScale1ViewController.h"
#import "Demo1ViewController.h"
#import "DragViewController.h"
#import "Drag1ViewController.h"
@interface TableViewController ()
@property (nonatomic, strong) NSMutableArray *dataArray; /** 数据源 */
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.rowHeight = 44;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        // 普通样式
        [self.navigationController pushViewController:[NormalTypeViewController new] animated:YES];
    }
 
    if (indexPath.row == 1) {
        // 垂直瀑布流--Item等宽不等高-补充最短列排列
        [self.navigationController pushViewController:[VerticalScrambledViewController new] animated:YES];
    }
    
    if (indexPath.row == 2) {
        // 垂直瀑布流--Item不等高不等宽-顺序排列
        [self.navigationController pushViewController:[VerticalOrderViewController new] animated:YES];
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
        // 垂直瀑布流--Item不等高不等宽-顺序排列-仿数据加载
        [self.navigationController pushViewController:[DemoViewController new] animated:YES];
    }
    
    if (indexPath.row == 6) {
        // 卡片式水平滑动
        [self.navigationController pushViewController:[HorizontalScaleViewController new] animated:YES];
    }
    
    if (indexPath.row == 7) {
        // 卡片式垂直滑动
        [self.navigationController pushViewController:[HorizontalScale1ViewController new] animated:YES];
    }
    if (indexPath.row == 8) {
        // demo
        [self.navigationController pushViewController:[Demo1ViewController new] animated:YES];
    }
    if (indexPath.row == 9) {
        // item拖拽
        [self.navigationController pushViewController:[DragViewController new] animated:YES];
    }
    if (indexPath.row == 10) {
        // item拖拽1
        [self.navigationController pushViewController:[Drag1ViewController new] animated:YES];
    }
    
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithObjects:@"普通样式",@"垂直瀑布流--Item等宽不等高-补充最短列排列",@"垂直瀑布流--Item不等高不等宽-顺序排列",@"水平瀑布流--补充最短行排列",@"水平瀑布流--顺序排列",@"垂直瀑布流--Item不等高不等宽-仿数据加载",@"卡片式水平滑动",@"卡片式垂直滑动",@"demo",@"item拖拽",@"item拖拽1", nil];
        [self.tableView reloadData];
    }
    return _dataArray;
}


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
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
