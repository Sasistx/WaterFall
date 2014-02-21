//
//  CYWaterFallTableCellLayout.m
//  173Framework
//
//  Created by cyou-Mac-004 on 13-5-29.
//  Copyright (c) 2013年 lancy. All rights reserved.
//

#import "CYWaterFallTableCellLayout.h"

@implementation CYWaterFallTableCellLayout
@synthesize column = _column;
@synthesize x = _x;
@synthesize y = _y;
@synthesize width = _width;
@synthesize height = _height;
@synthesize cellIndex = _cellIndex;
@synthesize frame = _frame;
@synthesize cell = _cell;

@synthesize hasDrawnInTableView = _hasDrawnInTableView;

- (void) setFrame:(CGRect)frame
{
    _x = frame.origin.x;
    _y = frame.origin.y;
    _width = frame.size.width;
    _height = frame.size.height;
}
- (void)dealloc
{
    self.cell = nil;
    [super dealloc];
}
- (id)initWithColumn:(int)column frame:(CGRect)frame cellIndex:(int)cellIndex{
    self = [super init];
    if (self)
    {
        _column = column;
        _x = frame.origin.x;
        _y = frame.origin.y;
        _width = frame.size.width;
        _height = frame.size.height;
        _cellIndex = cellIndex;
        _hasDrawnInTableView = NO;
    }
    return self;
}
- (float)getBottom{
    return _y + _height;
}
- (CGRect)getFrame{
    return CGRectMake(_x, _y, _width, _height);
}
// check if this cell is in the rect vertically
- (BOOL)isVisibleInRect:(CGRect)rect{
    if (_y > rect.origin.y + rect.size.height + 20) {
        // below the area
        return NO;
    }
    if (_y + _height < rect.origin.y - 20) {
        // above the area
        return NO;
    }
    return YES;
}
- (NSString*)description{
    return [NSString stringWithFormat:@"layout for cell at index[%d],column[%d],frame:%@, hasDrawn:%d",_cellIndex,_column,NSStringFromCGRect([self getFrame]),self.hasDrawnInTableView];
}

@end
