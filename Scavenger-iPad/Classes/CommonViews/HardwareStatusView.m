//
//  HardwareStatusView.m
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/23/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import "HardwareStatusView.h"
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


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	// Draw the main rectangle for the status
	CGRect mainRect = [self getMainRectangle];
	CGContextSetFillColorWithColor(context, [hardware getStatusColor].CGColor);
	CGContextFillRect(context, mainRect);
	// Draw the text on top of that
	NSString *label = hardware.name;
	CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
	mainRect.origin.y = mainRect.size.height / 2;
	[label drawInRect:mainRect withFont:[UIFont systemFontOfSize:10] lineBreakMode:UILineBreakModeMiddleTruncation alignment:UITextAlignmentCenter];
	
	CGRect startDamageRect;
	startDamageRect.origin.x = 5;
	startDamageRect.origin.y = self.bounds.size.height - 5;
	startDamageRect.size.width = 3;
	startDamageRect.size.height = 3;
	
	int damage = [hardware.damage intValue];
	for(int i=0; i< 10; i++)
	{
		float alpha = 1.0;
		if (i*10 < damage)
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