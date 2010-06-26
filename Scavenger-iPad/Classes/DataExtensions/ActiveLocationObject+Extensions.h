//
//  ActiveLocationObject+Extensions.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/26/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActiveLocationObject.h"
#import "LocationObject.h"

@interface ActiveLocationObject(Extensions)
-(void) fireTowerAtLocation: (LocationObject *) loc;
@end
