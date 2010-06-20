//
//  main.m
//  POC-Location
//
//  Created by Alan Moore on 6/20/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckingMapView.h"

int main(int argc, char *argv[]) {
    
	[CheckingMapView _keepAtLinkTime];
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, nil);
    [pool release];
    return retVal;
}
