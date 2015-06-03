//
//  FastDemoTableViewItem.m
//  FastTableView
//
//  Created by Melvin on 6/2/15.
//  Copyright (c) 2015 TimeFace. All rights reserved.
//

#import "FastDemoTableViewItem.h"

@implementation FastDemoTableViewItem

+(FastDemoTableViewItem*)itemWithModel:(NSDictionary*)data {
    FastDemoTableViewItem *item = [[FastDemoTableViewItem alloc] init];
    item.data = data;
    item.selectionStyle = UITableViewCellSelectionStyleNone;
    return item;
}

@end
