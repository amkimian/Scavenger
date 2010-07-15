//
//  ImagePickerController.m
//  CamFlow
//
//  Created by Alan Moore on 7/15/10.
//  Copyright 2010 Mount Diablo Software. All rights reserved.
//

#import "ImagePickerController.h"


@implementation ImagePickerController

-(id) initWithMode: (int) mode
{
	// Basically set me up depending on mode
	// Mode == 1   (Camera)
	// Mode == 2   (Photo Library)
	[super init];
	if (mode == 1)
	{
		self.sourceType = UIImagePickerControllerSourceTypeCamera;	
	}
	else
	{
		self.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	}
	return self;
}

@end
