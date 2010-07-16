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
	return self;
}

-(void) uploadImage: (UIImage *) image toFolder: (NSString *) folder
{
	// Step 1, add a watermark to this image (for now, resize)
	
	UIImage *resizedImage = [image resizedImage:CGSizeMake(100,100) interpolationQuality:kCGInterpolationDefault];
	
	// Step 2, upload to Amazon S3
	
	// The folder to upload will be DEVICE_ID/folder/[yyyymmdd.hhmmss].jpg
	
	
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"] autorelease]];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
	[dateFormatter setDateFormat:@"yyyyMMdd.HHmmss"];
	NSDate *now = [NSDate date];
	
	NSString *fileName = [dateFormatter stringFromDate:now];	
	
	NSData *thumbImageData = UIImageJPEGRepresentation(resizedImage, 90);
	NSData *realImageData = UIImageJPEGRepresentation(image, 90);
	
	// And upload that
	
	NSString *mainKey = [NSString stringWithFormat: @"%@/%@/%@.jpg", [UIDevice currentDevice].uniqueIdentifier, folder,fileName];
	NSString *thumbKey = [NSString stringWithFormat: @"%@/%@/thumb/%@.jpg", [UIDevice currentDevice].uniqueIdentifier, folder,fileName];

	ASIS3ObjectRequest *request = 
	[ASIS3ObjectRequest PUTRequestForData:realImageData withBucket:@"camflow-images" key:mainKey];
	[request startSynchronous];
	
	request = 
	[ASIS3ObjectRequest PUTRequestForData:thumbImageData withBucket:@"camflow-images" key:thumbKey];
	[request startSynchronous];
}


@end
