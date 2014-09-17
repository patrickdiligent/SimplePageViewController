//
//  SimplePageViewControllerDataSource.h
//  SimplePageViewController
//
//  Created by patrick on 12/09/2014.
//  Copyright (c) 2014 Patrick. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SimplePageViewController;

@protocol SimplePageViewControllerDataSource <NSObject>

@optional

- (UIViewController *)pageViewController:(SimplePageViewController *)simplePageViewController viewControllerBeforeViewController:(UIViewController *)viewController;

- (UIViewController *)pageViewController:(SimplePageViewController *)simplePageViewController viewControllerAfterViewController:(UIViewController *)viewController;

@end
