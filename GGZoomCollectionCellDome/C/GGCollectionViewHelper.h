//
//  GGCollectionViewHelper.h
//  GGZoomCollectionCellDome
//
//  Created by LGQ on 2018/4/19.
//  Copyright © 2018年 LGQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GGCollectionViewHelper : NSObject

+ (instancetype)instance;

- (UICollectionView *)collectionView;

- (void)setCollectionViewFrame:(CGRect)frame;

@end
