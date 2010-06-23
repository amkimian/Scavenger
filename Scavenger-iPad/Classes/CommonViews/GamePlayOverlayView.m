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

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		self.backgroundColor = [UIColor clearColor]; // set the background
    }
    return self;
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
	if (hazardCheck)
	{
		int damage = [hazardCheck.damage intValue];
		if (damage > 50)
		{
			float percentageDamage = (100 - damage) / 50.0;
			hazardAlphaValue = (1 - percentageDamage) * 0.7;
		}
	}
	HardwareObject *bonusCheck = [gameRun getHardwareWithName:@"Bonus"];
	if (bonusCheck)
	{
		int damage = [bonusCheck.damage intValue];
		if (damage > 50)
		{
			float percentageDamage = (100 - damage) / 50.0;
			bonusAlphaValue = (1 - percentageDamage) * 0.7;
		}
	}
	
	// Draw locations
	for(LocationObject * l in gameRun.game.locations)
	{
		if ([l.visible boolValue] == YES)
		{
			NSLog(@"Loc visible");
			float realAlphaValue = 0.7;
			if ([l isHazard])
			{
				realAlphaValue = hazardAlphaValue;
			}
			else
			{
				realAlphaValue = bonusAlphaValue;
			}
			[l drawLocation:mapView andView:self andAlpha:realAlphaValue];			
		}
		else
		{
			NSLog(@"Loc not visible");
		}
	}
	if ([gameRun isRunning])
	{
		// If the game has started, draw the radar overlay
		[self drawRadarOverlay:rect];
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
