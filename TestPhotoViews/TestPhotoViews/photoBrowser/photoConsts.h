//
//  Consts.h
//  Xinhu
//
//  Created by Nero on 14-8-28.
//  Copyright (c) 2014年 www.baitu.com 杭州百图科技有限公司. All rights reserved.
//
/*
 photoBrowser 用于在ipad上展示滚动预览大图的组件
 这里把使用的关闭按钮和选择框图片资源封装到bundle，之后项目需要这样的效果展示直接引入photoBrowser即可
 coder: 2014-12-01 lujie
 */

// 错误预定义
#define ERROR_INDEX_OUT_OF_RANGE -1

// 屏幕宽度和高度
#define PhotoSCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define PhotoSCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

// bundle资源
#define PhotoSrcName(file) [@"photoBrowser.bundle" stringByAppendingPathComponent:file]

// 文件后缀
#define JPG @"jpg"

// 大图和预览高度和宽度预定义
#define kThumbnailBarWidth self.frame.size.width
#define kThumbnailBarHeight 120.0f
#define kThumbnailImageWidth 168.0f
#define kThumbnailImageHeight 92.0f
#define kThumbnailImageGap 16.0f
#define kThumbSelectedBorderWidth 170.0f
#define kThumbSelectedBorderHeight 95.0f
#define kExitButtonToLeft self.frame.size.width - kExitButtonWidth - 10.0f
#define kExitButtonToTop 10.0f
#define kExitButtonWidth 40.0f
#define kExitButtonHeight 40.0f
#define kFlagPageOffsetX (self.frame.size.width / 3.0)
