// 
//  LocationObject.m
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LocationObject.h"

#import "ActiveLocationObject.h"
#import "GameObject.h"
#import "GameRunObject.h"
#import "LocationOrderObject.h"
#import "LocationPointObject.h"

@implementation LocationObject 

@dynamic maxLevel;
@dynamic level;
@dynamic visible;
@dynamic drift;
@dynamic driftSpeed;
@dynamic locationType;
@dynamic name;
@dynamic activeInGame;
@dynamic visitedInGame;
@dynamic firstPoint;
@dynamic orderInLocationRoute;
@dynamic game;
@dynamic soughtInGame;

@end
