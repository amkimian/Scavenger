//
//  GameStatusHUDView.m
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/23/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import "GameStatusHUDView.h"
#import "HardwareStatusView.h"
#import <QuartzCore/QuartzCore.h>

@implementation GameStatusHUDView
#pragma mark -
#pragma mark Properties

@synthesize gameRun;

#pragma mark -
#pragma mark Setup

- (id)initWithFrame:(CGRect)frame andGameRun: (GameRunObject *) gRun {
    if ((self = [super initWithFrame:frame])) {

	}
    return self;
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark API

-(void) setGameRun:(GameRunObject *)gR
{
	gameRun = [gR retain];
	
	// Add all of the sub views
	CGRect startFrame;
	startFrame.origin.x = 0;
	startFrame.origin.y = 0;
	startFrame.size.height = 55;
	startFrame.size.width = 55;
	
	for(HardwareObject *h in gameRun.hardware)
	{
		HardwareStatusView *hv = [[HardwareStatusView alloc] initWithFrame:startFrame];
		hv.hardware = h;
		[self addSubview:hv];
		startFrame.origin.x += 50;
	}	
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/




@end
