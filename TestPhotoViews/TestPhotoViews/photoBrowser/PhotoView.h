//
//  PhotoView.h
//  PhotoBrowserDemo
//
//  Created by Nero on 14-8-18.
//  Copyright (c) 2014年 www.baitu.com 杭州百图科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoView : UIView
{
    @private
    UIImageView *_imageView;
    
}

- (id)initWithFrame:(CGRect)frame imageView:(UIImageView *)imageView;
- (void)setImage:(UIImage *)image;
- (UIImage *)image;


@end
