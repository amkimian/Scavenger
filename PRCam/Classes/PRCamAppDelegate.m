//
//  PRCamAppDelegate.m
//  PRCam
//
//  Created by Alan Moore on 7/8/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "PRCamAppDelegate.h"
#import "MainViewController.h"

@implementation PRCamAppDelegate


@synthesize window;
@synthesize mainViewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	MainViewController *aController = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
	self.mainViewController = aController;
	[aController release];
	
    mainViewController.view.frame = [UIScreen mainScreen].applicationFrame;
	[window addSubview:[mainViewController view]];
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
    [mainViewController release];
    [window release];
    [super dealloc];
}

@end
