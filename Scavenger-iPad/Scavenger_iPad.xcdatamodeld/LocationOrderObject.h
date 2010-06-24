//
//  LocationOrderObject.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class GameRouteObject;
@class LocationObject;

@interface LocationOrderObject :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * position;
@property (nonatomic, retain) LocationObject * location;
@property (nonatomic, retain) GameRouteObject * gameRoute;

@end



