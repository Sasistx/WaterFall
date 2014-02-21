//
//  CYXibViewUtils.m
//  173Framework
//
//  Created by lancy on 13-5-8.
//  Copyright (c) 2013年 lancy. All rights reserved.
//

#import "CYXibViewUtils.h"

@implementation CYXibViewUtils

+ (id)loadViewFromXibNamed:(NSString*)xibName withFileOwner:(id)fileOwner{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:xibName owner:fileOwner options:nil];
    if (array && [array count]) {
        return [array objectAtIndex:0];
    }else {
        return nil;
    }
}

+ (id)loadViewFromXibNamed:(NSString*)xibName {
    return [CYXibViewUtils loadViewFromXibNamed:xibName withFileOwner:self];
}

@end
