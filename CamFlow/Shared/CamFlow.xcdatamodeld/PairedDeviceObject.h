//
//  PairedDeviceObject.h
//  CamFlow
//
//  Created by Alan Moore on 7/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class CamFolderObject;

@interface PairedDeviceObject :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * isMe;
@property (nonatomic, retain) NSString * deviceId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* folders;

@end


@interface PairedDeviceObject (CoreDataGeneratedAccessors)
- (void)addFoldersObject:(CamFolderObject *)value;
- (void)removeFoldersObject:(CamFolderObject *)value;
- (void)addFolders:(NSSet *)value;
- (void)removeFolders:(NSSet *)value;

@end

