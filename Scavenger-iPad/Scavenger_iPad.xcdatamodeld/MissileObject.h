//
//  MissileObject.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class GameRunObject;

@interface MissileObject :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSNumber * currentLatitude;
@property (nonatomic, retain) NSNumber * targetLatitude;
@property (nonatomic, retain) NSNumber * currentLongitude;
@property (nonatomic, retain) NSNumber * affects;
@property (nonatomic, retain) NSNumber * targetLongitude;
@property (nonatomic, retain) GameRunObject * gameRun;

@end



