//
//  TableViewDataSource.h
//  FastTableView
//  全局TableView数据集与UI处理,沟通 View 与 Data
//  Created by Melvin on 6/2/15.
//  Copyright (c) 2015 TimeFace. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TFTableView;

typedef NS_ENUM(NSInteger, LoadPolicy) {
    /**
     *  正常加载
     */
    LoadPolicyNone      = 0,
    /**
     *  加载下一页
     */
    LoadPolicyMore      = 1,
    /**
     *  重新加载
     */
    LoadPolicyReload    = 2,
};


@interface TableViewDataSource : NSObject {
    
}


- (id)initWithTableView:(TFTableView *)tableView;

- (void)load:(LoadPolicy)loadPolicy;

@end
