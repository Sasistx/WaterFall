//
//  CYViewController.h
//  CollectionTest
//
//  Created by cyou-Mac-003 on 13-7-11.
//  Copyright (c) 2013年 cyou-Mac-003. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYCollectionViewLayout.h"
#import "CYCollectionCell.h"
#import "ImageShowViewController.h"
@interface CYViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic) CGFloat cellWidth;
@end
