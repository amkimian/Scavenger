//
//  FolderPhotoSource.m
//  CamFlow
//
//  Created by Alan Moore on 7/13/10.
//  Copyright 2010 Mount Diablo Software. All rights reserved.
//

#import "FolderPhotoSource.h"


@implementation FolderPhotoSource
@synthesize title;
@synthesize numberOfPhotos;
@synthesize maxPhotoIndex;

-(id) init
{
	// Use S3 call to get the list of object names to load for the files
	// store them locally and then download in the background?
	
	self.title = @"Hello";
	self.numberOfPhotos = 5;
	self.maxPhotoIndex = 0;
	return self;
}


-(id<TTPhoto>) photoAtIndex:(int) index
{
	return nil;
}
@end
