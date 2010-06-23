//
//  main.m
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/16/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpandableViewController.h"

int main(int argc, char *argv[]) {
 	[ExpandableViewController _keepAtLinkTime];   
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
}
