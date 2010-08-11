//
//  LocationPointObject.h
//  MapNotes
//
//  Created by Alan Moore on 8/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class RegionObject;

@interface LocationPointObject :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) LocationPointObject * nextPoint;
@property (nonatomic, retain) RegionObject * region;
@property (nonatomic, retain) LocationPointObject * previousPoint;

@end



