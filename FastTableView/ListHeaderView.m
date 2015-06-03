//
//  ListHeaderView.m
//  PDMS
//
//  Created by Melvin on 7/22/14.
//  Copyright (c) 2014 Melvin. All rights reserved.
//

#import "ListHeaderView.h"

@implementation ListHeaderView

+ (ListHeaderView *)headerView {
    ListHeaderView *view = [[ListHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 0)];
    return view;
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

@end
