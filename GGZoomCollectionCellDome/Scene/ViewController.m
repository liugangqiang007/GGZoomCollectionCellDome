//
//  ViewController.m
//  GGZoomCollectionCellDome
//
//  Created by LGQ on 2018/4/19.
//  Copyright © 2018年 LGQ. All rights reserved.
//

#import "ViewController.h"
#import "GGCollectionViewHelper.h"

@interface ViewController ()
@property (nonatomic, strong) GGCollectionViewHelper *collectionViewHelper;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configuration];
    
    [self addUI];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.collectionViewHelper setCollectionViewFrame:self.view.bounds];
}

- (void)configuration {
    self.title = @"ZoomCell";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)addUI {
    self.collectionViewHelper = [GGCollectionViewHelper instance];
    [self.view addSubview:self.collectionViewHelper.collectionView];
}




@end
