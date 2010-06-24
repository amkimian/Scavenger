// 
//  GameRunObject.m
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameRunObject.h"

#import "ActiveLocationObject.h"
#import "GameObject.h"
#import "GameRouteObject.h"
#import "HardwareObject.h"
#import "LocationObject.h"
#import "PlayerLocationObject.h"

@implementation GameRunObject 

@dynamic paused;
@dynamic state;
@dynamic bonus;
@dynamic playerName;
@dynamic score;
@dynamic visitedLocation;
@dynamic activeLocations;
@dynamic gameRoute;
@dynamic game;
@dynamic playerLocation;
@dynamic seekingLocation;
@dynamic hardware;

@end
