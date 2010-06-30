//
//  AWSScavenger.m
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/29/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import "AWSScavenger.h"
#import "GameObject+Extensions.h"
#import "LocationObject+Extensions.h"
#import "LocationPointObject.h"
#import "PlaceMarkObject.h"

@implementation AWSScavenger
@synthesize simpleDb;

-(id) init
{
	self.simpleDb = [[SimpleDb alloc] init];
	self.simpleDb.delegate = self;
	[self.simpleDb setAWSAccount:@"0289QDXAHCXX0JH9GXR2" secret: @"o3Nw5NnnamrywCy7m6gIEBEQiKZrnROP/cxuvvLy"];
	return self;
}

-(void) listDomains
{
	[self.simpleDb listDomains];
}

- (void) listDomainsComplete:(NSMutableArray*) domains
{
	for(NSString *domain in domains)
	{
		NSLog(@"Domain is %@", domain);
	}
}

-(void) unpublishGame: (GameObject *) game
{
	NSString *itemName = [NSString stringWithFormat:@"%@-%@", [UIDevice currentDevice].uniqueIdentifier, game.name];
	[self.simpleDb deleteAttributes:@"Scavenger-Games" itemName:itemName attributes:nil];
}

-(void) publishGame: (GameObject *) game
{
	// Get the attributes for this game
	// Work out whether this game has already been published
	// Update or insert as appropriate
	
	// Name is deviceId + Name
	// Attributes...
	
	[self unpublishGame: game];
	
	NSString *itemName = [NSString stringWithFormat:@"%@-%@", [UIDevice currentDevice].uniqueIdentifier, game.name];
	
	
	NSMutableArray *attributes = [[NSMutableArray alloc] init];
	
	// Get coordinate of first location of type "Start"	
	// Game Object should already be reverse geocoded
	
	[self addAttribute: @"Country" withValue: game.placeMark.country intoArray:attributes];
	[self addAttribute: @"Locality" withValue: game.placeMark.locality intoArray:attributes];
	[self addAttribute: @"AdminArea" withValue: game.placeMark.administrativeArea intoArray:attributes];
	[self addAttribute: @"SubArea" withValue: game.placeMark.subAdministrativeArea intoArray:attributes];
	[self addAttribute: @"PostalCode" withValue: game.placeMark.postalCode intoArray:attributes];
	
	// Need to add DeviceID
	// Game name
	// Latitude
	// Longitude
	// Stars
	// Description (new field in Game object)
	
	LocationObject *startLocation = [game getLocationOfType:LTYPE_START];
	
	[self addAttribute: @"Name" withValue: game.name intoArray:attributes];
	[self addAttribute: @"Latitude" withValue: [NSString stringWithFormat: @"%@", startLocation.firstPoint.latitude] intoArray:attributes];
	[self addAttribute: @"Longitude" withValue: [NSString stringWithFormat: @"%@", startLocation.firstPoint.longitude] intoArray:attributes];
	[self addAttribute: @"DeviceID" withValue: [UIDevice currentDevice].uniqueIdentifier intoArray:attributes];
	
	// And description when we have it
	
	if ([attributes count] > 0)
	{
		[self.simpleDb putAttributes:@"Scavenger-Games" itemName:itemName attributes:attributes];	
	}
	else
	{
		NSLog(@"There is nothing to publish!");
	}
}

-(void) addAttribute: (NSString *) name withValue: (NSString *) value intoArray: (NSMutableArray *) array
{
	if (value)
	{
		SimpleDbAttribute *attr = [[SimpleDbAttribute alloc] init];
		attr.name = name;
		attr.value = value;
		[array addObject: attr];	
	}
}

@end
