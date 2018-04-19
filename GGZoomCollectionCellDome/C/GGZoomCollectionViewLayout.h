//
//  GGZoomCollectionViewLayout.h
//  GGZoomCollectionCellDome
//
//  Created by LGQ on 2018/4/19.
//  Copyright © 2018年 LGQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGZoomCollectionViewLayout : UICollectionViewFlowLayout

// 相邻的 item 缩小比例，默认为1
@property (nonatomic, assign) CGFloat scale;

// 静止时，中心 item 跟相邻缩小的 item 的实际间距，默认0
@property (nonatomic, assign) CGFloat itemSpacing;

// 静止时，中心cell的 indexPath
@property (nonatomic, strong) NSIndexPath *centerIndexPath;


+ (instancetype)layoutWithItemSize:(CGSize)size
                       itemSpacing:(CGFloat)spacing
                         zoomScale:(CGFloat)scale;

- (instancetype)initWithItemSize:(CGSize)size
                     itemSpacing:(CGFloat)spacing
                       zoomScale:(CGFloat)scale;
@end
