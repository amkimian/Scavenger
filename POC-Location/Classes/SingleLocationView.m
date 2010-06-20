//
//  SingleLocationView.m
//  POC-Location
//
//  Created by Alan Moore on 6/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SingleLocationView.h"


@implementation SingleLocationView
@synthesize location;


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		self.backgroundColor = [UIColor clearColor]; // set the background
		self.hidden = NO;
		self.userInteractionEnabled = YES;
		self.tag = 1001;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
	// We draw a point for each LocationPointObject, with lines between them
	// We also draw (in a low alpha) how the location would appear on the map...
	
}

- (void)dealloc {
    [super dealloc];
}


@end
