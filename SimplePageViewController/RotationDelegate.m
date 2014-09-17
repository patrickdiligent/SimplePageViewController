//
//  RotationDelegate.m
//  SimplePageViewController
//
//  Created by patrick on 17/09/2014.
//  Copyright (c) 2014 Patrick. All rights reserved.
//

#import "RotationDelegate.h"

@implementation RotationDelegate

- (NSUInteger)pageViewControllerSupportedInterfaceOrientations:(SimplePageViewController *)pageViewController
{
	return UIInterfaceOrientationMaskLandscapeLeft;
}

@end
