//
//  CYWaterFallTableCell.h
//  173Framework
//
//  Created by cyou-Mac-004 on 13-5-29.
//  Copyright (c) 2013年 lancy. All rights reserved.
//
#import "UIView+CYAdditions.h"
#import "CYXibView.h"

@protocol CYWaterFallTableCellDelegate;

/*!
 @class
 @abstract 瀑布流中一个图片基本view。
 */
@interface CYWaterFallTableCell : UIView <UIGestureRecognizerDelegate>
{
}

/*!
 @method
 @abstract 获得CYWaterFallTableCell单例。
 @param nil
 @return id 返回单例
 */
+ (id)cellFromNib;
+ (id)cellFromNibWithIdentifier:(NSString*)identifier;

/*委托代理*/
@property (nonatomic,assign) id<CYWaterFallTableCellDelegate> delegate;
/*cell是否正在滑动*/
@property (nonatomic,assign) BOOL scrolling;
/*cell标记*/
@property (nonatomic,assign) NSInteger index;
/*可重用cell ID*/
@property (nonatomic,retain) NSString *reusableCellId;
@property (nonatomic, readwrite) BOOL isCellEditing;

/*!
 @method
 @abstract 判断当前cell是否在屏幕显示。
 @param rect 显示区域
 @return BOOL 是否在显示区域
 */
- (BOOL) isVisibleInRect:(CGRect)rect;
/*!
 @method
 @abstract 重置［暂时未使用此方法重置，而是回收了不再屏幕显示的cell］。
 @param nil
 @return void
 */
- (void) recyleAllComponents;
@end

/*!
 @protocol
 @abstract 支持瀑布流图片代理。
 */
@protocol CYWaterFallTableCellDelegate <NSObject>
@optional
/*!
 @method
 @abstract 瀑布流图片被点击回调。
 @param cell 被点击cell
 @return void
 */
- (void)waterFallTableCellSelected:(CYWaterFallTableCell*)cell;
- (void)waterFallDidSelectedAccessoryLabel:(CYWaterFallTableCell*)cell;
- (void)deleteBtnClicked:(CYWaterFallTableCell*)cell;
@end