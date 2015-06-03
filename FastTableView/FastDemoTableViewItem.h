//
//  FastDemoTableViewItem.h
//  FastTableView
//
//  Created by Melvin on 6/2/15.
//  Copyright (c) 2015 TimeFace. All rights reserved.
//

#import "RETableViewItem.h"

@interface FastDemoTableViewItem : RETableViewItem

@property (nonatomic, strong) NSDictionary  *data;

@property (nonatomic, assign) NSInteger     index;

@property (nonatomic, assign) CGFloat       contentHeight;

@property (nonatomic, assign) CGFloat       contentImageHeight;

+ (FastDemoTableViewItem*)itemWithModel:(NSDictionary*)data;


@end
