//
//  PhotoBrowserView.h
//  PhotoBrowserDemo
//
//  Created by Nero on 14-8-18.
//  Copyright (c) 2014年 www.baitu.com 杭州百图科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "photoConsts.h"

@class PhotoView;
@class PhotoBrowserView;

@protocol PhotoBrowserViewDelegate <NSObject>

@required
- (void)exitPhotoBrowserView:(PhotoBrowserView *)photoBrowserView;

@end

@interface PhotoBrowserView : UIView<UIScrollViewDelegate>
{
    PhotoView *_leftView;
    PhotoView *_middleView;
    PhotoView *_rightView;
    NSArray *_photoPathArray; // 照片路径数组
    NSArray *_photoThumbnailPathArray; // 照片缩略图路径
    CGSize _photoSize; // 预览照片的大小
    UIScrollView *_photoView;
    UIScrollView *_thumbnailBarView;
    int _currentIndex; // 当前显示照片索引
    UIImageView *_selectedThumbBorder;
}

@property (nonatomic,weak) id<PhotoBrowserViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame photoPathArray:(NSArray *)photoPathArray thumbnailPathArray:(NSArray *)thumbnailPathArray photoSize:(CGSize)photoSize;
- (void)setStartImageWithIndex:(int)index;
- (void)clear;

@end
