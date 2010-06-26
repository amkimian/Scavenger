//
//  GameRunObject.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class ActiveLocationObject;
@class GameObject;
@class GameRouteObject;
@class HardwareObject;
@class LocationObject;
@class MissileObject;
@class PlayerLocationObject;

@interface GameRunObject :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * paused;
@property (nonatomic, retain) NSNumber * state;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSString * playerName;
@property (nonatomic, retain) NSNumber * bonus;
@property (nonatomic, retain) NSSet* visitedLocation;
@property (nonatomic, retain) NSSet* missiles;
@property (nonatomic, retain) NSSet* activeLocations;
@property (nonatomic, retain) GameRouteObject * gameRoute;
@property (nonatomic, retain) GameObject * game;
@property (nonatomic, retain) PlayerLocationObject * playerLocation;
@property (nonatomic, retain) LocationObject * seekingLocation;
@property (nonatomic, retain) NSSet* hardware;

@end


@interface GameRunObject (CoreDataGeneratedAccessors)
- (void)addVisitedLocationObject:(LocationObject *)value;
- (void)removeVisitedLocationObject:(LocationObject *)value;
- (void)addVisitedLocation:(NSSet *)value;
- (void)removeVisitedLocation:(NSSet *)value;

- (void)addMissilesObject:(MissileObject *)value;
- (void)removeMissilesObject:(MissileObject *)value;
- (void)addMissiles:(NSSet *)value;
- (void)removeMissiles:(NSSet *)value;

- (void)addActiveLocationsObject:(ActiveLocationObject *)value;
- (void)removeActiveLocationsObject:(ActiveLocationObject *)value;
- (void)addActiveLocations:(NSSet *)value;
- (void)removeActiveLocations:(NSSet *)value;

- (void)addHardwareObject:(HardwareObject *)value;
- (void)removeHardwareObject:(HardwareObject *)value;
- (void)addHardware:(NSSet *)value;
- (void)removeHardware:(NSSet *)value;

@end

