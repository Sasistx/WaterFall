//
//  CYViewController.m
//  CollectionTest
//
//  Created by cyou-Mac-003 on 13-7-11.
//  Copyright (c) 2013年 cyou-Mac-003. All rights reserved.
//

#import "CYViewController.h"

#define CELL_WIDTH 129
#define CELL_COUNT 30
#define CELL_IDENTIFIER @"WaterfallCell"

@interface CYViewController () {

    NSMutableArray* _imageArray;
}

@end

@implementation CYViewController

#pragma mark - Life Cycle
- (void)dealloc
{
    [_collectionView removeFromSuperview];
    _collectionView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.cellWidth = CELL_WIDTH; 
    _imageArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSInteger i = 0; i < 15; i++) {
        UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", i]];
        [_imageArray addObject:image];
    }
    
    CYCollectionViewLayout *layout = [[CYCollectionViewLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(9, 9, 9, 9);
    layout.delegate = (id)self;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _collectionView.dataSource = (id)self;
    _collectionView.delegate = (id)self;
    _collectionView.backgroundColor = [UIColor blackColor];
    [_collectionView registerClass:[CYCollectionCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFIER];
    [self.view addSubview:self.collectionView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateLayout];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateLayout
{
//    CYCollectionViewLayout *layout =
//    (CYCollectionViewLayout *)self.collectionView.collectionViewLayout;
//    layout.columnCount = self.collectionView.bounds.size.width / self.cellWidth;
//    layout.itemWidth = self.cellWidth;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_imageArray count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CYCollectionCell *cell =
    (CYCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER
                                                                                forIndexPath:indexPath];
    UIImage* image = _imageArray[indexPath.item];
    [cell.cellImageView setImage:image];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage* image = _imageArray[indexPath.item];
    ImageShowViewController* svc = [[ImageShowViewController alloc] initWithShowImage:image];
    [self.navigationController pushViewController:svc animated:YES];
}

#pragma mark - UICollectionViewWaterfallLayoutDelegate
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(CYCollectionViewLayout *)collectionViewLayout
 heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_imageArray count] == 0) {
        return 0;
    }
    
    UIImage* image = _imageArray[indexPath.item];
    CGFloat imageWidth = image.size.width;
    NSInteger imageHeight = (CELL_WIDTH / imageWidth) * image.size.height;
    return imageHeight;
}

@end
