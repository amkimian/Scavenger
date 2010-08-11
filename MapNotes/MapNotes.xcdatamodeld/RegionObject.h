//
//  RegionObject.h
//  MapNotes
//
//  Created by Alan Moore on 8/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class LocationPointObject;
@class NoteObject;

@interface RegionObject :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * color;
@property (nonatomic, retain) NSSet* notes;
@property (nonatomic, retain) LocationPointObject * firstPoint;

@end


@interface RegionObject (CoreDataGeneratedAccessors)
- (void)addNotesObject:(NoteObject *)value;
- (void)removeNotesObject:(NoteObject *)value;
- (void)addNotes:(NSSet *)value;
- (void)removeNotes:(NSSet *)value;

@end

