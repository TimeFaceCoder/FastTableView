//
//  TFTableView.m
//  FastTableView
//
//  Created by Melvin on 6/2/15.
//  Copyright (c) 2015 TimeFace. All rights reserved.
//

#import "TFTableView.h"
#import "TFTableViewCell.h"

@interface TFTableView() {
    
}

@end
@implementation TFTableView {
    NSMutableArray  *needLoadArray;
    BOOL            scrollToToping;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        needLoadArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)tableViewWillBeginDragging:(TFTableView *)scrollView {
    [needLoadArray removeAllObjects];
}

//按需加载 - 如果目标行与当前行相差超过指定行数，只在目标滚动范围的前后指定3行加载。
- (void)tableViewWillEndDragging:(TFTableView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    NSIndexPath *ip = [self indexPathForRowAtPoint:CGPointMake(0, targetContentOffset->y)];
    NSIndexPath *cip = [[self indexPathsForVisibleRows] firstObject];
    NSInteger skipCount = 8;
    if (labs(cip.row-ip.row) > skipCount) {
        NSArray *temp = [self indexPathsForRowsInRect:CGRectMake(0, targetContentOffset->y,
                                                                 self.frame.size.width,
                                                                 self.frame.size.height)];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:temp];
        if (velocity.y < 0) {
            NSIndexPath *indexPath = [temp lastObject];
            NSInteger totalCount = [self.dataSource tableView:self
                                        numberOfRowsInSection:indexPath.section];
            if (indexPath.row + 3 < totalCount) {
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:0]];
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row+2 inSection:0]];
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row+3 inSection:0]];
            }
        } else {
            NSIndexPath *indexPath = [temp firstObject];
            if (indexPath.row > 3) {
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row-3 inSection:0]];
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row-2 inSection:0]];
                [arr addObject:[NSIndexPath indexPathForRow:indexPath.row-1 inSection:0]];
            }
        }
        [needLoadArray addObjectsFromArray:arr];
    }
}

- (BOOL)tableViewShouldScrollToTop:(TFTableView *)scrollView {
    scrollToToping = YES;
    return YES;
}

- (void)tableViewDidEndScrollingAnimation:(TFTableView *)scrollView {
    scrollToToping = NO;
    [self loadContent];
}

- (void)tableViewDidScrollToTop:(TFTableView *)scrollView {
    scrollToToping = NO;
    [self loadContent];
}

- (void)callCellForRowAtIndexPath:(NSIndexPath *)indexPath cell:(TFTableViewCell *)cell {
    [cell clearViews];
    if (needLoadArray.count > 0 && [needLoadArray indexOfObject:indexPath]==NSNotFound) {
        [cell clearViews];
        return;
    }
    if (scrollToToping) {
        return;
    }
    [cell drawViews];
}


//用户触摸时第一时间加载内容
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!scrollToToping) {
        [needLoadArray removeAllObjects];
        [self loadContent];
    }
    return [super hitTest:point withEvent:event];
}

- (void)loadContent{
    if (scrollToToping) {
        return;
    }
    if (self.indexPathsForVisibleRows.count<=0) {
        return;
    }
    if (self.visibleCells && self.visibleCells.count>0) {
        for (id temp in [self.visibleCells copy]) {
            TFTableViewCell *cell = (TFTableViewCell *)temp;
            [cell drawViews];
        }
    }
}

- (void)removeFromSuperview {
    for (UIView *temp in self.subviews) {
        for (TFTableViewCell *cell in temp.subviews) {
            if ([cell isKindOfClass:[TFTableViewCell class]]) {
                [cell releaseMemory];
            }
        }
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self reloadData];
    [needLoadArray removeAllObjects];
    needLoadArray = nil;
    [super removeFromSuperview];
}

@end
