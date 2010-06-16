//
//  ActiveLocationObject.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class GameRunObject;
@class LocationObject;

@interface ActiveLocationObject :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSNumber * currentAmount;
@property (nonatomic, retain) NSNumber * amountRate;
@property (nonatomic, retain) NSNumber * targetModifies;
@property (nonatomic, retain) NSNumber * maxAmount;
@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) LocationObject * location;
@property (nonatomic, retain) GameRunObject * gameRun;

@end



