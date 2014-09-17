//
//  ColorViewController.m
//  SimplePageViewController
//
//  Created by patrick on 11/09/2014.
//  Copyright (c) 2014 Patrick. All rights reserved.
//

#import "ColorViewController.h"

@interface ColorViewController ()

@property (weak, nonatomic) IBOutlet UILabel *indexLabel;
@property (nonatomic) BOOL wait;
@property (nonatomic) BOOL waiting;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation ColorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		self.wait = NO;
		self.waiting = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.indexLabel.text = [NSString stringWithFormat:@"%i", self.index];
	self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[self updateView];
}

- (BOOL)shouldAutorotate
{
	return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskPortrait;
}

- (void)updateView
{
	if (self.wait) {
		if (!self.waiting) {
			self.waiting = YES;
			self.activityIndicator.center = self.view.center;
			[self.view addSubview:self.activityIndicator];
			[self.activityIndicator startAnimating];
		}
	}
	else {
		self.waiting = NO;
		[self.activityIndicator removeFromSuperview];
	}
	[self.view setNeedsDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)waitForData
{
	self.wait = YES;
}

- (void)dataIsAvailable
{
	self.wait = NO;
	self.dataAvailable = YES;
	[self updateView];
}

@end
