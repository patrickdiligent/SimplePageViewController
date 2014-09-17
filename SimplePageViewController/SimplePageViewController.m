//
//  SimplePageViewController.m
//  SimplePageViewController
//
//  Created by patrick on 10/09/2014.
//  Copyright (c) 2014 Patrick. All rights reserved.
//

#import "SimplePageViewController.h"

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

@implementation SimplePageViewController

- (void)_init
{
	self.leftViewController = nil;
	self.rightViewController = nil;
	self.middleViewController = nil;
	
	self.leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftSwipe:)];
	self.leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
	
	self.rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightSwipe:)];
	self.rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
	
	self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
	
	[self.panGesture requireGestureRecognizerToFail:self.leftSwipeGesture];
	[self.panGesture requireGestureRecognizerToFail:self.rightSwipeGesture];
	self.ignoreGestures = NO;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		[self _init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
        // Custom initialization
		[self _init];
	}
	return self;
}

- (id)init
{
	self = [super init];
	if (self) {
        // Custom initialization
		[self _init];
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self addGestureRecognizers];
	[self preloadViewControllers];
}

- (void)preloadViewControllers
{
	[self installMiddleViewController];
	if (self.middleViewController) {
		[self feedRightViewController];
	}
}

- (BOOL)shouldAutorotate
{
	if (self.middleViewController) {
		return [self.middleViewController shouldAutorotate];
	}
	return YES;
}

- (void)adjustViewControllerFrames
{	
	if (self.middleViewController) {
		self.middleViewController.view.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
	}
	if (self.rightViewController) {
		self.rightViewController.view.transform = CGAffineTransformIdentity;
		self.rightViewController.view.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
		self.rightViewController.view.transform = CGAffineTransformMakeTranslation(self.view.bounds.size.width, 0.0);
	}
	if (self.leftViewController) {
		self.leftViewController.view.transform = CGAffineTransformIdentity;
		self.leftViewController.view.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
		self.leftViewController.view.transform = CGAffineTransformMakeTranslation(-self.view.bounds.size.width, 0.0);
	}
}

- (void)viewDidAppear:(BOOL)animated
{
	[self adjustViewControllerFrames];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if (self.leftViewController) {
		self.leftViewController.view.hidden = YES;
	}
	if (self.rightViewController) {
		self.rightViewController.view.hidden = YES;
	}

}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[self adjustViewControllerFrames];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	if (self.leftViewController) {
		self.leftViewController.view.hidden = NO;
	}
	if (self.rightViewController) {
		self.rightViewController.view.hidden = NO;
	}
	[self.view setNeedsDisplay];
}

- (NSUInteger)supportedInterfaceOrientations
{
	NSUInteger viewControllerMask = 0;
	if (self.middleViewController) {
		viewControllerMask = [self.middleViewController supportedInterfaceOrientations];
	}
	if (self.delegate && [self.delegate respondsToSelector:@selector(pageViewControllerSupportedInterfaceOrientations:)]) {
		viewControllerMask &= [self.delegate pageViewControllerSupportedInterfaceOrientations:self];
	}
	else {
		viewControllerMask &= [super supportedInterfaceOrientations];
	}
	
	return viewControllerMask ? viewControllerMask : UIInterfaceOrientationMaskAll;
}

- (void)addGestureRecognizers
{
	[self.view addGestureRecognizer:self.leftSwipeGesture];
	[self.view addGestureRecognizer:self.rightSwipeGesture];
	[self.view addGestureRecognizer:self.panGesture];
}

- (void)removeGestureRecognizers
{
	[self.view removeGestureRecognizer:self.leftSwipeGesture];
	[self.view removeGestureRecognizer:self.rightSwipeGesture];
	[self.view removeGestureRecognizer:self.panGesture];
}

- (void)installMiddleViewController
{
	if (self.dataSource && [self.dataSource respondsToSelector:@selector(pageViewController:viewControllerAfterViewController:)]) {
		UIViewController *viewController = [self.dataSource pageViewController:self viewControllerAfterViewController:nil];
		if (viewController) {
			[self addChildViewController:viewController];
			[self.view addSubview:viewController.view];
			viewController.view.transform = CGAffineTransformIdentity;
			viewController.view.frame = self.view.bounds;
			[viewController didMoveToParentViewController:self];
			self.middleViewController = viewController;
		}
	}
}

- (void)setDataSource:(id<SimplePageViewControllerDataSource>)dataSource
{
	if (_dataSource != dataSource) {
		self.leftViewController = nil;
		self.middleViewController = nil;
		self.rightViewController = nil;
		_dataSource = nil;
	}
	if (dataSource) {
		_dataSource = dataSource;
		if (self.isViewLoaded) {
			[self preloadViewControllers];
		}
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)feedRightViewController
{
	UIViewController *viewController = self.middleViewController;
	UIViewController *rightViewController = self.rightViewController;
	if (!self.rightViewController && self.dataSource) {
		if ([self.dataSource respondsToSelector:@selector(pageViewController:viewControllerAfterViewController:)]) {
			rightViewController = [self.dataSource pageViewController:self viewControllerAfterViewController:viewController];
			if (rightViewController) {
				[self installRightViewController:rightViewController];
			}
		}
	}
	return rightViewController;
}

- (UIViewController *)feedLeftViewController
{
	UIViewController *viewController = self.middleViewController;
	UIViewController *leftViewController = self.leftViewController;
	if (!self.leftViewController && self.dataSource) {
		if ([self.dataSource respondsToSelector:@selector(pageViewController:viewControllerBeforeViewController:)]) {
			leftViewController = [self.dataSource pageViewController:self viewControllerBeforeViewController:viewController];
			if (leftViewController) {
				[self installLeftViewController:leftViewController];
			}
		}
	}
	return leftViewController;
}

- (BOOL)prepareRightViewController
{
	UIViewController *rightViewController = nil;
	rightViewController = [self feedRightViewController];
	return rightViewController != nil;
}

- (BOOL)prepareLeftViewController
{
	UIViewController *leftViewController = nil;
	leftViewController = [self feedLeftViewController];
	return leftViewController != nil;
}

- (void)installRightViewController:(UIViewController *)viewController
{
	self.rightViewController = viewController;
	viewController.view.frame = self.view.bounds;
	viewController.view.transform = CGAffineTransformIdentity;
	[self.view addSubview:viewController.view];
	viewController.view.transform = CGAffineTransformMakeTranslation(self.view.bounds.size.width, 0.0);
}

- (void)installLeftViewController:(UIViewController *)viewController
{
	self.leftViewController = viewController;
	viewController.view.frame = self.view.bounds;
	viewController.view.transform = CGAffineTransformIdentity;
	[self.view addSubview:viewController.view];
	[self.view addSubview:viewController.view];
	viewController.view.transform = CGAffineTransformMakeTranslation(-self.view.bounds.size.width, 0.0);
}

- (void)handleLeftSwipe:(UIGestureRecognizer *)gestureRecognizer
{
	if (self.ignoreGestures || !self.middleViewController) {
		return;
	}
	self.ignoreGestures = YES;
	
	if ([self prepareRightViewController]) {
		[self swipeToLeft:0.0];
	}
	else {
		[self reboundToLeft];
		self.ignoreGestures = NO;
	}
}

- (void)handleRightSwipe:(UIGestureRecognizer *)gestureRecognizer
{
	if (self.ignoreGestures || !self.middleViewController) {
		return;
	}
	self.ignoreGestures = YES;
	
	if ([self prepareLeftViewController]) {
		[self swipeToRight:0.0];
	}
	else {
		[self reboundToRight];
		self.ignoreGestures = NO;
	}
}

- (void)rebound:(CGFloat)tx
{
	UIViewController *activeController = self.middleViewController;
	[UIView animateWithDuration:0.2 animations:^{
		activeController.view.transform = CGAffineTransformTranslate(activeController.view.transform, -tx, 0.0);
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:0.2 animations:^{
			activeController.view.transform = CGAffineTransformTranslate(activeController.view.transform, +tx, 0.0);
		}];
	}];
	
}

- (void)reboundToLeft
{
	CGFloat tx = self.view.bounds.size.width / 4;
	[self rebound:tx];
}

- (void)reboundToRight
{
	CGFloat tx = self.view.bounds.size.width / 4;
	[self rebound:-tx];
}

- (void)handlePanGesture:(UIGestureRecognizer *)gestureRecognizer
{
	if (self.ignoreGestures) {
		return;
	}
	
	UIViewController *currentController = self.middleViewController;
	CGFloat delta = currentController.view.frame.origin.x;
		
	// At most only one should be fed
	BOOL leftReady = [self prepareLeftViewController];
	BOOL rightReady = [self prepareRightViewController];
	
	if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
		self.panning = NO;
		
		if ( (delta > 0 && !leftReady) || (delta < 0 && !rightReady)
			|| ABS(delta) < self.view.bounds.size.width/2) {
			[self bounceBack];
		}
		else {
			delta > 0 ? [self swipeToRight:ABS(delta)] : [self swipeToLeft:ABS(delta)];
			self.ignoreGestures = YES;
		}
		return;
	}
	
	CGPoint touchLocation = [gestureRecognizer locationInView:self.view];
	CGFloat nextDelta = delta + touchLocation.x - self.previousLocation.x;
	CGFloat boundary = self.view.bounds.size.width/4;
	
	if (!self.panning) {
		self.panning = YES;
	}
	else {
		
		if (self.panning && ABS(nextDelta) > boundary) {
			if ((!leftReady && nextDelta > 0) || (!rightReady && nextDelta < 0)) {
				return;
			}
		}

		[self panWithtranslation:self.previousLocation.x-touchLocation.x];
	}
	
	self.previousLocation = touchLocation;

}

- (void)swipeToLeft:(CGFloat)delta;
{
	UIViewController *activeController = self.middleViewController;
	UIViewController *rightController = self.rightViewController;
	UIViewController *leftController = self.leftViewController;
	self.leftViewController = self.middleViewController;
	self.middleViewController = self.rightViewController;
	self.rightViewController = nil;
	
	[activeController willMoveToParentViewController:nil];
	if (leftController) {
		[leftController.view removeFromSuperview];
	}
	[activeController removeFromParentViewController];
	
	[self addChildViewController:rightController];
	[self.view addSubview:rightController.view];
	[rightController didMoveToParentViewController:self];
	
	CGFloat tx = self.view.bounds.size.width - delta;

	__weak SimplePageViewController *wself = self;
		
	[UIView animateWithDuration:0.2 animations:^{
		activeController.view.transform = CGAffineTransformTranslate(activeController.view.transform, -tx, 0.0);
		rightController.view.transform = CGAffineTransformTranslate(rightController.view.transform, -tx, 0.0);
	} completion:^(BOOL finished) {
		[wself feedRightViewController];
		rightController.view.transform = CGAffineTransformIdentity;
		if (leftController) {
			leftController.view.transform = CGAffineTransformIdentity;
		}
		activeController.view.transform = CGAffineTransformMakeTranslation(-self.view.bounds.size.width, 0.0);
		wself.ignoreGestures = NO;
	}];
}

- (void)swipeToRight:(CGFloat)delta
{
	UIViewController *activeController = self.middleViewController;
	UIViewController *rightController = self.rightViewController;
	UIViewController *leftController = self.leftViewController;
	self.rightViewController = self.middleViewController;
	self.middleViewController = self.leftViewController;
	self.leftViewController = nil;
	
	[activeController willMoveToParentViewController:nil];
	if (rightController) {
		[rightController.view removeFromSuperview];
	}
	[activeController removeFromParentViewController];
	
	[self addChildViewController:leftController];
	[self.view addSubview:leftController.view];
	[leftController didMoveToParentViewController:self];
	
	CGFloat tx = self.view.bounds.size.width - delta;
	
	__weak SimplePageViewController *wself = self;

	[UIView animateWithDuration:0.2 animations:^{
		activeController.view.transform = CGAffineTransformTranslate(activeController.view.transform, tx, 0.0);
		leftController.view.transform = CGAffineTransformTranslate(leftController.view.transform, tx, 0.0);
	} completion:^(BOOL finished) {
		[wself feedLeftViewController];
		leftController.view.transform = CGAffineTransformIdentity;
		if (rightController) {
			rightController.view.transform = CGAffineTransformIdentity;
		}
		activeController.view.transform = CGAffineTransformMakeTranslation(self.view.bounds.size.width, 0.0);
		wself.ignoreGestures = NO;
	}];

}

- (void) panWithtranslation:(CGFloat)tx
{
	if (self.ignoreGestures) {
		return;
	}
	
	// During panning translate **ALL** three controllers for sake of simplicity
	// Compute remaining distance to fully swipe the next view
	UIViewController *activeController = self.middleViewController;
	UIViewController *leftController = self.leftViewController;
	UIViewController *rightController = self.rightViewController;

	activeController.view.transform = CGAffineTransformTranslate(activeController.view.transform, -tx, 0.0);
	if (leftController) {
		leftController.view.transform = CGAffineTransformTranslate(leftController.view.transform, -tx, 0.0);;
	}
	if (rightController) {
		rightController.view.transform = CGAffineTransformTranslate(rightController.view.transform, -tx, 0.0);
	}
}

- (void)bounceBack
{
	UIViewController *activeController = self.middleViewController;
	UIViewController *rightController = self.rightViewController;
	UIViewController *leftController = self.leftViewController;

	[UIView animateWithDuration:0.2 animations:^{
		activeController.view.transform = CGAffineTransformIdentity;
		if (leftController) {
			leftController.view.transform = CGAffineTransformMakeTranslation(-self.view.bounds.size.width, 0.0);
		}
		if (rightController) {
			rightController.view.transform = CGAffineTransformMakeTranslation(self.view.bounds.size.width, 0.0);
		}
	}];
}

@end
