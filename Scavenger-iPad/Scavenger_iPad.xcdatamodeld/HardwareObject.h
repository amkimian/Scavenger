//
//  HardwareObject.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class GameRunObject;

@interface HardwareObject :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * maxLevel;
@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSNumber * hasPower;
@property (nonatomic, retain) NSString * hudCode;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSNumber * powerUse;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) GameRunObject * inGame;

@end



