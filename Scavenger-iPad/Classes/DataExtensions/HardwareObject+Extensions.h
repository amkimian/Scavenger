//
//  HardwareObject+Extensions.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/22/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HardwareObject.h"

@interface HardwareObject(Extensions)
-(float) getRadarRange;
-(UIColor *) getStatusColor;
-(float) getPercentage;
-(void) updateLevelBy: (float) amount;
-(UIImage *) getImage;
@end
