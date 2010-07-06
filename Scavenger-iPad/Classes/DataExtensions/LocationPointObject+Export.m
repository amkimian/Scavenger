//
//  LocationPointObject+Export.m
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/24/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import "LocationPointObject+Export.h"


@implementation LocationPointObject(Export)
-(NSDictionary *)getCopyAsExportDictionary
{
	NSMutableDictionary *ret = [[NSMutableDictionary alloc] init];
	[ret setObject:self.latitude forKey:@"latitude"];
	[ret setObject:self.longitude forKey:@"longitude"];
	return ret;
	
}

+(LocationPointObject *) newFromExportDictionary: (NSDictionary *) dict inManagedObjectContext: (NSManagedObjectContext *) context
{
	NSEntityDescription *edesc = [NSEntityDescription entityForName:@"LocationPoint" inManagedObjectContext:context];
	LocationPointObject *location = [[LocationPointObject alloc] initWithEntity:edesc insertIntoManagedObjectContext:context];
	location.latitude = [dict objectForKey: @"latitude"];
	location.longitude = [dict objectForKey: @"longitude"];
	return location;
}

@end
