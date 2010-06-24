//
//  LocationObject.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class ActiveLocationObject;
@class GameObject;
@class GameRunObject;
@class LocationOrderObject;
@class LocationPointObject;

@interface LocationObject :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * maxLevel;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSNumber * visible;
@property (nonatomic, retain) NSNumber * locationType;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* activeInGame;
@property (nonatomic, retain) GameRunObject * visitedInGame;
@property (nonatomic, retain) LocationPointObject * firstPoint;
@property (nonatomic, retain) NSSet* orderInLocationRoute;
@property (nonatomic, retain) GameObject * game;
@property (nonatomic, retain) NSSet* soughtInGame;

@end


@interface LocationObject (CoreDataGeneratedAccessors)
- (void)addActiveInGameObject:(ActiveLocationObject *)value;
- (void)removeActiveInGameObject:(ActiveLocationObject *)value;
- (void)addActiveInGame:(NSSet *)value;
- (void)removeActiveInGame:(NSSet *)value;

- (void)addOrderInLocationRouteObject:(LocationOrderObject *)value;
- (void)removeOrderInLocationRouteObject:(LocationOrderObject *)value;
- (void)addOrderInLocationRoute:(NSSet *)value;
- (void)removeOrderInLocationRoute:(NSSet *)value;

- (void)addSoughtInGameObject:(GameRunObject *)value;
- (void)removeSoughtInGameObject:(GameRunObject *)value;
- (void)addSoughtInGame:(NSSet *)value;
- (void)removeSoughtInGame:(NSSet *)value;

@end

