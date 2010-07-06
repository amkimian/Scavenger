//
//  LocationObject+Export.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/24/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationObject.h"

@interface LocationObject(Export)
-(NSDictionary *)getCopyAsExportDictionary;
+(LocationObject *) newFromExportDictionary: (NSDictionary *) dict inManagedObjectContext: (NSManagedObjectContext *) context;
@end
