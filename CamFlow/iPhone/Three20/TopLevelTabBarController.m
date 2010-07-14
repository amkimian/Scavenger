//
//  TopLevelTabBarController.m
//  CamFlow
//
//  Created by Alan Moore on 7/14/10.
//  Copyright 2010 Mount Diablo Software. All rights reserved.
//

#import "TopLevelTabBarController.h"


@implementation TopLevelTabBarController
- (void)viewDidLoad {
	[self setTabURLs:[NSArray arrayWithObjects:@"cf://camera",
					  @"cf://viewer",
					  @"cf://settings",
					  nil]];
}


@end
