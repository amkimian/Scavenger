//
//  GameObject_Extensions.m
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/16/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import "GameObject+Extensions.h"
#import "LocationObject+Extensions.h"

@implementation GameObject(Extensions)
-(LocationObject *) addLocationOfType: (LocationType) type
{
	// Create new LocationObject, setup its type, and add it to the locations set
	// Some types can only have one type, so if they are already in the locations set, return
	// that one
	
	NSMutableSet *locations = [self mutableSetValueForKey: @"locations"];
	int iType = (int) type;
	if (iType <= (int) LTYPE_CENTER)
	{
		for(LocationObject *loc in [locations allObjects])
		{
			if ([loc.locationType intValue] == (int) type)
			{
				return loc;
			}
		}
	}
	// Otherwise create a new one and add it
	NSEntityDescription *edesc = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:[self managedObjectContext]];
	LocationObject *loc = [[LocationObject alloc] initWithEntity:edesc insertIntoManagedObjectContext:[self managedObjectContext]];
	loc.locationType = [NSNumber numberWithInt:(int) type];
	[locations addObject:loc];
	return loc;
}

-(LocationObject *) getLocationOfType: (LocationType) type
{
	NSMutableSet *locations = [self mutableSetValueForKey: @"locations"];
	int iType = (int) type;
	if (iType <= (int) LTYPE_CENTER)
	{
		for(LocationObject *loc in [locations allObjects])
		{
			if ([loc.locationType intValue] == (int) type)
			{
				return loc;
			}
		}
	}
	return nil;
}

-(NSString *) title
{
	return self.name;
}

-(CLLocationCoordinate2D) coordinate
{
	LocationObject *centerPoint = [self getLocationOfType: LTYPE_CENTER];
	CLLocationCoordinate2D ret;
	ret.latitude = [centerPoint.latitude floatValue];
	ret.longitude = [centerPoint.longitude floatValue];
	return ret;
}

@end
