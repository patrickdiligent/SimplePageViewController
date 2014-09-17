//
//  SimplePageViewControllerTests.m
//  SimplePageViewControllerTests
//
//  Created by patrick on 10/09/2014.
//  Copyright (c) 2014 Patrick. All rights reserved.
//

#import "Kiwi.h"
#import "Utility.h"
#import "SimplePageViewController+Test.h"

SPEC_BEGIN(SimplePageViewControllerSpec)

describe(@"Test Kiwi install", ^{
	it(@"pass", ^{
		[[theValue(true) should] beTrue];
	});
});

__block SimplePageViewController *pageController;
__block id dataSourceMock;
__block id viewControllerMock;

beforeEach(^{
	viewControllerMock = [[UIStoryboard storyboardWithName:@"Test" bundle:nil] instantiateViewControllerWithIdentifier:@"TestViewController"];
	dataSourceMock = [KWMock nullMockForProtocol:@protocol(SimplePageViewControllerDataSource)];
	pageController = [[SimplePageViewController alloc] init];
	pageController.dataSource = dataSourceMock;
});

describe(@"first time init", ^{
	
	it(@"Should feed first view controller", ^{
		[[dataSourceMock should] receive:@selector(pageViewController:viewControllerAfterViewController:) andReturn:viewControllerMock withArguments:pageController,nil];
		exerciseBlockWithRunLoop(^{
			[Utility installViewController:pageController];
		});
	});
	
	it (@"should feed second controller", ^{
		[[dataSourceMock should] receive:@selector(pageViewController:viewControllerAfterViewController:) andReturn:viewControllerMock withArguments:pageController,nil];
		[[dataSourceMock should] receive:@selector(pageViewController:viewControllerAfterViewController:) andReturn:viewControllerMock withArguments:pageController,viewControllerMock];
		exerciseBlockWithRunLoop(^{
			[Utility installViewController:pageController];
		});
	});
	
	it (@"should not feed second controller", ^{
		[[dataSourceMock should] receive:@selector(pageViewController:viewControllerAfterViewController:) andReturn:nil withCount:1];
		exerciseBlockWithRunLoop(^{
			[Utility installViewController:pageController];
		});
	});
	
	context(@"when changing the data source", ^{
		
		it(@"should feed the first view controller", ^{
			exerciseBlockWithRunLoop(^{
				[Utility installViewController:pageController];
			});
			[[dataSourceMock should] receive:@selector(pageViewController:viewControllerAfterViewController:) andReturn:viewControllerMock withArguments:pageController, nil];
			pageController.dataSource = dataSourceMock;
		});
		
	});

});

describe(@"Swipe", ^{

	context(@"data source", ^{

		beforeEach(^{
			exerciseBlockWithRunLoop(^{
				pageController = [Utility installInitialViewController:@"Test"];
				pageController.dataSource = nil;
			});
		});
		
		it(@"middle controller should be nil", ^{
			[[pageController.middleViewController should] beNil];
		});
		
		context(@"when middle controller is nil", ^{
			it(@"should ignore left swipe", ^{
				[[pageController shouldNot] receive:@selector(prepareRightViewController)];
				[pageController handleLeftSwipe:[UISwipeGestureRecognizer nullMock]];
			});
			it(@"should ignore right swipe", ^{
				[[pageController shouldNot] receive:@selector(prepareLeftViewController)];
				[pageController handleRightSwipe:[UISwipeGestureRecognizer nullMock]];
			});
		});
		
		context(@"when there is a middle controller", ^{
			
			beforeEach(^{
				[dataSourceMock stub:@selector(pageViewController:viewControllerAfterViewController:) andReturn:viewControllerMock];
				pageController.dataSource = dataSourceMock;
			});
			it(@"should prepare the right controller", ^{
				pageController.rightViewController = nil;
				[[dataSourceMock should] receive:@selector(pageViewController:viewControllerAfterViewController:) andReturn:viewControllerMock withArguments:pageController, pageController.middleViewController];
				[[pageController should] receive:@selector(swipeToLeft:)];
				[pageController handleLeftSwipe:[UISwipeGestureRecognizer nullMock]];
			});
			it(@"should prepare the left controller", ^{
				[[dataSourceMock should] receive:@selector(pageViewController:viewControllerBeforeViewController:) andReturn:viewControllerMock withArguments:pageController, pageController.middleViewController];
				[[pageController should] receive:@selector(swipeToRight:)];
				[pageController handleRightSwipe:[UISwipeGestureRecognizer nullMock]];
			});
		});
		
		context(@"when at end", ^{
			beforeEach(^{
				[dataSourceMock stub:@selector(pageViewController:viewControllerAfterViewController:) andReturn:viewControllerMock];
				pageController.dataSource = dataSourceMock;
			});
			it(@"should rebound right", ^{
				pageController.rightViewController = nil;
				[dataSourceMock stub:@selector(pageViewController:viewControllerAfterViewController:) andReturn:nil];
				[[pageController should] receive:@selector(reboundToLeft)];
				[pageController handleLeftSwipe:[UISwipeGestureRecognizer nullMock]];
			});
			it(@"should rebound left", ^{
				[dataSourceMock stub:@selector(pageViewController:viewControllerBeforeViewController:) andReturn:nil];
				[[pageController should] receive:@selector(reboundToRight)];
				[pageController handleRightSwipe:[UISwipeGestureRecognizer nullMock]];
			});
		});
	});
	
	describe(@"view controllers", ^{
		
		__block UIViewController *viewController1;
		__block UIViewController *viewController2;
		__block UIViewController *viewController3;
		
		beforeEach(^{
			exerciseBlockWithRunLoop(^{
				pageController = [Utility installInitialViewController:@"Test"];
				viewController1 = [[UIStoryboard storyboardWithName:@"Test" bundle:nil] instantiateViewControllerWithIdentifier:@"TestViewController"];
				viewController2 = [[UIStoryboard storyboardWithName:@"Test" bundle:nil] instantiateViewControllerWithIdentifier:@"TestViewController"];
				viewController3 = [[UIStoryboard storyboardWithName:@"Test" bundle:nil] instantiateViewControllerWithIdentifier:@"TestViewController"];
				[dataSourceMock stub:@selector(pageViewController:viewControllerAfterViewController:) andReturn:viewController1 withArguments:pageController,nil];
				[dataSourceMock stub:@selector(pageViewController:viewControllerAfterViewController:) andReturn:viewController2 withArguments:pageController,viewController1];
				[dataSourceMock stub:@selector(pageViewController:viewControllerAfterViewController:) andReturn:viewController3 withArguments:pageController,viewController2];
				pageController.dataSource = dataSourceMock;
			});
		});
		
		it(@"should have middle and right controller ", ^{
			[[pageController.leftViewController should] beNil];
			[[pageController.middleViewController shouldNot] beNil];
			[[pageController.rightViewController shouldNot] beNil];
		});
		
		it(@"view controller have correct frame", ^{
			[[theValue(pageController.middleViewController.view.frame.origin.x) should] equal:@0];
			[[theValue(pageController.rightViewController.view.frame.origin.x) should] equal:theValue(pageController.view.bounds.size.width)];
		});
		
		it(@"view controllers are at the proper location", ^{
			[[pageController.middleViewController should] equal:viewController1];
			[[pageController.rightViewController should] equal:viewController2];
		});
		
		it(@"view controllers have proper parent controller", ^{
			[[viewController1.parentViewController should] equal:pageController];
			[[viewController2.parentViewController should] beNil];
		});
		
		context(@"after swipe left", ^{
			
			beforeEach(^{
				[pageController handleLeftSwipe:[UIGestureRecognizer nullMock]];
				// Let sufficient time for the animation to complete
				[[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
			});
			
			it(@"view controllers are at the proper location", ^{
				[[pageController.leftViewController should] equal:viewController1];
				[[pageController.middleViewController should] equal:viewController2];
				[[pageController.rightViewController should] equal:viewController3];
			});
			
			it(@"view controllers have proper parent controller", ^{
				[[viewController1.parentViewController should] beNil];
				[[viewController2.parentViewController should] equal:pageController];
				[[viewController3.parentViewController should] beNil];
			});
			
			it(@"view controller have correct frame", ^{
				[[theValue(pageController.middleViewController.view.frame.origin.x) should] equal:@0];
				[[theValue(pageController.rightViewController.view.frame.origin.x) should] equal:theValue(pageController.view.bounds.size.width)];
				[[theValue(pageController.leftViewController.view.frame.origin.x) should] equal:theValue(-pageController.view.bounds.size.width)];
			});

		});
		
		context(@"after swipe right", ^{
			
			beforeEach(^{
				[dataSourceMock stub:@selector(pageViewController:viewControllerBeforeViewController:) andReturn:viewController1 withArguments:pageController,viewController2];
				[dataSourceMock stub:@selector(pageViewController:viewControllerBeforeViewController:) andReturn:viewController3 withArguments:pageController,viewController1];
				[pageController handleLeftSwipe:[UIGestureRecognizer nullMock]];
				// Let sufficient time for the animation to complete
				[[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
				[pageController handleRightSwipe:[UIGestureRecognizer nullMock]];
				// Let sufficient time for the animation to complete
				[[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
			});
			
			it(@"view controllers are at the proper location", ^{
				[[pageController.leftViewController should] equal:viewController3];
				[[pageController.middleViewController should] equal:viewController1];
				[[pageController.rightViewController should] equal:viewController2];
			});
			
			it(@"view controllers have proper parent controller", ^{
				[[viewController3.parentViewController should] beNil];
				[[viewController1.parentViewController should] equal:pageController];
				[[viewController2.parentViewController should] beNil];
			});
			
			it(@"view controller have correct frame", ^{
				[[theValue(pageController.middleViewController.view.frame.origin.x) should] equal:@0];
				[[theValue(pageController.rightViewController.view.frame.origin.x) should] equal:theValue(pageController.view.bounds.size.width)];
				[[theValue(pageController.leftViewController.view.frame.origin.x) should] equal:theValue(-pageController.view.bounds.size.width)];
			});
			
		});

	});
	
});


SPEC_END