//
//  CYWaterFallTableView.h
//  173Framework
//
//  Created by cyou-Mac-004 on 13-5-29.
//  Copyright (c) 2013年 lancy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>
#import "CYWaterFallTableCell.h"
//#import "EGORefreshTableHeaderView.h"

@protocol CYWaterFallTableViewDataSource;
@protocol CYWaterFallTableViewDelegate;

/*列数*/
#define CYWaterFallTableViewColumnNumber       2
/*列间隔*/
#define CYWaterFallTableViewColumnPadding      5
/*行间隔*/
#define CYWaterFallTableViewRowPadding         5
/*回收池大小*/ 
#define CYWaterFallTableViewRecyclePoolSize    6

/*!
 @class
 @abstract 实现瀑布流的View。
 */

@interface CYWaterFallTableView : UIView<UIScrollViewDelegate, CYWaterFallTableCellDelegate>
{
}
/*是否支持下拉刷新*/ 
@property (nonatomic, assign) BOOL enablePullToRefresh;
@property (nonatomic, assign) BOOL isCellEditing;
 
@property (nonatomic, assign) id<CYWaterFallTableViewDelegate> delegate;
@property (nonatomic, assign) id<CYWaterFallTableViewDataSource> datasource;

/*!
 @method
 @abstract 刷新瀑布流数据。
 @param nil
 @return nil
 */
- (void) reloadData;
/*!
 @method
 @abstract 数据刷新完成。
 @param nil
 @return void
 */
- (void) didFinishLoading;
/*!
 @method
 @abstract CYWaterFallTableCell重用。
 @param reusableCellId 重用ID
 @return CYWaterFallTableCell 返回重用cell
 */
- (CYWaterFallTableCell*) dequeueReusableCellWithIdentifier:(NSString*)reusableCellId;

@end

#pragma mark - delegate
/*!
 @protocol
 @abstract delegate。
 */
@protocol CYWaterFallTableViewDelegate <NSObject>
@optional
- (void)waterFallTableViewDidSelectedAccessoryLabel:(int)index;
- (void)waterFallDeleteClicked:(int)index;
/*!
 @method
 @abstract 瀑布流中的图片被点击。
 @param tableView 瀑布流view； index：被点击的图片序号
 @return nil
 */
- (void) waterFallTableView:(CYWaterFallTableView*)tableView
     didSelectedCellAtIndex:(int)index;
/*!
 @method
 @abstract 瀑布流滑动到底部。
 @param tableView 瀑布流view
 @return nil
 */
- (void) waterFallTableViewDidScrollToBottom:(CYWaterFallTableView*)tableView;

/*!
 @method
 @abstract 瀑布流拖拽刷新。
 @param tableView 瀑布流view
 @return nil
 */
- (void) waterFallTableViewDidDrigglerFrefresh:(CYWaterFallTableView*)tableView;

/*!
 @method
 @abstract 判断瀑布流是否在刷新。
 @param tableView 瀑布流view
 @return BOOL 是否在loading
 */
- (BOOL) waterFallTableViewIsLoading:(CYWaterFallTableView*)tableView;
@end

#pragma mark - datasource
/*!
 @protocol
 @abstract data source。
 */
@protocol CYWaterFallTableViewDataSource <NSObject>

/*!
 @method
 @abstract 生成CYWaterFallTableCell。
 @param tableView 瀑布流view； index 标记
 @return CYWaterFallTableCell 返回cell
 */
- (CYWaterFallTableCell*)waterFallTableView:(CYWaterFallTableView*)tableView cellAtIndex:(int)index;
/*!
 @method
 @abstract 生成CYWaterFallTableCell的高度。
 @param tableView 瀑布流view； index 标记
 @return int 返回cell高度
 */
- (int)waterFallTableView:(CYWaterFallTableView*)tableView heightOfCellAtIndex:(int)index;

/*!
 @method
 @abstract 生成CYWaterFallTableCell的行数。
 @param tableView 瀑布流view
 @return int 返回tableView行数
 */
- (int)numberOfRowsWaterFallTableView:(CYWaterFallTableView*)tableView;

@end
