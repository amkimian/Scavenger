//
//  main.m
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/16/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpandableViewController.h"
#import "CGPointUtils.h"

int main(int argc, char *argv[]) {
 	[ExpandableViewController _keepAtLinkTime];   
	
	/*
	CGPoint one;
	CGPoint two;
	CGPoint three;
	CGPoint four;
	CGPoint five;
	
	one.x = 1;
	one.y = 1;
	two.x = 1;
	two.y = 2;
	three.x = 0;
	three.y = 1;
	four.x = 1;
	four.y = 0;
	five.x = 2;
	five.y = 1;
	
	float angle1 = angleBetweenPoints(one, two);
	float angle2 = angleBetweenPoints(one, three);
	float angle3 = angleBetweenPoints(one, four);
	float angle4 = angleBetweenPoints(one, five);
	*/
	
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
}
