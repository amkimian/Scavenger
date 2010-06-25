//
//  HardwareStatusView.m
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/23/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import "HardwareStatusView.h"
#import "GameRunObject.h"
#import <QuartzCore/QuartzCore.h>

@implementation HardwareStatusView
@synthesize hardware;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		self.backgroundColor = [UIColor blackColor];
		self.alpha = 0.7f;
		self.opaque = NO;
		self.layer.cornerRadius = 10;
    }
    return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	// Is the touch in one of the locations? If so, make it the active touch location
	// if not, pass through the touch
	NSLog(@"HUD view Touch began");
	// A touch in the status view means change from active to not active
	BOOL currentlyActive = [hardware.active boolValue];
	if (currentlyActive)
	{
		hardware.active = [NSNumber numberWithBool: NO];
	}
	else
	{
		hardware.active = [NSNumber numberWithBool: YES];
	}
	if ([hardware.hudCode isEqualToString:@"PWR"])
	{
		NSLog(@"Handling Power");
		for(HardwareObject *h in hardware.inGame.hardware)
		{
			h.hasPower = hardware.active;				
		}	
		for(UIView *v in self.superview.subviews)
		{
			[v setNeedsDisplay];
		}
	}
	[self setNeedsDisplay];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	// Draw the main rectangle for the status
	CGRect mainRect = [self getMainRectangle];
	
	// Draw image
	
	CGContextSetFillColorWithColor(context, [hardware getStatusColor].CGColor);
	CGContextFillRect(context, mainRect);
	
	UIImage *img = [hardware getImage];
	CGRect drawRect = mainRect;
	drawRect.size.width = img.size.width;
	drawRect.size.height = img.size.height;
	drawRect.origin.x += (mainRect.size.width - img.size.width)/2;
	drawRect.origin.y += (mainRect.size.height - img.size.height)/2;
	[img drawInRect:drawRect];


	// Draw the text on top of that
//	NSString *label = hardware.hudCode;
//	CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
//	mainRect.origin.y = mainRect.size.height / 2;
//	[label drawInRect:mainRect withFont:[UIFont systemFontOfSize:10] lineBreakMode:UILineBreakModeMiddleTruncation alignment:UITextAlignmentCenter];
	
	CGRect startDamageRect;
	startDamageRect.origin.x = 5;
	startDamageRect.origin.y = self.bounds.size.height - 5;
	startDamageRect.size.width = 3;
	startDamageRect.size.height = 3;
	
	float percentage = [hardware getPercentage];
	for(int i=0; i< 10; i++)
	{
		float alpha = 1.0;
		if (i*10 < percentage)
		{
			alpha = 0.5;
		}
		
		CGColorRef color;
		
		if (i <= 4)
		{
			color = CGColorCreateCopyWithAlpha([UIColor greenColor].CGColor, alpha);	
		}
		else if (i <= 7)
		{
			color = CGColorCreateCopyWithAlpha([UIColor yellowColor].CGColor, alpha);	
		}
		else
		{
			color = CGColorCreateCopyWithAlpha([UIColor redColor].CGColor, alpha);	
		}
		CGContextSetFillColorWithColor(context, color);
		CGContextFillRect(context, startDamageRect);
		startDamageRect.origin.x += 3;
	}
}

-(CGRect) getMainRectangle
{
	CGRect ret = self.bounds;
	ret.origin.x += 5;
	ret.origin.y += 5;
	ret.size.width -= 10;
	ret.size.height -= 12; // Leave 20 for the damage range
	return ret;	
}

- (void)dealloc {
    [super dealloc];
}


@end
