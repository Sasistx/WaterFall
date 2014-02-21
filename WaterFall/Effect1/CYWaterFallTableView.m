//
//  CYWaterFallTableView.m
//  173Framework
//
//  Created by cyou-Mac-004 on 13-5-29.
//  Copyright (c) 2013年 lancy. All rights reserved.
//

#import "CYWaterFallTableView.h"
#import "CYWaterFallTableCellLayout.h"

@interface CYWaterFallTableView()
{
    BOOL            _scrolling;
    BOOL            _layouting;
    NSInteger       _currentFirstVisibleCellIndex;
    NSInteger       _currentLastVisibleCellIndex;
    NSMutableArray  *_columnCellFrameArrayByColumn;      //this is used when calculating layouts
    NSMutableArray  *_cellLayoutsArray;                  //store cell layout by cell index order,this is used when layouting cell
    NSMutableSet    *_resuableCellLayoutsSet;
    NSMutableSet    *_reusableCellPool;
    
    NSMutableSet    *_visibleCellSet;
    NSMutableSet    *_recyledCellSet;
    
//    EGORefreshTableHeaderView   *_refreshHeaderView;
    
    UIScrollView    *_scrollView;
}

- (void) setupView;
- (void) setupColumnCellFrameArrayWithColumnCount:(int)columnCount;

- (float) leftForColumnAtIndex:(int)columnIndex;

- (NSMutableArray*) cellFrameArrayAtColumn:(int)column;

// get calculated cell layout
- (CYWaterFallTableCellLayout*) getLayoutForCellAtIndex:(int)cellIndex;
- (CYWaterFallTableCellLayout*) getLayoutForNextCellWithCellIndex:(int)cellIndex
                                                        cellHeight:(float)cellHeight;
- (void) drawVisibleCells;
- (void) recycleInvisibleCells;
- (void) addToRecyclePool:(CYWaterFallTableCell*)cell;

@end

@implementation CYWaterFallTableView

@synthesize enablePullToRefresh = _enablePullToRefresh;
@synthesize datasource = _datasource;
@synthesize delegate = _delegate;
@synthesize isCellEditing = _isCellEditing;

#pragma mark - private methods
- (void) setupColumnCellFrameArrayWithColumnCount:(int)columnCount
{
    if (!_columnCellFrameArrayByColumn) {
        _columnCellFrameArrayByColumn = [[NSMutableArray alloc] init];
    }
    else {
        [_columnCellFrameArrayByColumn removeAllObjects];
    }
    for (int i = 0; i < columnCount; i++) {
        [_columnCellFrameArrayByColumn addObject:[NSMutableArray array]];
    }
    if (!_cellLayoutsArray) {
        _cellLayoutsArray = [[NSMutableArray alloc] init];
    }
}
- (NSMutableArray*) cellFrameArrayAtColumn:(int)column
{
    return [_columnCellFrameArrayByColumn objectAtIndex:column];
}
- (CYWaterFallTableCellLayout*) getLayoutForCellAtIndex:(int)cellIndex
{
    return [_cellLayoutsArray objectAtIndex:cellIndex];
}
- (float) leftForColumnAtIndex:(int)columnIndex
{
    if (columnIndex == 0) {
        return 0;
    }
    else {
        int columnCount = CYWaterFallTableViewColumnNumber;
        int colPadding = CYWaterFallTableViewColumnPadding;
        int columnWidth = (self.width - colPadding*(columnCount - 1))/columnCount;
        return columnIndex * (columnWidth + colPadding);
    }
}
- (CYWaterFallTableCellLayout*) getCellLayoutWithCellIndex:(int)cellIndex column:(int)column frame:(CGRect)frame
{
    CYWaterFallTableCellLayout *layout = [_resuableCellLayoutsSet anyObject];
    if (layout) {
        [[layout retain] autorelease];
        [_resuableCellLayoutsSet removeObject:layout];
    }
    if (!layout) {
        layout = [[[CYWaterFallTableCellLayout alloc] initWithColumn:column frame:frame cellIndex:cellIndex] autorelease];
    }
    else {
        layout.column = column;
        layout.frame = frame;
        layout.hasDrawnInTableView = NO;
        layout.cellIndex = cellIndex;
    }
    return layout;
}
- (CYWaterFallTableCellLayout*)getLayoutForNextCellWithCellIndex:(int)cellIndex cellHeight:(float)cellHeight
{
    CYWaterFallTableCellLayout *layoutForNextCell = nil;
    BOOL startPointFound = NO;
    int columnCount = CYWaterFallTableViewColumnNumber;
    int colPadding = CYWaterFallTableViewColumnPadding;
    int columnWidth = (self.width - colPadding*(columnCount - 1))/columnCount;
    NSMutableArray *lastCellLayoutForEachColumn = [NSMutableArray array];
    for (int col = 0; col < [_columnCellFrameArrayByColumn count]; col++) {
        NSMutableArray *colCellFrameArray = [_columnCellFrameArrayByColumn objectAtIndex:col];
        if ([colCellFrameArray count] == 0) {
            float x = [self leftForColumnAtIndex:col];
            startPointFound = YES;
            CGRect frm = CGRectMake(x, 0, columnWidth, cellHeight);
            layoutForNextCell = [self getCellLayoutWithCellIndex:cellIndex column:col frame:frm];
            break;
        }
        [lastCellLayoutForEachColumn addObject:[colCellFrameArray lastObject]];
    }
    if (!startPointFound) {
        float minHeight = MAXFLOAT;
        int column = 0;
        for (int col = 0; col < [lastCellLayoutForEachColumn count]; col++) {
            CYWaterFallTableCellLayout *layout = [lastCellLayoutForEachColumn objectAtIndex:col];
            if ([layout getBottom] < minHeight) {
                minHeight = [layout getBottom];
                column = col;
            }
        }
        float x = [self leftForColumnAtIndex:column];
        CGRect frm = CGRectMake(x, minHeight + CYWaterFallTableViewRowPadding, columnWidth, cellHeight);
        layoutForNextCell = [self getCellLayoutWithCellIndex:cellIndex column:column frame:frm];
    }
    return layoutForNextCell;
    
}
- (int)getIndexByCell:(CYWaterFallTableCell*)cell
{
    for (int i = 0; i<[_cellLayoutsArray count]; i++) {
        CYWaterFallTableCellLayout *layout = [_cellLayoutsArray objectAtIndex:i];
        if ((int)(cell.left) == (int)(layout.x) && (int)(cell.top) == (int)(layout.y)) {
            return i;
        }
    }
    return -1;
}
- (void)setupView
{
    _scrolling = FALSE;
    //prepare reusable pool
    _resuableCellLayoutsSet = [[NSMutableSet alloc] init];
    if (!_reusableCellPool) {
        _reusableCellPool  = [[NSMutableSet alloc] init];
    }
    else {
        [_reusableCellPool removeAllObjects];
    }
    if (!_visibleCellSet) {
        _visibleCellSet = [[NSMutableSet alloc] init];
    }
    else {
        [_visibleCellSet removeAllObjects];
    }
    if (!_recyledCellSet) {
        _recyledCellSet = [[NSMutableSet alloc] init];
    }
    else {
        [_recyledCellSet removeAllObjects];
    }
    
    if(iPhone5) {
        self.height = 504;
    }else{
        self.height = 416;
    }
    
    //add scroll view
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds) + 6, CGRectGetHeight(self.bounds))];
        _scrollView.clipsToBounds = TRUE;
    }
    if (!_scrollView.superview) {
        [self addSubview:_scrollView];
    }
    _enablePullToRefresh = FALSE;
//    if (!_refreshHeaderView) {
//        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - _scrollView.bounds.size.height, _scrollView.frame.size.width, _scrollView.bounds.size.height)];
//        _refreshHeaderView.delegate = self;
//        _refreshHeaderView.hidden = TRUE;
//        [_scrollView addSubview:_refreshHeaderView];
//    }
    _scrollView.delegate = self;
}
- (void) setEnablePullToRefresh:(BOOL)enablePullToRefresh
{
    _enablePullToRefresh = enablePullToRefresh;
//    if (_enablePullToRefresh) {
//        _refreshHeaderView.hidden = FALSE;
//    }
//    else {
//        _refreshHeaderView.hidden = TRUE;
//    }
}
- (BOOL) isCellDisplayingAtIndex:(NSInteger)index
{
    BOOL found = FALSE;
    for (CYWaterFallTableCell *cell in _visibleCellSet) {
        if (cell.index == index) {
            found = TRUE;
            break;
        }
    }
    return found;
}
- (BOOL) isCellVisibleRangeDidChanged
{
    NSInteger firstCellIndex = [self getFirstVisibleCellIndex];
    NSInteger lastCellIndex = [self getLastVisibleCellIndex];
    BOOL isChang = (firstCellIndex != _currentFirstVisibleCellIndex||
                    lastCellIndex != _currentLastVisibleCellIndex);
    _currentFirstVisibleCellIndex = firstCellIndex;
    _currentLastVisibleCellIndex = lastCellIndex;
    return isChang;
}
- (void)addToRecyclePool:(CYWaterFallTableCell*)cell
{
    [_reusableCellPool addObject:cell];
    //    if ([_reusableCellPool count] > CYWaterFallTableViewRecyclePoolSize)
    //    {
    //        return;
    //    }
}
- (void) reuseAllCellLayouts
{
    if (_cellLayoutsArray && [_cellLayoutsArray count])
    {
        for (CYWaterFallTableCellLayout *layout in _cellLayoutsArray) {
            layout.cell = nil;
            layout.cell.scrolling = FALSE;
            layout.hasDrawnInTableView = NO;
            layout.cellIndex = NSNotFound;
        }
        [_resuableCellLayoutsSet addObjectsFromArray:_cellLayoutsArray];
        [_cellLayoutsArray removeAllObjects];
    }
}
- (void) recycleAllCells
{
    for (CYWaterFallTableCell *cell in _visibleCellSet) {
        cell.isCellEditing = self.isCellEditing;
        cell.scrolling = FALSE;
        cell.index = NSNotFound;
        [cell recyleAllComponents];
        [_recyledCellSet addObject:cell];
        [cell removeFromSuperview];
    }
    [_visibleCellSet minusSet:_recyledCellSet];
}
- (void) recycleInvisibleCells
{
    NSInteger firstCellIndex = [self getFirstVisibleCellIndex];
    NSInteger lastCellIndex = [self getLastVisibleCellIndex];
    for (CYWaterFallTableCell *cell in _visibleCellSet) {
        if (cell.index < firstCellIndex||(lastCellIndex >= 0 && cell.index > lastCellIndex)){
            cell.scrolling = FALSE;
            [cell recyleAllComponents];
            CYWaterFallTableCellLayout *layout = [_cellLayoutsArray objectAtIndex:cell.index];
            layout.cell = nil;
            layout.hasDrawnInTableView = NO;
            cell.index = NSNotFound;
            [_recyledCellSet addObject:cell];
            [cell removeFromSuperview];
        }
    }
    [_visibleCellSet minusSet:_recyledCellSet];
}
- (void) drawVisibleCells
{
    NSInteger firstCellIndex = [self getFirstVisibleCellIndex];
    NSInteger lastCellIndex = [self getLastVisibleCellIndex];
    for (NSInteger cellIndex = firstCellIndex; cellIndex <= lastCellIndex; cellIndex++) {
        CYWaterFallTableCellLayout *layout = [_cellLayoutsArray objectAtIndex:cellIndex];
        if (!layout.hasDrawnInTableView) {
            CYWaterFallTableCell *cell = layout.cell;
            if (!cell) {
                cell = [_datasource waterFallTableView:self cellAtIndex:cellIndex];
            }
            else {
            }
            layout.cell = cell;
            cell.scrolling = _scrolling;
            cell.delegate = self;
            cell.index = cellIndex;
            cell.frame = [layout getFrame];
            [cell layoutSubviews];
            [_scrollView addSubview:cell];
            layout.hasDrawnInTableView = YES;
            if (cell) {
                [_visibleCellSet addObject:cell];
            }
        }
    }
}
#pragma mark - lifecyle methods

- (void)dealloc
{
    _delegate = nil;
    _datasource = nil;
//    RELEASE_SAFELY(_columnCellFrameArrayByColumn);
//    RELEASE_SAFELY(_cellLayoutsArray);
//    RELEASE_SAFELY(_resuableCellLayoutsSet);
//    RELEASE_SAFELY(_reusableCellPool);
//    RELEASE_SAFELY(_visibleCellSet);
//    RELEASE_SAFELY(_recyledCellSet);
//    RELEASE_SAFELY(_scrollView);
//    RELEASE_SAFELY(_refreshHeaderView);
    [super dealloc];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupView];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}
- (void)setDatasource:(id<CYWaterFallTableViewDataSource>)datasource
{
    NSLog(@"%@", datasource);
    if ([datasource isKindOfClass:[NSNull class]]) {
        NSLog(@"is null");
    }
    if (datasource == nil) {
        return;
    }
    _datasource = datasource;
    [self reloadData];
}
- (void) didFinishLoading
{
//	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_scrollView];
}
- (BOOL) findWaterFallTableViewIsLoading
{
    BOOL loading = FALSE;
    if (_delegate && [_delegate respondsToSelector:@selector(waterFallTableViewIsLoading:)]) {
        loading = [_delegate waterFallTableViewIsLoading:self];
    }
    return loading;
}
#pragma mark - UIScrollViewDelegate
- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//	CYDINFO(@"scrollViewDidEndDragging");
    //pull down
    if (scrollView.contentOffset.y < 0) {
        BOOL loading = [self findWaterFallTableViewIsLoading];
        if (!loading) {
            if (_enablePullToRefresh) {
//                [_refreshHeaderView egoRefreshScrollViewDidEndDragging:_scrollView];
            }
        }
    }
    else {
        if (scrollView.contentOffset.y + scrollView.bounds.size.height > scrollView.contentSize.height) {
            //reach bottom
            if (_delegate && [_delegate respondsToSelector:@selector(waterFallTableViewDidScrollToBottom:)]) {
                [_delegate waterFallTableViewDidScrollToBottom:self];
            }
        }
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    BOOL loading = [self findWaterFallTableViewIsLoading];
    if (!loading) {
        if (_enablePullToRefresh) {
//            [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
        }
    }
    if (scrollView.contentOffset.y < 0) {
        return;
    }
    if ([self isCellVisibleRangeDidChanged]) {
        
        if (!_layouting) {
            _layouting = TRUE;
            [self recycleInvisibleCells];
            [self drawVisibleCells];
            _layouting = FALSE;
        }
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _scrolling = TRUE;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    CYDINFO(@"scrollViewDidEndDecelerating");
    _scrolling = FALSE;
    //load image data here
    for (CYWaterFallTableCell *cell in _visibleCellSet) {
        cell.scrolling = _scrolling;
        [cell setNeedsLayout];
    }
}
#pragma mark - public methods
- (CYWaterFallTableCell*)dequeueReusableCellWithIdentifier:(NSString*)reusableCellId
{
    CYWaterFallTableCell *reuseCell = nil;
    for (CYWaterFallTableCell *cell in _recyledCellSet) {
        if ([cell.reusableCellId isEqualToString:reusableCellId]) {
            reuseCell = [[cell retain] autorelease];
            [_recyledCellSet removeObject:cell];
            break;
        }
    }
    return reuseCell;
}
- (NSInteger) getFirstVisibleCellIndex
{
    NSInteger index = 0;
    NSInteger count = [_cellLayoutsArray count];
    while (index < count) {
        CYWaterFallTableCellLayout *layout = [_cellLayoutsArray objectAtIndex:index];
        if ([layout isVisibleInRect:_scrollView.bounds]) {
            break;
        }
        index++;
    }
    return index;
}
- (NSInteger) getLastVisibleCellIndex {
    NSInteger count = [_cellLayoutsArray count];
    NSInteger index = count - 1;
    while (index >= 0) {
        CYWaterFallTableCellLayout *layout = [_cellLayoutsArray objectAtIndex:index];
        if ([layout isVisibleInRect:_scrollView.bounds]) {
            break;
        }
        index--;
    }
    return index;
}
- (void)reloadData
{
    if (!_datasource) {
//        CYDERROR(@"no datasource found for waterFallTableView:%@", self);
    }
    else {
        [self recycleAllCells];
        [self reuseAllCellLayouts];
        //setup columnCellFrameArray , build basic cell layout structure
        [self setupColumnCellFrameArrayWithColumnCount:CYWaterFallTableViewColumnNumber];
        int cellCount = [_datasource numberOfRowsWaterFallTableView:self];
        //calculate height and get all cell layout
        int maxHeight = 0;
        for (int i = 0; i < cellCount; i++) {
            int height = [_datasource waterFallTableView:self heightOfCellAtIndex:i];
            CYWaterFallTableCellLayout *layout = [self getLayoutForNextCellWithCellIndex:i cellHeight:height];
            [_cellLayoutsArray addObject:layout];
            [[self cellFrameArrayAtColumn:layout.column] addObject:layout];
            maxHeight = MAX(maxHeight, [layout getBottom]);
        }
        if (maxHeight < CGRectGetHeight(_scrollView.frame)) {
            maxHeight = CGRectGetHeight(_scrollView.frame) + 20;
        }
        [_scrollView setContentSize:CGSizeMake(self.bounds.size.width, maxHeight)];
        [self drawVisibleCells];
    }
}
#pragma mark - CYWaterFallTableCellDelegate methods
- (void)deleteBtnClicked:(CYWaterFallTableCell*)cell {
   
    if (_delegate && [_delegate respondsToSelector:@selector(waterFallDeleteClicked:)]) {
        [_delegate waterFallDeleteClicked:cell.index];
    }
}

- (void)waterFallDidSelectedAccessoryLabel:(CYWaterFallTableCell*)cell {
    
    if (_delegate && [_delegate respondsToSelector:@selector(waterFallTableViewDidSelectedAccessoryLabel:)]) {
        [_delegate waterFallTableViewDidSelectedAccessoryLabel:cell.index];
    }
}
- (void)waterFallTableCellSelected:(CYWaterFallTableCell*)cell
{
    if (_delegate && [_delegate respondsToSelector:@selector(waterFallTableView:didSelectedCellAtIndex:)]) {
        [_delegate waterFallTableView:self didSelectedCellAtIndex:cell.index];
    }
}
//- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
//{
//    if (_enablePullToRefresh) {
//        if (_delegate && [_delegate respondsToSelector:@selector(waterFallTableViewDidDrigglerFrefresh:)]) {
//            [_delegate waterFallTableViewDidDrigglerFrefresh:self];
//        }
//    }
//}
//- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
//{
//    if (_delegate && [_delegate respondsToSelector:@selector(waterFallTableViewDidDrigglerFrefresh:)]) {
//        return[self findWaterFallTableViewIsLoading];
//    }
//    else {
//        return FALSE;
//    }
//}
//- (void)egoRefreshTableHeaderDidTouched:(EGORefreshTableHeaderView*)view
//{
//}
//- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
//{
//    return [NSDate date];
//}
@end
