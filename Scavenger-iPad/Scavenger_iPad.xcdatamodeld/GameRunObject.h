//
//  GameRunObject.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class ActiveLocationObject;
@class GameObject;
@class GameRouteObject;
@class HardwareObject;
@class LocationObject;
@class PlayerLocationObject;

@interface GameRunObject :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * paused;
@property (nonatomic, retain) NSNumber * state;
@property (nonatomic, retain) NSNumber * life;
@property (nonatomic, retain) NSNumber * power;
@property (nonatomic, retain) NSString * playerName;
@property (nonatomic, retain) NSNumber * shield;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) LocationObject * visitedLocation;
@property (nonatomic, retain) NSSet* activeLocations;
@property (nonatomic, retain) GameRouteObject * gameRoute;
@property (nonatomic, retain) GameObject * game;
@property (nonatomic, retain) PlayerLocationObject * playerLocation;
@property (nonatomic, retain) NSSet* hardware;
@property (nonatomic, retain) LocationObject * seekingLocation;

@end


@interface GameRunObject (CoreDataGeneratedAccessors)
- (void)addActiveLocationsObject:(ActiveLocationObject *)value;
- (void)removeActiveLocationsObject:(ActiveLocationObject *)value;
- (void)addActiveLocations:(NSSet *)value;
- (void)removeActiveLocations:(NSSet *)value;

- (void)addHardwareObject:(HardwareObject *)value;
- (void)removeHardwareObject:(HardwareObject *)value;
- (void)addHardware:(NSSet *)value;
- (void)removeHardware:(NSSet *)value;

@end

