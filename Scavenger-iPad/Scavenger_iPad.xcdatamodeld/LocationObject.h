//
//  LocationObject.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class ActiveLocationObject;
@class GameObject;
@class GameRunObject;
@class LocationOrderObject;
@class QuestionObject;

@interface LocationObject :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * scoreInterval;
@property (nonatomic, retain) NSString * enterCommentary;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * affects;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * size;
@property (nonatomic, retain) NSString * exitCommentary;
@property (nonatomic, retain) NSNumber * visible;
@property (nonatomic, retain) NSNumber * locationType;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* activeInGame;
@property (nonatomic, retain) NSSet* visitedInGame;
@property (nonatomic, retain) NSSet* orderInLocationRoute;
@property (nonatomic, retain) QuestionObject * question;
@property (nonatomic, retain) GameObject * game;
@property (nonatomic, retain) NSSet* soughtInGame;

@end


@interface LocationObject (CoreDataGeneratedAccessors)
- (void)addActiveInGameObject:(ActiveLocationObject *)value;
- (void)removeActiveInGameObject:(ActiveLocationObject *)value;
- (void)addActiveInGame:(NSSet *)value;
- (void)removeActiveInGame:(NSSet *)value;

- (void)addVisitedInGameObject:(GameRunObject *)value;
- (void)removeVisitedInGameObject:(GameRunObject *)value;
- (void)addVisitedInGame:(NSSet *)value;
- (void)removeVisitedInGame:(NSSet *)value;

- (void)addOrderInLocationRouteObject:(LocationOrderObject *)value;
- (void)removeOrderInLocationRouteObject:(LocationOrderObject *)value;
- (void)addOrderInLocationRoute:(NSSet *)value;
- (void)removeOrderInLocationRoute:(NSSet *)value;

- (void)addSoughtInGameObject:(GameRunObject *)value;
- (void)removeSoughtInGameObject:(GameRunObject *)value;
- (void)addSoughtInGame:(NSSet *)value;
- (void)removeSoughtInGame:(NSSet *)value;

@end

