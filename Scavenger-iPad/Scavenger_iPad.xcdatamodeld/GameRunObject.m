// 
//  GameRunObject.m
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameRunObject.h"

#import "ActiveLocationObject.h"
#import "GameObject.h"
#import "GameRouteObject.h"
#import "HardwareObject.h"
#import "LocationObject.h"
#import "MissileObject.h"
#import "PlayerLocationObject.h"

@implementation GameRunObject 

@dynamic paused;
@dynamic state;
@dynamic score;
@dynamic playerName;
@dynamic bonus;
@dynamic visitedLocation;
@dynamic missiles;
@dynamic activeLocations;
@dynamic gameRoute;
@dynamic game;
@dynamic playerLocation;
@dynamic seekingLocation;
@dynamic hardware;

@end
