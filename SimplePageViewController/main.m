//
//  main.m
//  SimplePageViewController
//
//  Created by patrick on 10/09/2014.
//  Copyright (c) 2014 Patrick. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char * argv[])
{
	@autoreleasepool {
		BOOL runningTests = NSClassFromString(@"XCTestCase") != nil;
		if (!runningTests) {
			return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
		}
		else {
			return UIApplicationMain(argc, argv, nil, @"TestAppDelegate");
		}
	}
}
