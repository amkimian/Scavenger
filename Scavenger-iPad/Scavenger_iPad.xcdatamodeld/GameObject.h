//
//  GameObject.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class GameRouteObject;
@class GameRunObject;
@class LocationObject;

@interface GameObject :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) GameRunObject * gameRun;
@property (nonatomic, retain) NSSet* gameRoutes;
@property (nonatomic, retain) NSSet* locations;

@end


@interface GameObject (CoreDataGeneratedAccessors)
- (void)addGameRoutesObject:(GameRouteObject *)value;
- (void)removeGameRoutesObject:(GameRouteObject *)value;
- (void)addGameRoutes:(NSSet *)value;
- (void)removeGameRoutes:(NSSet *)value;

- (void)addLocationsObject:(LocationObject *)value;
- (void)removeLocationsObject:(LocationObject *)value;
- (void)addLocations:(NSSet *)value;
- (void)removeLocations:(NSSet *)value;

@end

