//
//  LocationPointObject.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class LocationObject;

@interface LocationPointObject :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) LocationPointObject * nextPoint;
@property (nonatomic, retain) LocationPointObject * previousPoint;
@property (nonatomic, retain) LocationObject * parentLocation;

@end



