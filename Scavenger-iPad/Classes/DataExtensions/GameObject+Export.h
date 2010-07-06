//
//  GameObject+Export.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/24/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameObject.h"

/**
 * An extension to handle how to export and import GameObjects
 * (i.e. convert to propList xml and convert back
 */

@interface GameObject(Export)
-(NSDictionary *)getCopyAsExportDictionary;
+(GameObject *) newFromExportDictionary: (NSDictionary *) dict inManagedObjectContext: (NSManagedObjectContext *) context;
@end
