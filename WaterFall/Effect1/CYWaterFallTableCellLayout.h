//
//  CYWaterFallTableCellLayout.h
//  173Framework
//
//  Created by cyou-Mac-004 on 13-5-29.
//  Copyright (c) 2013年 lancy. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @class
 @abstract 瀑布流中一个图片基本单位。
 */
@class CYWaterFallTableCell;

@interface CYWaterFallTableCellLayout : NSObject

/*图片处于第几列*/
@property (nonatomic, assign) int column;
/*图片位置*/
@property (nonatomic, assign) float x;
@property (nonatomic, assign) float y;
@property (nonatomic, assign) float width;
@property (nonatomic, assign) float height;
@property (nonatomic, assign) CGRect frame;
/*图片标志*/
@property (nonatomic, assign) int cellIndex;
/*图片view*/
@property (nonatomic, assign) CYWaterFallTableCell *cell;
/*tableview是否刷新*/
@property (nonatomic, assign) BOOL hasDrawnInTableView;

/*!
 @method
 @abstract 获得CYWaterFallTableCellLayout实例。
 @param column 显示内容在第几列； frame 显示区域； cellIndex
 @return id 返回实例
 */
- (id)initWithColumn:(int)column frame:(CGRect)frame cellIndex:(int)cellIndex;
/*!
 @method
 @abstract 返回底部y坐标。
 @param nil
 @return float 返回底部y坐标
 */
- (float)getBottom;
/*!
 @method
 @abstract 判断当前cell是否在屏幕显示。
 @param rect 显示区域
 @return BOOL 是否在显示区域
 */
- (BOOL)isVisibleInRect:(CGRect)rect;
/*!
 @method
 @abstract 获取当前控件位置。
 @param nil
 @return CGRect 返回位置
 */
- (CGRect)getFrame;
@end
