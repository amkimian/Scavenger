//
//  CamFlowPhotoUploader.m
//  CamFlow
//
//  Created by Alan Moore on 7/12/10.
//  Copyright 2010 Mount Diablo Software. All rights reserved.
//

#import "CamFlowPhotoUploader.h"
#import "UIImage+Resize.h"
#import "ASIS3Request.h"
#import "ASIS3ObjectRequest.h"

@implementation CamFlowPhotoUploader

-(id) init
{
	[ASIS3Request setSharedSecretAccessKey:@"o3Nw5NnnamrywCy7m6gIEBEQiKZrnROP/cxuvvLy"];
	[ASIS3Request setSharedAccessKey:@"0289QDXAHCXX0JH9GXR2"];	
	return self;
}

-(void) uploadImage: (UIImage *) image toFolder: (NSString *) folder
{
	// Step 1, add a watermark to this image (for now, resize)
	
	UIImage *resizedImage = [image resizedImage:CGSizeMake(100,100) interpolationQuality:kCGInterpolationDefault];
	
	// Step 2, upload to Amazon S3
	
	// The folder to upload will be DEVICE_ID/folder/[yyyymmdd.hhmmss].jpg
	
	NSData *imageData = UIImageJPEGRepresentation(resizedImage, 90);
	
	// And upload that
	
	NSString *key = [NSString stringWithFormat: @"%@/%@/fred.jpg", [UIDevice currentDevice].uniqueIdentifier, folder];
	
	ASIS3ObjectRequest *request = 
	[ASIS3ObjectRequest PUTRequestForData:imageData withBucket:@"camflow-images" key:key];
	[request startSynchronous];
	
}


@end
