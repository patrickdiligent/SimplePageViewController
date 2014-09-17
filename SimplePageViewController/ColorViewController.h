//
//  ColorViewController.h
//  SimplePageViewController
//
//  Created by patrick on 11/09/2014.
//  Copyright (c) 2014 Patrick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorViewController : UIViewController

@property (strong, nonatomic) NSString *color;
@property (nonatomic) int index;
@property (nonatomic) BOOL dataAvailable;

- (void)waitForData;
- (void)dataIsAvailable;

@end
