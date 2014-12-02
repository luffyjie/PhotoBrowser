//
//  PhotoBrowserView.m
//  PhotoBrowserDemo
//
//  Created by Nero on 14-8-18.
//  Copyright (c) 2014年 www.baitu.com 杭州百图科技有限公司. All rights reserved.
//

#import "PhotoBrowserView.h"
#import "PhotoView.h"
#import "photoConsts.h"

@implementation PhotoBrowserView

- (id)initWithFrame:(CGRect)frame photoPathArray:(NSArray *)photoPathArray thumbnailPathArray:(NSArray *)thumbnailPathArray photoSize:(CGSize)photoSize
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, PhotoSCREEN_WIDTH,PhotoSCREEN_HEIGHT);
        self.backgroundColor = [UIColor clearColor];
        _photoPathArray = photoPathArray;
        _photoThumbnailPathArray = thumbnailPathArray;
        _photoSize = photoSize;
        if (_photoSize.width == 0.0 || _photoSize.height == 0.0) {
            _photoSize.width = frame.size.width / 8.0 * 7.0;
            _photoSize.height = frame.size.height / 4.0 * 3.0;
        }
        
        if (_photoPathArray.count == 0) {
            NSLog(@"null photo array!");
            return  nil;
        } else if (_photoPathArray.count != _photoThumbnailPathArray.count) {
            NSLog(@"thumbnail's count not equal to photo array count!");
            return nil;
        } else {
            [self initPhotoView];
            [self initThumbnailBar];
            [self initReusableView];
            [self initSelectedThumbBorder];
        }
        
        UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        exitButton.frame = CGRectMake(kExitButtonToLeft, kExitButtonToTop, kExitButtonWidth, kExitButtonHeight);
        exitButton.backgroundColor = [UIColor clearColor];
        [exitButton setImage:[UIImage imageNamed: PhotoSrcName(@"btn_exit")] forState:UIControlStateNormal];
//        exitButton.layer.cornerRadius = kExitButtonWidth / 2.0;
        
        exitButton.layer.masksToBounds = YES;
        [exitButton addTarget:self action:@selector(exitPhotoBrowserView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:exitButton];
        
    }
    return self;
}

// 图片显示视图
- (void)initPhotoView
{
    _photoView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _photoView.contentSize = CGSizeMake(_photoView.frame.size.width * _photoPathArray.count, _photoView.frame.size.height);
    _photoView.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.7];
    _photoView.showsVerticalScrollIndicator = NO;
    _photoView.showsHorizontalScrollIndicator = NO;
    _photoView.alwaysBounceHorizontal = NO;
    _photoView.alwaysBounceVertical = NO;
    _photoView.bounces = YES;
    _photoView.pagingEnabled = YES;
    _photoView.delegate = self;
    
    [self addSubview:_photoView];
}

// 缩略图导航栏
- (void)initThumbnailBar
{
    _thumbnailBarView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - kThumbnailBarHeight, kThumbnailBarWidth, kThumbnailBarHeight)];
    _thumbnailBarView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.8];
    _thumbnailBarView.contentSize = CGSizeMake(kThumbnailImageWidth * _photoThumbnailPathArray.count + kThumbnailImageGap * (_photoThumbnailPathArray.count + 1), kThumbnailBarHeight);
    _thumbnailBarView.showsHorizontalScrollIndicator = NO;
    _thumbnailBarView.showsVerticalScrollIndicator = NO;
    _thumbnailBarView.alwaysBounceHorizontal = NO;
    _thumbnailBarView.alwaysBounceVertical = NO;
    
    for (int i = 0; i < _photoThumbnailPathArray.count; i++) {
        NSString *thumbnailImagePath = [_photoThumbnailPathArray objectAtIndex:i];
        if (thumbnailImagePath) {
            UIImageView *thumbnailImage = [[UIImageView alloc] initWithFrame:CGRectMake(kThumbnailImageGap + i * (kThumbnailImageGap + kThumbnailImageWidth), kThumbnailBarHeight / 2.0 - kThumbnailImageHeight / 2.0, kThumbnailImageWidth, kThumbnailImageHeight)];
            thumbnailImage.tag = i;
            thumbnailImage.image = [UIImage imageWithContentsOfFile:thumbnailImagePath];
            thumbnailImage.backgroundColor = [UIColor clearColor];
            thumbnailImage.contentMode = UIViewContentModeScaleToFill;
            thumbnailImage.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *thumbnailTapGuesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thumbnailImageTapped:)];
            thumbnailTapGuesture.numberOfTapsRequired = 1;
            thumbnailTapGuesture.numberOfTouchesRequired = 1;
            [thumbnailImage addGestureRecognizer:thumbnailTapGuesture];
            
            [_thumbnailBarView addSubview:thumbnailImage];
        }
    }
    
    [self addSubview:_thumbnailBarView];
}

- (void)initReusableView
{
    
    UIImageView *leftPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2.0 - _photoSize.width / 2.0, (self.frame.size.height - kThumbnailBarHeight) / 2.0 - _photoSize.height / 2.0, _photoSize.width, _photoSize.height)];
    leftPhoto.backgroundColor = [UIColor clearColor];
    leftPhoto.contentMode = UIViewContentModeScaleToFill;
    _leftView = [[PhotoView alloc] initWithFrame:CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height) imageView:leftPhoto];
    _leftView.backgroundColor = [UIColor clearColor];
    
    UIImageView *middlePhoto = [[UIImageView alloc] initWithFrame:leftPhoto.frame];
    middlePhoto.backgroundColor = [UIColor clearColor];
    middlePhoto.contentMode = UIViewContentModeScaleToFill;
    _middleView = [[PhotoView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) imageView:middlePhoto];
    _middleView.backgroundColor = [UIColor clearColor];
    if (_photoPathArray.count > 0) {
        [_middleView setImage:[UIImage imageWithContentsOfFile:[_photoPathArray objectAtIndex:0]]];
    } else {
        [_middleView setImage:nil];
    }
    UIImageView *rightPhoto = [[UIImageView alloc] initWithFrame:middlePhoto.frame];
    rightPhoto.backgroundColor = [UIColor clearColor];
    rightPhoto.contentMode = UIViewContentModeScaleToFill;
    _rightView = [[PhotoView alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height) imageView:rightPhoto];
    _rightView.backgroundColor = [UIColor clearColor];
    if (_photoPathArray.count > 1) {
        [_rightView setImage:[UIImage imageWithContentsOfFile:[_photoPathArray objectAtIndex:1]]];
    } else {
        [_rightView setImage:nil];
    }
    
    [_photoView addSubview:_leftView];
    [_photoView addSubview:_middleView];
    [_photoView addSubview:_rightView];
    
    _currentIndex = 0;
}

- (void)initSelectedThumbBorder
{
    _selectedThumbBorder = [[UIImageView alloc] initWithFrame:CGRectMake(- 10 * kThumbSelectedBorderWidth, kThumbnailBarHeight / 2.0 - kThumbSelectedBorderHeight / 2.0, kThumbSelectedBorderWidth, kThumbSelectedBorderHeight)];
    _selectedThumbBorder.backgroundColor = [UIColor clearColor];
    _selectedThumbBorder.image = [UIImage imageNamed:PhotoSrcName(@"icon_thumb_selected")];
    [_thumbnailBarView addSubview:_selectedThumbBorder];
}

#pragma mark - UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint contentOffset = scrollView.contentOffset;
    int newIndex = (int) (contentOffset.x / self.frame.size.width);
    // 发生翻页了
    if (newIndex != _currentIndex) {
        if (newIndex > ERROR_INDEX_OUT_OF_RANGE && newIndex < _photoPathArray.count) {
            if (_currentIndex != newIndex) {
                if (_currentIndex > newIndex) { // 向前翻
                    [_rightView setImage:_middleView.image];
                    _rightView.frame = _middleView.frame;
                    [_middleView setImage:_leftView.image];
                    _middleView.frame = _leftView.frame;
                    _leftView.frame = CGRectMake(_leftView.frame.size.width * (newIndex - 1), _leftView.frame.origin.y, _leftView.frame.size.width, _leftView.frame.size.height);
                    if (newIndex - 1 > ERROR_INDEX_OUT_OF_RANGE && newIndex - 1 < _photoPathArray.count) {
                        _leftView.image = [UIImage imageWithContentsOfFile:[_photoPathArray objectAtIndex:(newIndex - 1)]];
                    } else {
                        _leftView.image = nil;
                    }
                } else { // 向后翻
                    [_leftView setImage:_middleView.image];
                    _leftView.frame = _middleView.frame;
                    [_middleView setImage:_rightView.image];
                    _middleView.frame = _rightView.frame;
                    _rightView.frame = CGRectMake(_rightView.frame.size.width * (newIndex + 1), _rightView.frame.origin.y, _rightView.frame.size.width, _rightView.frame.size.height);
                    if (newIndex + 1 < _photoPathArray.count && newIndex + 1 > ERROR_INDEX_OUT_OF_RANGE) {
                        _rightView.image = [UIImage imageWithContentsOfFile:[_photoPathArray objectAtIndex:(newIndex + 1)]];
                    } else {
                        _rightView.image = nil;
                    }
                }
                [self changeSelectedThumbWithIndex:newIndex];
                _currentIndex = newIndex;
                
            }
        }
    }
}

#pragma mark - private method
- (void)thumbnailImageTapped:(UITapGestureRecognizer *)tapGuesture
{
    CGPoint location = [tapGuesture locationInView:_thumbnailBarView];
    
    int index = [self calculateImageIndexWithTouchLocation:location];
//    NSLog(@"%d", index);
    if (index != _currentIndex) {
        // 跳转到指定图片
        _leftView.frame = CGRectMake(_leftView.frame.size.width * (index - 1), _leftView.frame.origin.y, _leftView.frame.size.width, _leftView.frame.size.height);
        _middleView.frame = CGRectMake(_middleView.frame.size.width * index, _middleView.frame.origin.y, _middleView.frame.size.width, _middleView.frame.size.height);
        _rightView.frame = CGRectMake(_rightView.frame.size.width * (index + 1), _rightView.frame.origin.y, _rightView.frame.size.width, _rightView.frame.size.height);
        
        if (index - 1 > ERROR_INDEX_OUT_OF_RANGE && index - 1 < _photoPathArray.count) {
            _leftView.image = [UIImage imageWithContentsOfFile:[_photoPathArray objectAtIndex:(index - 1)]];
        } else {
            _leftView.image = nil;
        }
        
        if (index > ERROR_INDEX_OUT_OF_RANGE && index < _photoPathArray.count) {
            _middleView.image = [UIImage imageWithContentsOfFile:[_photoPathArray objectAtIndex:index]];
        } else {
            _middleView.image = nil;
        }
        
        if (index + 1 < _photoPathArray.count && index + 1 > ERROR_INDEX_OUT_OF_RANGE) {
            _rightView.image = [UIImage imageWithContentsOfFile:[_photoPathArray objectAtIndex:(index + 1)]];
        } else {
            _rightView.image = nil;
        }
        BOOL needAnimation = NO;
        if (abs(_currentIndex - index) == 1) {
            needAnimation = YES;
        }
       
        [self changeSelectedThumbWithIndex:index];
        _currentIndex = index;
        
        if (needAnimation) {
            [_photoView setContentOffset:CGPointMake(index * _photoView.frame.size.width, _photoView.frame.origin.y) animated:NO];
            //        _photoView.contentOffset = CGPointMake(index * _photoView.frame.size.width, _photoView.frame.origin.y);
        } else {
            [_photoView setContentOffset:CGPointMake(index * _photoView.frame.size.width, _photoView.frame.origin.y) animated:NO];
        }
    }
}

- (void)setStartImageWithIndex:(int)index
{
    if (!(index > ERROR_INDEX_OUT_OF_RANGE && index < _photoPathArray.count)) {
        index = 0;
    }
    
    _leftView.frame = CGRectMake(_leftView.frame.size.width * (index - 1), _leftView.frame.origin.y, _leftView.frame.size.width, _leftView.frame.size.height);
    _middleView.frame = CGRectMake(_middleView.frame.size.width * index, _middleView.frame.origin.y, _middleView.frame.size.width, _middleView.frame.size.height);
    _rightView.frame = CGRectMake(_rightView.frame.size.width * (index + 1), _rightView.frame.origin.y, _rightView.frame.size.width, _rightView.frame.size.height);
    
    if (index - 1 > ERROR_INDEX_OUT_OF_RANGE && index - 1 < _photoPathArray.count) {
        _leftView.image = [UIImage imageWithContentsOfFile:[_photoPathArray objectAtIndex:(index - 1)]];
    } else {
        _leftView.image = nil;
    }
    
    if (index > ERROR_INDEX_OUT_OF_RANGE && index < _photoPathArray.count) {
        _middleView.image = [UIImage imageWithContentsOfFile:[_photoPathArray objectAtIndex:index]];
    } else {
        _middleView.image = nil;
    }
    
    if (index + 1 < _photoPathArray.count && index + 1 > ERROR_INDEX_OUT_OF_RANGE) {
        _rightView.image = [UIImage imageWithContentsOfFile:[_photoPathArray objectAtIndex:(index + 1)]];
    } else {
        _rightView.image = nil;
    }
    BOOL needAnimation = NO;
    if (abs(_currentIndex - index) == 1) {
        needAnimation = YES;
    }
    
    [self changeSelectedThumbWithIndex:index];
    _currentIndex = index;
    
    
//    [_photoView setContentOffset:CGPointMake(index * _photoView.frame.size.width, _photoView.frame.origin.y) animated:YES];
    if (needAnimation) {
         [_photoView setContentOffset:CGPointMake(index * _photoView.frame.size.width, _photoView.frame.origin.y) animated:NO];
//        _photoView.contentOffset = CGPointMake(index * _photoView.frame.size.width, _photoView.frame.origin.y);
    } else {
         [_photoView setContentOffset:CGPointMake(index * _photoView.frame.size.width, _photoView.frame.origin.y) animated:NO];
    }
}

// 选中框体位置变更
- (void)changeSelectedThumbWithIndex:(int)index
{
    // 改变缩略图位置
    for (UIView *thumbImage in _thumbnailBarView.subviews) {
        if ((int)thumbImage.tag == index) {
            CGPoint center = thumbImage.center;
            _selectedThumbBorder.center = center;
            // 移动thumb坐标
            int symbol = 1;
            if (index < _currentIndex) {
                symbol = -1;
            }
            CGPoint originOffset = _thumbnailBarView.contentOffset;
            CGFloat distance = abs(index - _currentIndex) * (kThumbnailImageGap + kThumbnailImageWidth);
            CGPoint newOffset = CGPointMake(originOffset.x + symbol * distance, 0);
            if (_thumbnailBarView.contentSize.width - newOffset.x < _thumbnailBarView.bounds.size.width) {
                newOffset.x -= (_thumbnailBarView.bounds.size.width - (_thumbnailBarView.contentSize.width - newOffset.x));
            }
            if (newOffset.x < 0) {
                newOffset.x = 0;
            }
            [_thumbnailBarView setContentOffset:newOffset animated:YES];
//            _thumbnailBarView.contentOffset = newOffset;
            
            break;
        }
    }
}

- (void)clear
{
    _photoView = nil;
    _thumbnailBarView = nil;
    _leftView = nil;
    _middleView = nil;
    _rightView = nil;
}

- (void)exitPhotoBrowserView
{
    if ([self.delegate respondsToSelector:@selector(exitPhotoBrowserView:)]) {
        [self.delegate exitPhotoBrowserView:self];
    }
}

- (int)calculateImageIndexWithTouchLocation:(CGPoint)location
{
    int index = ERROR_INDEX_OUT_OF_RANGE;
    CGFloat coordinateX = location.x;
    
    index = (int)(coordinateX / (kThumbnailImageWidth + kThumbnailImageGap));
    // 点击的是缩略图分隔部分
    if ((coordinateX - index * (kThumbnailImageGap + kThumbnailImageWidth)) < kThumbnailImageGap) {
        index = ERROR_INDEX_OUT_OF_RANGE;
    }
    
    return index;
}


@end
