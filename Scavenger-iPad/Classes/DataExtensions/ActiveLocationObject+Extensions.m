//
//  ActiveLocationObject+Extensions.m
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/26/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import "ActiveLocationObject+Extensions.h"
#import "MissileObject.h"
#import "LocationPointObject.h"
#import "LocationObject.h"
#import "GameRunObject.h"

@implementation ActiveLocationObject(Extensions)
-(void) fireTowerAtLocation: (LocationObject *) loc
{
	// Create a missile object with destination - the passed location
	// with the damage attributes of the current location objects location
	NSEntityDescription *desc = [NSEntityDescription entityForName:@"Missile" inManagedObjectContext:[self managedObjectContext]];
	MissileObject *missile = [[MissileObject alloc] initWithEntity:desc insertIntoManagedObjectContext:[self managedObjectContext]];
	missile.targetLatitude = loc.firstPoint.gameLatitude;
	missile.targetLongitude = loc.firstPoint.gameLongitude;
	missile.currentLatitude = self.location.firstPoint.gameLatitude;
	missile.currentLongitude = self.location.firstPoint.gameLongitude;
	missile.affects = self.targetModifies;
	missile.amount = self.amount;
	
	[self.gameRun addMissilesObject:missile];
	[missile release];
}
@end
