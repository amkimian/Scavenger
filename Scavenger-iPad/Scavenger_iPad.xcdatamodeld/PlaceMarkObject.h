//
//  PlaceMarkObject.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class GameObject;

@interface PlaceMarkObject :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * locality;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * administrativeArea;
@property (nonatomic, retain) NSString * subAdministrativeArea;
@property (nonatomic, retain) NSString * postalCode;
@property (nonatomic, retain) GameObject * game;

@end



