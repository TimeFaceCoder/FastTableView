//
//  ViewController.m
//  FastTableView
//
//  Created by Melvin on 6/2/15.
//  Copyright (c) 2015 TimeFace. All rights reserved.
//

#import "ViewController.h"
#import "TFTableView.h"
#import "TableViewDataSource.h"

@interface ViewController ()

@end

@implementation ViewController {
    TFTableView         *_tableView;
    TableViewDataSource *_dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _tableView = [[TFTableView alloc] initWithFrame:self.view.bounds
                                              style:UITableViewStylePlain];
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.view addSubview:_tableView];
    
    _dataSource = [[TableViewDataSource alloc] initWithTableView:_tableView];
    [_dataSource load:LoadPolicyNone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
