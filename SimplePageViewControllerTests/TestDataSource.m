//
//  TestDataSource.m
//  SimplePageViewController
//
//  Created by patrick on 16/09/2014.
//  Copyright (c) 2014 Patrick. All rights reserved.
//

#import "TestDataSource.h"
#import "Utility.h"

@implementation TestDataSource

- (UIViewController *)pageViewController:(SimplePageViewController *)simplePageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
	return [[UIStoryboard storyboardWithName:@"Test" bundle:nil] instantiateViewControllerWithIdentifier:@"TestViewController"];
}

- (UIViewController *)pageViewController:(SimplePageViewController *)simplePageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
	return [[UIStoryboard storyboardWithName:@"Test" bundle:nil] instantiateViewControllerWithIdentifier:@"TestViewController"];
}


@end
