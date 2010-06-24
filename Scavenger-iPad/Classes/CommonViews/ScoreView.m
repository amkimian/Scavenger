//
//  ScoreView.m
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/23/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import "ScoreView.h"


@implementation ScoreView
@synthesize scoreValue;
@synthesize bonusValue;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		self.backgroundColor = [UIColor blackColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	// Simply draw the text centered on the rectangle
	CGContextRef context = UIGraphicsGetCurrentContext();
	NSString *label = [NSString stringWithFormat:@"%08.0f", scoreValue];
	CGRect drawRect = rect;
	drawRect.size.height = 25;
	CGContextSetFillColorWithColor(context, [UIColor yellowColor].CGColor);
	[label drawInRect:drawRect withFont:[UIFont systemFontOfSize:25] lineBreakMode:UILineBreakModeMiddleTruncation alignment:UITextAlignmentRight];
	label = [NSString stringWithFormat:@"%08.0f", bonusValue];
	CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
	drawRect.origin.y = 25;
	[label drawInRect:drawRect withFont:[UIFont systemFontOfSize:25] lineBreakMode:UILineBreakModeMiddleTruncation alignment:UITextAlignmentRight];
}

- (void)dealloc {
    [super dealloc];
}


@end
