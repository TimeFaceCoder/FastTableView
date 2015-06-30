//
//  TFTableView.h
//  FastTableView
//
//  Created by Melvin on 6/2/15.
//  Copyright (c) 2015 TimeFace. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TFTableViewCell;

@interface TFTableView : UITableView


- (void)tableViewWillBeginDragging:(TFTableView *)scrollView;
- (void)tableViewWillEndDragging:(TFTableView *)scrollView
                    withVelocity:(CGPoint)velocity
             targetContentOffset:(inout CGPoint *)targetContentOffset;
- (BOOL)tableViewShouldScrollToTop:(TFTableView *)scrollView;
- (void)tableViewDidEndScrollingAnimation:(TFTableView *)scrollView;
- (void)tableViewDidScrollToTop:(TFTableView *)scrollView;
- (void)callCellForRowAtIndexPath:(NSIndexPath *)indexPath cell:(TFTableViewCell *)cell;
@end
