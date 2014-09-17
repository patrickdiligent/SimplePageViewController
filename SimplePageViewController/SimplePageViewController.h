//
//  SimplePageViewController.h
//  SimplePageViewController
//
//  Created by patrick on 10/09/2014.
//  Copyright (c) 2014 Patrick. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SimplePageViewControllerDataSource.h"
#import "SimplePageViewControllerDelegate.h"

@interface SimplePageViewController : UIViewController

@property (weak, nonatomic) IBOutlet id<SimplePageViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet id<SimplePageViewControllerDataSource> dataSource;

@end
