//
//  HardwareObject.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class GameRunObject;

@interface HardwareObject :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * powerUse;
@property (nonatomic, retain) NSNumber * damage;
@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) GameRunObject * inGame;

@end



