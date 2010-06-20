//
//  SingleLocationView.h
//  POC-Location
//
//  Created by Alan Moore on 6/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationObject+Extensions.h"

@interface SingleLocationView : UIView {
	LocationObject *location;
}

@property(nonatomic, retain) LocationObject *location;

@end
