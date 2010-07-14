//
//  ViewedImageObject.h
//  CamFlow
//
//  Created by Alan Moore on 7/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class CamFolderObject;

@interface ViewedImageObject :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * viewed;
@property (nonatomic, retain) NSString * fileName;
@property (nonatomic, retain) CamFolderObject * folder;

@end



