//
//  ShowImageScrollView.m
//  CollectionTest
//
//  Created by cyou-Mac-003 on 13-7-12.
//  Copyright (c) 2013年 cyou-Mac-003. All rights reserved.
//

#import "ShowImageScrollView.h"

@interface ShowImageScrollView () {

    UIImageView* _imageView;
}

@end

@implementation ShowImageScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withShowImage:(UIImage*)image
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        [self initialShowImage:image];
    }
    return self;
}

- (void)initialShowImage:(UIImage*)image
{
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width , image.size.height)];
    [_imageView setUserInteractionEnabled:YES];
    [_imageView setImage:image];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    [tapGesture setNumberOfTapsRequired:2];
    [_imageView addGestureRecognizer:tapGesture];
    [self addSubview:_imageView];
    
    CGFloat minimumScale = self.frame.size.width / _imageView.frame.size.width;
    [self setMinimumZoomScale:minimumScale];
    [self setZoomScale:minimumScale];
}

- (void)imageTapped:(UIGestureRecognizer*)gesture
{
    CGFloat newScale = self.zoomScale * 1.5;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gesture locationInView:gesture.view]];
    [self zoomToRect:zoomRect animated:YES];
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = self.frame.size.height / scale;
    zoomRect.size.width  = self.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    [scrollView setZoomScale:scale animated:NO];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
