//
//  ZJHomeViewController.m
//  AVPlayerDemo
//
//  Created by 邓志坚 on 2018/10/10.
//  Copyright © 2018 邓志坚. All rights reserved.
//

#import "ZJHomeViewController.h"
#import "ZJPlayVideoViewController.h"
static NSString *cellID = @"cell_key";
@interface ZJHomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTable;

@property (nonatomic, strong) NSArray *titleArr;

@end

@implementation ZJHomeViewController

-(UITableView *)mainTable{
    if (!_mainTable) {
        _mainTable = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        _mainTable.tableFooterView = [[UIView alloc]init];
        [_mainTable registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
        _mainTable.backgroundColor = [UIColor whiteColor];
        _mainTable.rowHeight = 60;
    }
    return _mainTable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleArr = @[@"视频播放"];
    [self.view addSubview:self.mainTable];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.textLabel.text = self.titleArr[indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
            case 0:
        {
            ZJPlayVideoViewController *playVideo = [[ZJPlayVideoViewController alloc]init];
            [self.navigationController pushViewController:playVideo animated:true] ;
        }
            break;
            
        default:
            break;
    }
}

@end
