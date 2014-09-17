//
//  SimplePageViewController+Test.h
//  SimplePageViewController
//
//  Created by patrick on 16/09/2014.
//  Copyright (c) 2014 Patrick. All rights reserved.
//


@interface SimplePageViewController ()

@property (strong, nonatomic) UIViewController	*leftViewController;
@property (strong, nonatomic) UIViewController	*rightViewController;
@property (strong, nonatomic) UIViewController	*middleViewController;

@property (nonatomic) BOOL panning;

@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGesture;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@property (nonatomic) CGPoint previousLocation;
@property (nonatomic) BOOL ignoreGestures;

- (void)handleLeftSwipe:(UIGestureRecognizer *)gestureRecognizer;
- (void)handleRightSwipe:(UIGestureRecognizer *)gestureRecognizer;
- (void)handlePanGesture:(UIGestureRecognizer *)gestureRecognizer;

- (BOOL)prepareRightViewController;
- (BOOL)prepareLeftViewController;

- (void)installMiddleViewController;
- (void)installLeftViewController:(UIViewController *)viewController;
- (void)installRightViewController:(UIViewController *)viewController;

- (UIViewController *)feedRightViewController;
- (UIViewController *)feedLeftViewController;

- (void)reboundToLeft;
- (void)reboundToRight;

- (void)swipeToRight:(CGFloat)delta;
- (void)swipeToLeft:(CGFloat)delta;

@end