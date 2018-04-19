//
//  GGCollectionViewHelper.m
//  GGZoomCollectionCellDome
//
//  Created by LGQ on 2018/4/19.
//  Copyright © 2018年 LGQ. All rights reserved.
//

#import "GGCollectionViewHelper.h"
#import "GGZoomCollectionViewLayout.h"


static NSString * const GGCellReuseIdentifier = @"ggCellReuseIdentifier";

@interface GGCollectionViewHelper ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end



@implementation GGCollectionViewHelper

+ (instancetype)instance {
    return [[self alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    GGZoomCollectionViewLayout *layout = [[GGZoomCollectionViewLayout alloc] initWithItemSize:CGSizeMake(1, 1) itemSpacing:10 zoomScale:0.8];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectNull collectionViewLayout:layout];
    self.collectionView.delegate   = self;
    self.collectionView.dataSource = self;
    self.collectionView.alwaysBounceHorizontal = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor  = [UIColor whiteColor];
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:GGCellReuseIdentifier];
}

// collection frame 改变之后，需要对 layout 重新布局，以适应屏幕旋转等 UI 变化
- (void)setCollectionViewFrame:(CGRect)frame {
    self.collectionView.frame = frame;
    
    GGZoomCollectionViewLayout *layout = (GGZoomCollectionViewLayout *)self.collectionView.collectionViewLayout;
    layout.itemSize     = CGSizeMake(CGRectGetWidth(frame) * 0.6, CGRectGetHeight(frame) * 0.5);
    layout.sectionInset = UIEdgeInsetsMake(0, CGRectGetWidth(frame) * 0.2, 0, CGRectGetWidth(frame) * 0.2);
    
    [self.collectionView setCollectionViewLayout:layout animated:YES];
    
    // 此处不要动画，否则会闪屏
    [self.collectionView scrollToItemAtIndexPath:layout.centerIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GGCellReuseIdentifier forIndexPath:indexPath];
    NSInteger index = indexPath.row % 3;
    if (index == 0) {
        cell.backgroundColor = [UIColor redColor];
    } else if (index == 1) {
        cell.backgroundColor = [UIColor blueColor];
    } else if (index == 2) {
        cell.backgroundColor = [UIColor yellowColor];
    }
    return cell;
}

@end
