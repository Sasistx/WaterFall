//
//  CYCollectionViewLayout.h
//  CollectionTest
//
//  Created by cyou-Mac-003 on 13-7-11.
//  Copyright (c) 2013年 cyou-Mac-003. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CYCollectionViewLayout;
@protocol CYCollectionViewLayoutDelegate <UICollectionViewDelegate>
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(CYCollectionViewLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface CYCollectionViewLayout : UICollectionViewLayout
@property (nonatomic, weak) id <CYCollectionViewLayoutDelegate> delegate;
@property (nonatomic, assign) NSUInteger columnCount;
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) UIEdgeInsets sectionInset;
@end
