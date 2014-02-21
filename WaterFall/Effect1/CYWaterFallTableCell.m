//
//  CYWaterFallTableCell.m
//  173Framework
//
//  Created by cyou-Mac-004 on 13-5-29.
//  Copyright (c) 2013年 lancy. All rights reserved.
//

#import "CYWaterFallTableCell.h"

@interface CYWaterFallTableCell()

- (void)onViewTapped;

@end

@implementation CYWaterFallTableCell

@synthesize reusableCellId = _reusableCellId;
@synthesize delegate = _delegate;
@synthesize index;
@synthesize scrolling;
@synthesize isCellEditing = _isCellEditing;

#pragma mark - private methods
/*!
 @method
 @abstract 瀑布流中的图片被点击，回调。
 @param nil
 @return void
 */
- (void)onViewTapped{
    if (_delegate && [_delegate respondsToSelector:@selector(waterFallTableCellSelected:)]) {
        [_delegate waterFallTableCellSelected:self];
    }
}

#pragma mark - lifecycle methods
- (void)dealloc{
    _delegate = nil;
    [_reusableCellId release];
    [super dealloc];
}

/*!
 @method
 @abstract 创建对象。
 @param nil
 @return id 返回对象
 */
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.userInteractionEnabled = YES;
        
        /*添加手势*/
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onViewTapped)];
        tapGR.delegate = self;
        tapGR.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGR];
        [tapGR release];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame withReusableCellId:(NSString *)reusableCellId{
    self = [super initWithFrame:frame];
    if (self) {
        if (reusableCellId) {
            _reusableCellId = [reusableCellId retain];
        }
    }
    return self;
}
#pragma mark - public methods
- (BOOL)isVisibleInRect:(CGRect)rect
{
    if (self.top > rect.origin.y + rect.size.height + 20)
    {
        // below the area
        return NO;
    }
    if (self.bottom < rect.origin.y - 20)
    {
        // below the area
        return NO;
    }
    return YES;
}
- (void) recyleAllComponents
{
    
}
+ (id)cellFromNib
{
    NSString *xibName = NSStringFromClass([self class]);
    return [[[NSBundle mainBundle] loadNibNamed:xibName owner:self options:nil] objectAtIndex:0];
}
+ (id)cellFromNibWithIdentifier:(NSString*)identifier
{
    NSString *xibName = NSStringFromClass([self class]);
    CYWaterFallTableCell *cell = [[[NSBundle mainBundle] loadNibNamed:xibName owner:self options:nil] objectAtIndex:0];
    cell.reusableCellId = identifier;
    return cell;
}

#pragma mark - gesture delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIView* view = [touch view];
    if ([view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}

@end
