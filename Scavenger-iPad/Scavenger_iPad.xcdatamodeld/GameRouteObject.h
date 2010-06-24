//
//  GameRouteObject.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class GameObject;
@class GameRunObject;
@class LocationOrderObject;

@interface GameRouteObject :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* inGameRun;
@property (nonatomic, retain) NSSet* locations;
@property (nonatomic, retain) GameObject * game;

@end


@interface GameRouteObject (CoreDataGeneratedAccessors)
- (void)addInGameRunObject:(GameRunObject *)value;
- (void)removeInGameRunObject:(GameRunObject *)value;
- (void)addInGameRun:(NSSet *)value;
- (void)removeInGameRun:(NSSet *)value;

- (void)addLocationsObject:(LocationOrderObject *)value;
- (void)removeLocationsObject:(LocationOrderObject *)value;
- (void)addLocations:(NSSet *)value;
- (void)removeLocations:(NSSet *)value;

@end

