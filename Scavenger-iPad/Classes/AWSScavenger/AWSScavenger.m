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

-(void) publishGame: (GameObject *) game
{
	// Get the attributes for this game
	// Work out whether this game has already been published
	// Update or insert as appropriate
	
	// Name is deviceId + Name
	// Attributes...
	
	NSString *itemName = [NSString stringWithFormat:@"%@-%@", [UIDevice currentDevice].uniqueIdentifier, game.name];
	NSMutableArray *attributes = [[NSMutableArray alloc] init];
	
	// Get coordinate of first location of type "Start"	
	// Game Object should already be reverse geocoded
	
	SimpleDbAttribute *attr = [[SimpleDbAttribute alloc] init];
	attr.name = @"SomeKey";
	attr.value = @"Goodbye2";
	[attributes addObject:attr];
	[self.simpleDb putAttributes:@"Scavenger-Games" itemName:itemName attributes:attributes];	
}

@end
