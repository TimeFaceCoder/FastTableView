//
//  TableViewDataSource.m
//  FastTableView
//
//  Created by Melvin on 6/2/15.
//  Copyright (c) 2015 TimeFace. All rights reserved.
//

#import "TableViewDataSource.h"
#import "ListHeaderView.h"
#import "TFTableView.h"
#import <RETableViewManager/RETableViewManager.h>

#import "FastDemoTableViewItem.h"
#import "FastDemoTableViewItemCell.h"

@interface TableViewDataSource()<RETableViewManagerDelegate> {
    
}
@property (nonatomic ,readwrite ,weak) TFTableView  *tableView;

@end

@implementation TableViewDataSource {
    NSMutableArray      *_dataItems;
    NSIndexPath         *_currentIndexPath;
    RETableViewManager  *_manager;
    
    
    BOOL            reloading;
    BOOL            loading;
    BOOL            finished;
}


- (id)initWithTableView:(TFTableView *)tableView {
    self = [super init];
    if (!self)
        return nil;
    //列表管理器
    self.tableView = tableView;
    _manager = [[RETableViewManager alloc] initWithTableView:tableView delegate:self];
    //列表模式
    _manager.style.defaultCellSelectionStyle = UITableViewCellSelectionStyleNone;
    //注册Cell
    _manager[@"FastDemoTableViewItem"]   = @"FastDemoTableViewItemCell";
    
    return self;
}


- (void)load:(LoadPolicy)loadPolicy {
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        @autoreleasepool {
            NSArray *temp = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"data"
                                                                                             ofType:@"plist"]];
            for (NSDictionary *entry in temp) {
                ListHeaderView *headerView = [ListHeaderView headerView];
                RETableViewSection *section = [RETableViewSection sectionWithHeaderView:headerView];
                [section addItem:[FastDemoTableViewItem itemWithModel:entry]];
                [_manager addSection:section];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            reloading = NO;
        });
    });
}


//按需加载 - 如果目标行与当前行相差超过指定行数，只在目标滚动范围的前后指定3行加载。
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSLog(@"scrollViewWillEndDragging");
}

@end
