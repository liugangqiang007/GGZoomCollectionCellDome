//
//  GGZoomCollectionViewLayout.m
//  GGZoomCollectionCellDome
//
//  Created by LGQ on 2018/4/19.
//  Copyright © 2018年 LGQ. All rights reserved.
//

#import "GGZoomCollectionViewLayout.h"

@interface GGZoomCollectionViewLayout ()
// 放缩系数，根据 scale 计算得出
@property (nonatomic, assign) CGFloat factor;

@end

@implementation GGZoomCollectionViewLayout

#pragma mark - init
+ (instancetype)layoutWithItemSize:(CGSize)size itemSpacing:(CGFloat)spacing zoomScale:(CGFloat)scale {
    return [[self alloc] initWithItemSize:size itemSpacing:spacing zoomScale:scale];
}

- (instancetype)initWithItemSize:(CGSize)size itemSpacing:(CGFloat)spacing zoomScale:(CGFloat)scale {
    self = [super init];
    if (self) {
        _itemSpacing = spacing;
        _scale = scale == 0 ? 1.0 : scale;
        self.itemSize = size;
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}

- (instancetype)init {
    return [self initWithItemSize:CGSizeZero itemSpacing:0 zoomScale:1];
}

#pragma mark - set
- (void)setItemSize:(CGSize)itemSize {
    [super setItemSize:itemSize];
    [self updateFactor];
}

- (void)setScale:(CGFloat)scale {
    _scale = scale;
    [self updateFactor];
}

- (void)setItemSpacing:(CGFloat)itemSpacing {
    _itemSpacing = itemSpacing;
    [self updateFactor];
}

// 根据 中心 cell 与相邻 cell 的放缩比例 scale，以及显示间距，使用公式 1/(1 + 距离 * factor)，计算出其中的放缩因子factor，和 minimumLineSpacing。
- (void)updateFactor {
    
    if (_scale == 0) {
        _scale = 1.0;
    }
    
    self.minimumLineSpacing = self.itemSpacing - 0.5 * self.itemSize.width * (1 - self.scale);
    self.factor = (1 / self.scale - 1) / (self.minimumLineSpacing + self.itemSize.width);
}


#pragma mark - layoutAttributes

// 这个方法返回所有的布局所需对象,瀑布流也可以重写这个方法实现.
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    // 1.获取cell对应的attributes对象
    NSArray *arrayAttrs = [[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];
    
    // 2.计算整体的中心点的x值
    CGFloat centerX = self.collectionView.contentOffset.x + CGRectGetWidth(self.collectionView.bounds) * 0.5;
    
    // 3.修改一下attributes对象
    for (UICollectionViewLayoutAttributes *attr in arrayAttrs) {
        // 3.1 计算每个cell的中心点距离
        CGFloat distance = ABS(attr.center.x - centerX);
        // 3.2 距离越大，缩放比越小，距离越小，缩放比越大
        CGFloat scale = 1 / (1 + distance * self.factor);
        attr.transform = CGAffineTransformMakeScale(scale, scale);
        //        NSLog(@"%@------%@", @(attr.indexPath.row), NSStringFromCGAffineTransform(attr.transform));
    }
    
    return arrayAttrs;
}

// 当bounds发生改变的时候需要重新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return true;
}

/// 滑动停止
/// @param proposedContentOffset 当手指滚动完毕后，自然情况下根据“惯性”，会停留的位置
/// @param velocity              速率,周率
/// @return 人为要让它停留的位置
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    // 获取当前偏移量
    CGPoint targetProposed = [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
    
    // 获取当前范围内显示的cell
    CGRect rect = CGRectMake(targetProposed.x, 0, CGRectGetWidth(self.collectionView.bounds), MAXFLOAT);
    NSArray<UICollectionViewLayoutAttributes *> *attributeArray = [super layoutAttributesForElementsInRect:rect];
    
    // 在预定停留位置很短儿，速度很快的情况下，会出现cell快速弹回的不佳体验。所以在 targetProposed 上添加一个以 velocity 为系数的值进行优化。
    targetProposed.x += (velocity.x * attributeArray.firstObject.size.width);
    
    // 寻找距离中心点最近的图片
    CGFloat minDis = MAXFLOAT;
    NSIndexPath *centerIndexPath = nil;
    for (UICollectionViewLayoutAttributes *attr in attributeArray) {
        
        CGFloat disWithCenter = (attr.center.x - targetProposed.x) - CGRectGetWidth(self.collectionView.bounds) * 0.5;
        
        if(fabs(disWithCenter) < fabs(minDis)){
            minDis = disWithCenter;
            centerIndexPath = attr.indexPath;
        }
    }
    
    self.centerIndexPath = centerIndexPath;
    
    //停止滚动后可能没有图片在中间，所以我们要计算距离中间最近的图片，然后偏移过去
    targetProposed.x += minDis;
    if (targetProposed.x < 0) {
        targetProposed.x = 0;
    }
    
    return targetProposed;
}

@end
