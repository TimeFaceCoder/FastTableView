//
//  TFTableViewCell.m
//  FastTableView
//
//  Created by Melvin on 6/2/15.
//  Copyright (c) 2015 TimeFace. All rights reserved.
//

#import "TFTableViewCell.h"
#import "TFTableView.h"

@implementation TFTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        
    }
    return self;
}

- (void)drawViews {
    
}

- (void)clearViews {
    
}

- (void)releaseMemory {
    
}

- (void)cellDidLoad {
    [super cellDidLoad];
}

- (void)cellWillAppear {
    [super cellWillAppear];
    if ([self.parentTableView isKindOfClass:[TFTableView class]]) {
        [(TFTableView *)self.parentTableView callCellForRowAtIndexPath:
         [NSIndexPath indexPathForRow:self.rowIndex inSection:self.sectionIndex]
                                                                  cell:self];
    }
}


- (void)cellDidDisappear {
    [super cellDidDisappear];
    //重用准备
}

@end
