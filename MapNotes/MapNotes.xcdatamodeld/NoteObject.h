//
//  NoteObject.h
//  MapNotes
//
//  Created by Alan Moore on 8/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class RegionObject;

@interface NoteObject :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * proximity;
@property (nonatomic, retain) NSSet* regions;

@end


@interface NoteObject (CoreDataGeneratedAccessors)
- (void)addRegionsObject:(RegionObject *)value;
- (void)removeRegionsObject:(RegionObject *)value;
- (void)addRegions:(NSSet *)value;
- (void)removeRegions:(NSSet *)value;

@end

