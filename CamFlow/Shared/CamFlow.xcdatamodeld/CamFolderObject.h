//
//  CamFolderObject.h
//  CamFlow
//
//  Created by Alan Moore on 7/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class PairedDeviceObject;
@class ViewedImageObject;

@interface CamFolderObject :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * takeInterval;
@property (nonatomic, retain) NSString * folderName;
@property (nonatomic, retain) NSNumber * maxImages;
@property (nonatomic, retain) NSNumber * takeUnits;
@property (nonatomic, retain) NSSet* viewedImage;
@property (nonatomic, retain) PairedDeviceObject * pairedDevice;

@end


@interface CamFolderObject (CoreDataGeneratedAccessors)
- (void)addViewedImageObject:(ViewedImageObject *)value;
- (void)removeViewedImageObject:(ViewedImageObject *)value;
- (void)addViewedImage:(NSSet *)value;
- (void)removeViewedImage:(NSSet *)value;

@end

