//
//  ExhibitionCell.m
//  WaterFall
//
//  Created by cyou-Mac-003 on 13-12-18.
//  Copyright (c) 2013年 cyou-Mac-003. All rights reserved.
//

#import "ExhibitionCell.h"

@interface ExhibitionCell ()
{
    
}

@end

@implementation ExhibitionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createCellImage];
    }
    return self;
}

- (void)createCellImage
{
    _cellImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [_cellImageView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_cellImageView];
}

- (void)layoutSubviews
{
    //NSLog(@"layoutSubviews");
    [_cellImageView setFrame:self.bounds];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
