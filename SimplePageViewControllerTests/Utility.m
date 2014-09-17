//
//  Utility.m
//  BlockDesignProto
//
//  Created by patrick on 5/11/2013.
//  Copyright (c) 2013 wattlebird. All rights reserved.
//

#import "Utility.h"

__strong Utility *_utility = nil;

void exerciseBlockWithRunLoop(RunLoopBlock run)
{
	run();
	[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
}

void exerciseBlockWithRunLoopAndTimeout(RunLoopBlock run, float timeout)
{
	run();
	[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:timeout]];
}

@implementation Utility


+ (id)installViewControllerFromStoryBoard:(NSString *)storyBoard bundle:(NSBundle *)bundle withIdentifier:(NSString *)identifier
{
	UIViewController *rootController = [UIApplication sharedApplication].keyWindow.rootViewController;
	if (rootController) {
		[rootController.view removeFromSuperview];
		[Utility getInstance].board = nil;
		rootController.view = nil;
	}
	
	[Utility getInstance].board = [UIStoryboard storyboardWithName:storyBoard bundle:bundle];
	UIViewController *controller;
	if (identifier) {
		controller = [[Utility getInstance].board instantiateViewControllerWithIdentifier:identifier];
	}
	else {
		controller = [[Utility getInstance].board instantiateInitialViewController];
	}
	if (controller) {
		[[UIApplication sharedApplication].keyWindow setRootViewController:controller];
	}
	return controller;
}

+ (void)clearRootController
{
	UIViewController *rootController = [UIApplication sharedApplication].keyWindow.rootViewController;
	if (rootController) {
		[rootController.view removeFromSuperview];
		[Utility getInstance].board = nil;
		rootController.view = nil;
	}
}

+ (void)installViewController:(UIViewController *)viewController
{
	if (viewController) {
		[[UIApplication sharedApplication].keyWindow setRootViewController:viewController];
	}
}

+ (id)installViewControllerFromStoryBoard:(NSString *)storyBoard withIdentifier:(NSString *)id
{
	return [self installViewControllerFromStoryBoard:storyBoard bundle:nil withIdentifier:id];
}

+ (id)installInitialViewController:(NSString *)storyBoard bundle:(NSBundle *)bundle
{
	return [Utility installViewControllerFromStoryBoard:storyBoard bundle:bundle withIdentifier:nil];
}

+ (id)installInitialViewController:(NSString *)storyBoard
{
	return [Utility installViewControllerFromStoryBoard:storyBoard withIdentifier:nil];
}

+ (Utility *)getInstance
{
	if (!_utility) {
		_utility = [[Utility alloc] init];
	}
	return _utility;
}

+ (void)clearStoryBoard
{
	[Utility getInstance].board = nil;
}

+ (NSURL *)applicationSupportDirectory
{
	return [[[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (BOOL)checkFileExistsAtApplicationSupportDirectory:(NSString *)filename
{
	NSURL *storeURL = [[Utility applicationSupportDirectory] URLByAppendingPathComponent:filename];
	return [[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]];
}

+ (void)removeFileAtApplicationSupportDirectory:(NSString *)filename
{
	NSURL *storeURL = [[Utility applicationSupportDirectory] URLByAppendingPathComponent:filename];
	NSError *error;
	[[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error];
}

@end
