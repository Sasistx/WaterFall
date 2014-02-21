//
//  CYCollectionCell.m
//  CollectionTest
//
//  Created by cyou-Mac-003 on 13-7-11.
//  Copyright (c) 2013年 cyou-Mac-003. All rights reserved.
//

#import "CYCollectionCell.h"

@implementation CYCollectionCell

#pragma mark - Accessors
- (UIImageView *)cellImageView
{
    if (!_cellImageView) {
        
        _cellImageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _cellImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _cellImageView.backgroundColor = [UIColor lightGrayColor];
    }
    return _cellImageView;
}


#pragma mark - Life Cycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self.contentView addSubview:self.cellImageView];
    }
    return self;
}
@end
