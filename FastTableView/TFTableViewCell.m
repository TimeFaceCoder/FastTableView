//
//  TFTableViewCell.m
//  FastTableView
//
//  Created by Melvin on 6/2/15.
//  Copyright (c) 2015 TimeFace. All rights reserved.
//

#import "TFTableViewCell.h"

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

@end
