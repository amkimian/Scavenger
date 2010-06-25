//
//  GamePlayOverlayView.m
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/22/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import "GamePlayOverlayView.h"
#import "GameObject.h"
#import "GameRunObject+Extensions.h"
#import "HardwareObject+Extensions.h"
#import "LocationObject+Extensions.h"



@implementation GamePlayOverlayView
@synthesize gameRun;
@synthesize hudView;
@synthesize desiredLocation;
@synthesize hasDesiredLocation;
@synthesize isInPingMode;
@synthesize scoreView;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		self.backgroundColor = [UIColor clearColor]; // set the background
		CGRect gameStatusHUDFrame;
		gameStatusHUDFrame.origin.x = 0;
		gameStatusHUDFrame.origin.y = 0;
		gameStatusHUDFrame.size.width = 400;
		gameStatusHUDFrame.size.height = 55;
		hasDesiredLocation = NO;
		isInPingMode = NO;
		
		hudView = [[GameStatusHUDView alloc] initWithFrame:gameStatusHUDFrame];		
		[self addSubview: hudView];
		
		CGRect scoreFrame;
		scoreFrame.origin.x = 0;
		scoreFrame.size.width = 130;
		scoreFrame.origin.y = 55;
		scoreFrame.size.height = 60;
		scoreView = [[ScoreView alloc] initWithFrame:scoreFrame];
		scoreView.scoreValue = 0.0;
		scoreView.bonusValue = 0.0;
		[self addSubview: scoreView];
    }
    return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"Touch in game play overlay view");
	// Need to pass this to the gameManager as a simulated move
	
	MKMapView *mapView = (MKMapView *)[self superview];
	UITouch *touch = [touches anyObject];
	desiredLocation = [mapView convertPoint:[touch locationInView:self] toCoordinateFromView:self];
	hasDesiredLocation = YES;
	
}
-(void) setGameRun:(GameRunObject *)gR
{
	gameRun = [gR retain];
	hudView.gameRun = gR;
}

-(void) refreshHud
{
	[self.hudView setNeedsDisplay];
	for(UIView *subView in self.hudView.subviews)
	{
		[subView setNeedsDisplay];
	}	
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	NSLog(@"Hello");
	MKMapView *mapView = (MKMapView *)[self superview];
	// Draw locations that are available and visible, depending on hardware states and what is allowed
	// in the current game state
	
	// (1) we draw hazards if the "Hazard" hardware damage is < 50. Anything greater than 50 alters the alpha value of our display
	// (2) we draw locations (that have visible set) if the "Bonus" hardware damage is < 50. Anything greater than 50 alters the alpha value of our display
	
	float hazardAlphaValue = 0.7; // The default
	float bonusAlphaValue = 0.7; // The default
	
	HardwareObject *hazardCheck = [gameRun getHardwareWithName:@"Hazard"];
	BOOL noHazards = NO;
	BOOL noLocations = NO;
	
	if (hazardCheck)
	{
		if ([hazardCheck.active boolValue] && [hazardCheck.hasPower boolValue])
		{
			float perc = [hazardCheck getPercentage];
			if (perc < 50)
			{
				hazardAlphaValue = perc/100 * 0.7;
			}
		}
		else
		{
			noHazards = YES;
		}
	}
	HardwareObject *bonusCheck = [gameRun getHardwareWithName:@"Bonus"];
	if (bonusCheck)
	{
		if ([bonusCheck.active boolValue] && [bonusCheck.hasPower boolValue])
		{
			float perc = [bonusCheck getPercentage];
			if (perc < 50)
			{
				bonusAlphaValue = perc/100 * 0.7;
			}
		}
		else
		{
			noLocations = YES;
		}
	}	
	
	// Draw locations
	for(LocationObject * l in gameRun.game.locations)
	{
		if ([l.visible boolValue] == YES)
		{
			float realAlphaValue = 0.7;
			if ([l isHazard])
			{
				realAlphaValue = hazardAlphaValue;
			}
			else
			{
				realAlphaValue = bonusAlphaValue;
			}
			if (([l isHazard] && noHazards == NO)
				|| (![l isHazard] && noLocations == NO))
			{
				[l drawLocation:mapView andView:self andAlpha:realAlphaValue inGame:YES];			
			}
		}
		else
		{
		}
	}
	if ([gameRun isRunning])
	{
		// If the game has started, draw the radar overlay
		[self drawRadarOverlay:rect];
	}
	// Also draw center

	CLLocationCoordinate2D coord = mapView.centerCoordinate;
	CGPoint p = [mapView convertCoordinate:coord toPointToView:self];
	CGRect r;
	r.origin.x = p.x - 10;
	r.origin.y = p.y - 10;
	r.size.width = 20;
	r.size.height = 20;
	CGContextFillRect(UIGraphicsGetCurrentContext(), r);
	
	// Also, if in PingMode, really draw ActiveLocation
	
	if (self.isInPingMode)
	{
		[gameRun.seekingLocation drawLocation:mapView andView:self andAlpha:1.0 inGame:YES];
	}
}

- (void)dealloc {
    [super dealloc];
}

-(void) drawRadarOverlay: (CGRect) rect
{
	// Draw radar fields
	MKMapView *mapView = (MKMapView *)[self superview];	
	CGContextRef c = UIGraphicsGetCurrentContext();
	
#define NGOES 20
	
	CGContextSetLineWidth(c, 1+rect.size.height / NGOES);
	
	// Now draw arcs
	
	
	CGPoint center = CGPointMake(rect.origin.x + rect.size.width/2, rect.origin.y + rect.size.height/2);
	float unitRadius = rect.size.height / NGOES;
	CGRect startRect = CGRectMake(center.x - unitRadius, center.y - unitRadius, unitRadius*2, unitRadius*2);
	
	CLLocation *c1 = [[CLLocation alloc] initWithLatitude:mapView.centerCoordinate.latitude longitude:mapView.centerCoordinate.longitude];
	CLLocation *e1 = [[CLLocation alloc] initWithLatitude:mapView.centerCoordinate.latitude + mapView.region.span.latitudeDelta longitude: mapView.centerCoordinate.longitude + mapView.region.span.latitudeDelta];
	CLLocationDistance distance = [c1 distanceFromLocation: e1];
	[e1 release];
	[c1 release];
	
	HardwareObject *radar = [gameRun getHardwareWithName:@"Radar"];
	float radarRange = (float) 500.0; // [gameRun.radarRange intValue]; //(e.g. 500 meters)
	if (radar)
	{
		radarRange = [radar getRadarRange];
	}
	
	float factor = distance/radarRange; // This number has to be proportional to (a) radar strength and (b) the size of the map
		
	for(int i=1; i<= NGOES; i++)
	{
		float alpha = i;
		alpha = factor * alpha / NGOES;
		CGContextSetRGBStrokeColor(c, 0,0,0,alpha);
		startRect.size.width = unitRadius * i * 2;
		startRect.size.height = unitRadius * i *2;
		startRect.origin.x = center.x - unitRadius * i;
		startRect.origin.y = center.y - unitRadius * i;
		// Rect centered around
		CGContextAddEllipseInRect(c, startRect);
		//CGContextAddArc(c, rect.size.width/2, rect.size.height/2, i * rect.size.height / NGOES, 0, 1.9*3.14, 1);
		CGContextStrokePath(c);
	}	
}

@end
