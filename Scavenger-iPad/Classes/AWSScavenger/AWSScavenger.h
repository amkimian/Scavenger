//
//  AWSScavenger.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/29/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleDb.h"

@interface AWSScavenger : NSObject {
	SimpleDb *simpleDb;
}

-(void) listDomains;
- (void) listDomainsComplete:(NSMutableArray*) domains;

@property(nonatomic, retain) SimpleDb *simpleDb;
@end