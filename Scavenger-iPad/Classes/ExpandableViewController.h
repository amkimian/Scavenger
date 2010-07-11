//
//  ExpandableViewController.h
//  MDSLib
//
//  Created by Alan Moore on 6/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ExpandableViewController : NSObject {
	IBOutlet UIView *view;
	CGSize largeSize;
	CGSize smallSize;
	BOOL showingSmall;
}

-(IBAction) toggle: (id) sender;
+(void) _keepAtLinkTime;
@end
