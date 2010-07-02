//
//  AWSScavenger.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/29/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleDb.h"
#import "GameObject+Export.h"

@interface AWSScavenger : NSObject {
	SimpleDb *simpleDb;
}

-(void) listDomains;
- (void) listDomainsComplete:(NSMutableArray*) domains;
-(void) publishGame: (GameObject *) game;
-(void) unpublishGame: (GameObject *) game;
-(void) performSelect: (NSString *) query;
-(void) selectComplete:(NSMutableArray *) items;
-(void) addAttribute: (NSString *) name withValue: (NSString *) value intoArray: (NSMutableArray *) array;
-(void) pushGameToS3: (GameObject *) game withId: (NSString *) gameId;

@property(nonatomic, retain) SimpleDb *simpleDb;
@end
