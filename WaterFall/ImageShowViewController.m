//
//  ImageShowViewController.m
//  CollectionTest
//
//  Created by cyou-Mac-003 on 13-7-12.
//  Copyright (c) 2013年 cyou-Mac-003. All rights reserved.
//

#import "ImageShowViewController.h"

@interface ImageShowViewController () {

    UIImage* _image;
}

@end

@implementation ImageShowViewController

- (instancetype)initWithShowImage:(UIImage*)image
{
    self = [super init];
    if (self) {
        _image = image;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    ShowImageScrollView* scrollView = [[ShowImageScrollView alloc] initWithFrame:self.view.bounds withShowImage:_image];
    [self.view addSubview:scrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
