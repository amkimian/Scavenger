//
//  LocationObject+Extensions.m
//  POC-Location
//
//  Created by Alan Moore on 6/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LocationObject+Extensions.h"
#import "LocationPointObject.h"

@implementation LocationObject(Extensions)
-(int) countPoints
{
	int count = 0;
	LocationPointObject *point = self.firstPoint;
	while(point != nil)
	{
		count++;
		point = point.nextPoint;
	}
	return count;
}
@end
