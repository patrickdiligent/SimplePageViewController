//
//  ModelController.m
//  SimplePageViewController
//
//  Created by patrick on 12/09/2014.
//  Copyright (c) 2014 Patrick. All rights reserved.
//

#import "ModelController.h"
#import "ColorViewController.h"

@interface ModelController()

@property (nonatomic, strong) NSArray* viewIds;
@property (nonatomic) int count;
@property (nonatomic, strong) NSMutableDictionary *controllers;

@property (nonatomic, weak) UIStoryboard *storyBoard;

@property (nonatomic) BOOL pending;

@property (nonatomic) NSUInteger pendingIndex;

- (ColorViewController *)viewControllerAtIndex:(NSUInteger)index;

@end

@implementation ModelController

// Only keep 3 controllers at hand
// Will simulate long time response to check
// asynchroneous use

- (instancetype)init
{
	self = [super init];
	if (self) {
		self.viewIds = @[@"GreenController", @"RedController", @"YellowController"];
		self.controllers = [NSMutableDictionary dictionaryWithCapacity:3];
		self.count = 0;
	}
	return self;
}

- (UIViewController *)pageViewController:(SimplePageViewController *)simplePageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
	NSUInteger curIndex = ((ColorViewController *)viewController).index;

	if (self.pending && curIndex == self.pendingIndex) {
		return nil;
	}
	
	self.storyBoard = simplePageViewController.storyboard;
	ColorViewController *newViewController = nil;
	
	if (! viewController) {
		// This is the first controller
		newViewController = [self viewControllerAtIndex:0];
	}
	else {
		// Try to get controller based on stored index
		NSUInteger newIndex = curIndex + 1;
		if (newIndex <= 6) {
			newViewController = [self viewControllerAtIndex:newIndex];
			if (newIndex >= 3 && !newViewController.dataAvailable) {
				self.pending = YES;
				self.pendingIndex = newIndex;
				[newViewController waitForData];
				dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
					self.pending = NO;
					[newViewController dataIsAvailable];
				});
			}
		}
	}
	return newViewController;
}

- (UIViewController *)pageViewController:(SimplePageViewController *)simplePageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
	self.storyBoard = simplePageViewController.storyboard;
	ColorViewController *newViewController = nil;
	
	if (viewController) {
		int newIndex =((ColorViewController *)viewController).index-1;
		if (newIndex >= 0) {
			newViewController = [self viewControllerAtIndex:newIndex];
		}
	}
	return newViewController;
}

# pragma mark - private methods

- (ColorViewController *)viewControllerAtIndex:(NSUInteger)index
{
	NSNumber *indexObj = [NSNumber numberWithUnsignedInteger:index];
	ColorViewController *viewController = self.controllers[indexObj];
	
	if (! viewController) {
		viewController = [self.storyBoard instantiateViewControllerWithIdentifier:self.viewIds[self.count % 3]];
		self.controllers[indexObj] = viewController;
		viewController.index = index;
		self.count ++;
	}
	
	return viewController;
}

@end
