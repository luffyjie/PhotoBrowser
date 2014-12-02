//
//  PhotoView.m
//  PhotoBrowserDemo
//
//  Created by Nero on 14-8-18.
//  Copyright (c) 2014年 www.baitu.com 杭州百图科技有限公司. All rights reserved.
//

#import "PhotoView.h"

@implementation PhotoView

- (id)initWithFrame:(CGRect)frame imageView:(UIImageView *)imageView
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = imageView;
        [self addSubview:_imageView];
    }
    return self;
}

- (void)setImage:(UIImage *)image
{
    _imageView.image = image;
}

- (UIImage *)image
{
    return _imageView.image;
}

@end
