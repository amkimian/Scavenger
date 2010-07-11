//
//  CamFolderObject.h
//  CamFlow
//
//  Created by Alan Moore on 7/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface CamFolderObject :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * takeUnits;
@property (nonatomic, retain) NSNumber * takeInterval;
@property (nonatomic, retain) NSString * folderName;
@property (nonatomic, retain) NSNumber * maxImages;

@end



