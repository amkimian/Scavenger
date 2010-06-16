//
//  GameObject.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/16/10.
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
@property (nonatomic, retain) NSSet* games;
@property (nonatomic, retain) NSSet* gameRoutes;
@property (nonatomic, retain) NSSet* locations;

@end


@interface GameObject (CoreDataGeneratedAccessors)
- (void)addGamesObject:(GameRunObject *)value;
- (void)removeGamesObject:(GameRunObject *)value;
- (void)addGames:(NSSet *)value;
- (void)removeGames:(NSSet *)value;

- (void)addGameRoutesObject:(GameRouteObject *)value;
- (void)removeGameRoutesObject:(GameRouteObject *)value;
- (void)addGameRoutes:(NSSet *)value;
- (void)removeGameRoutes:(NSSet *)value;

- (void)addLocationsObject:(LocationObject *)value;
- (void)removeLocationsObject:(LocationObject *)value;
- (void)addLocations:(NSSet *)value;
- (void)removeLocations:(NSSet *)value;

@end

