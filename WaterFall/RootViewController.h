//
//  RootViewController.h
//  WaterFall
//
//  Created by cyou-Mac-003 on 13-12-18.
//  Copyright (c) 2013年 cyou-Mac-003. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExhibitonFallViewController.h"
#import "CYViewController.h"

@interface RootViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) IBOutlet UITableView* listTableView;
@end
