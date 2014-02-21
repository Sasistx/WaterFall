//
//  ShowImageScrollView.h
//  CollectionTest
//
//  Created by cyou-Mac-003 on 13-7-12.
//  Copyright (c) 2013年 cyou-Mac-003. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowImageScrollView : UIScrollView <UIScrollViewDelegate>
- (instancetype)initWithFrame:(CGRect)frame withShowImage:(UIImage*)image;
@end
