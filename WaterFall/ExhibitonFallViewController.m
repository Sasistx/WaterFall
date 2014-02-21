//
//  ExhibitonFallViewController.m
//  WaterFall
//
//  Created by cyou-Mac-003 on 13-12-18.
//  Copyright (c) 2013年 cyou-Mac-003. All rights reserved.
//

#import "ExhibitonFallViewController.h"

#define CELL_WIDTH 142.0f

@interface ExhibitonFallViewController ()
{
    NSMutableArray* _imageArray;
    CYWaterFallTableView* waterFall;
}

@end

@implementation ExhibitonFallViewController

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
    _imageArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSInteger i = 0; i < 15; i++) {
        UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", i]];
        [_imageArray addObject:image];
    }
    
    waterFall = [[CYWaterFallTableView alloc] initWithFrame:self.view.bounds];
    [waterFall setDelegate:self];
    [waterFall setDatasource:self];
    [self.view addSubview:waterFall];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [waterFall setDelegate:nil];
    [waterFall setDatasource:nil];
}

#pragma mark - waterfall delegate & datasource

- (int)numberOfRowsWaterFallTableView:(CYWaterFallTableView*)tableView
{
    return [_imageArray count];
}

- (int)waterFallTableView:(CYWaterFallTableView*)tableView heightOfCellAtIndex:(int)index
{
    UIImage* image = _imageArray[index];
    return image.size.height*(CELL_WIDTH/image.size.width);
}

- (CYWaterFallTableCell*)waterFallTableView:(CYWaterFallTableView*)tableView cellAtIndex:(int)index
{
    static NSString* cellid = @"excell";
    ExhibitionCell* cell = (ExhibitionCell*)[tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ExhibitionCell alloc] initWithFrame:CGRectMake(5, 0, CELL_WIDTH, 180)];
    }
    cell.cellImageView.image = _imageArray[index];
    return cell;
}

- (void)waterFallTableView:(CYWaterFallTableView *)tableView didSelectedCellAtIndex:(int)index
{
    UIImage* image = _imageArray[index];
    ImageShowViewController* svc = [[ImageShowViewController alloc] initWithShowImage:image];
    [self.navigationController pushViewController:svc animated:YES];
}

@end
