//
//  ViewController.m
//  TestPhotoViews
//
//  Created by Nero on 14/12/1.
//  Copyright (c) 2014年 www.baitutech.com 杭州百图科技有限公司. All rights reserved.
//

#import "ViewController.h"
#import "PhotoBrowserView.h"
#import "photoConsts.h"

@interface ViewController ()<PhotoBrowserViewDelegate>

@end

@implementation ViewController

{
    PhotoBrowserView *_photoBrowserView;    // 照片浏览器
    NSArray *_photoNameArray;
    NSArray *_photoThumbArray;
    int _index;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor greenColor];
    
    _photoNameArray = [[NSArray alloc] initWithObjects:@"images/Photoes/公租房",nil];
    _photoThumbArray = [[NSArray alloc] initWithObjects:@"images/PhotoThumbnails/公租房",nil];
    _index = 0;
   [self showPhotoBrowserWithIndex:0];
}

- (void)showPhotoBrowserWithIndex:(int)index
{
        NSArray *photoPathes = [[NSBundle mainBundle] pathsForResourcesOfType:JPG inDirectory:[_photoNameArray objectAtIndex:_index]];
        NSArray *photoThumbs = [[NSBundle mainBundle] pathsForResourcesOfType:JPG inDirectory:[_photoThumbArray objectAtIndex:_index]];
        _photoBrowserView = [[PhotoBrowserView alloc] initWithFrame:CGRectMake(0, 0, PhotoSCREEN_WIDTH, PhotoSCREEN_HEIGHT) photoPathArray:photoPathes thumbnailPathArray:photoThumbs photoSize:CGSizeMake(PhotoSCREEN_WIDTH / 8.0 * 7.0, PhotoSCREEN_HEIGHT / 4.0 * 3.0)];
        [_photoBrowserView setStartImageWithIndex:index];
        _photoBrowserView.delegate = self;
        _photoBrowserView.transform = CGAffineTransformMakeScale(0.001, 0.001);
        [self.view addSubview:_photoBrowserView];
        [UIView animateWithDuration:0.35 animations:^{
            _photoBrowserView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
        }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - photo browser view delegate
- (void)exitPhotoBrowserView:(PhotoBrowserView *)photoBrowserView
{
    [UIView animateWithDuration:0.35 animations:^{
        _photoBrowserView.transform = CGAffineTransformMakeScale(0.001, 0.001);
    } completion:^(BOOL finished) {
        [_photoBrowserView removeFromSuperview];
        [_photoBrowserView clear];
    }];
}

@end
