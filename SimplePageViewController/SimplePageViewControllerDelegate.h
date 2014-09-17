//
//  SimplePageViewControllerDelegate.h
//  SimplePageViewController
//
//  Created by patrick on 10/09/2014.
//  Copyright (c) 2014 Patrick. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SimplePageViewControllerDelegate <NSObject>

@optional

- (NSUInteger)pageViewControllerSupportedInterfaceOrientations:(SimplePageViewController *)pageViewController;

@end
