//
//  CheckingMapView.m
//  MDSTH
//
//  Created by Alan Moore on 6/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CheckingMapView.h"


@implementation CheckingMapView

+(void) _keepAtLinkTime
{
	
}


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [super dealloc];
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {	
	NSSet *touches = [event allTouches];
	BOOL forwardToSuper = YES;
	NSLog(@"Map View hitTest");
	// Forward to subView
	UIView *subView = [self viewWithTag:1001];
					   
	UIView *subViewHit = [subView hitTest: point withEvent: event];
	NSLog(@"End hitTest");
	if (subViewHit)
	{
		NSLog(@"Returning subview to hit");
		return subViewHit;
	}
	
	for (UITouch *touch in touches) {
		if ([touch tapCount] >= 2) {
			// prevent this 
			forwardToSuper = NO;
		}		
	}
	if (forwardToSuper){
		//return self.superview;
		return [super hitTest:point withEvent:event];
	}
	else {
		// Return the superview as the hit and prevent
		// UIWebView receiving double or more taps
		return self.superview;
	}
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	// Is the touch in one of the locations? If so, make it the active touch location
	// if not, pass through the touch
	NSLog(@" Checking Touch began");
	[super touchesBegan:touches withEvent:event];
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	// If we have a current location move it
	// If not, pass through the touch
	NSLog(@"Checking Touch moved");	
	[super touchesMoved:touches withEvent:event];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	// If we have a current location stop moving it
	NSLog(@"Checking Touch ended");
	[super touchesEnded: touches withEvent: event];
}


@end
