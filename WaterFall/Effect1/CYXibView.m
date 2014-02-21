//
//  CYXibView.m
//  173Framework
//
//  Created by lancy on 13-5-8.
//  Copyright (c) 2013年 lancy. All rights reserved.
//

#import "CYXibView.h"
#import "CYXibViewUtils.h"

@implementation CYXibView

+ (id)loadFromXib {
    return [CYXibViewUtils loadViewFromXibNamed:NSStringFromClass([self class])];
}

@end
