//
//  Utility.h
//  BlockDesignProto
//
//  Created by patrick on 5/11/2013.
//  Copyright (c) 2013 wattlebird. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef _ExerciseRunLoopBlock
#define _ExerciseRunLoopBlock

typedef void (^RunLoopBlock)(void);
extern void exerciseBlockWithRunLoop(RunLoopBlock run);
extern void exerciseBlockWithRunLoopAndTimeout(RunLoopBlock run, float timeout);

#endif

@interface Utility : NSObject

@property (nonatomic) UIStoryboard *board;

+ (id)installInitialViewController:(NSString *)storyBoard;
+ (id)installViewControllerFromStoryBoard:(NSString *)storyBoard withIdentifier:(NSString *)id;
+ (id)installViewControllerFromStoryBoard:(NSString *)storyBoard bundle:(NSBundle *)bundle withIdentifier:(NSString *)id;
+ (void)installViewController:(UIViewController *)viewController;
+ (void)clearStoryBoard;
+ (void)clearRootController;
+ (Utility *)getInstance;

+ (BOOL)checkFileExistsAtApplicationSupportDirectory:(NSString *)filename;
+ (void)removeFileAtApplicationSupportDirectory:(NSString *)filename;

@end
