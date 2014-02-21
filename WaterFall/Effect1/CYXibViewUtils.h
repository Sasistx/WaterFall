//
//  CYXibViewUtils.h
//  173Framework
//
//  Created by lancy on 13-5-8.
//  Copyright (c) 2013年 lancy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYXibViewUtils : NSObject

+ (id)loadViewFromXibNamed:(NSString*)xibName withFileOwner:(id)fileOwner;
//  the view must not have any connecting to the file owner
+ (id)loadViewFromXibNamed:(NSString*)xibName;
@end