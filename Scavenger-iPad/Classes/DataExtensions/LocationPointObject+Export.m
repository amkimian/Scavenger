//
//  LocationPointObject+Export.m
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/24/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import "LocationPointObject+Export.h"


@implementation LocationPointObject(Export)
-(NSDictionary *)getAsExportDictionary
{
	NSMutableDictionary *ret = [[NSMutableDictionary alloc] init];
	[ret setObject:self.latitude forKey:@"latitude"];
	[ret setObject:self.longitude forKey:@"longitude"];
	return ret;
	
}
@end
