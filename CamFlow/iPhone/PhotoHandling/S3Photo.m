//
//  S3Photo.m
//  CamFlow
//
//  Created by Alan Moore on 7/15/10.
//  Copyright 2010 Mount Diablo Software. All rights reserved.
//

#import "S3Photo.h"
#import "ASIS3ObjectRequest.h"

@implementation S3Photo
@synthesize photoSource = _photoSource, size = _size, index = _index, caption = _caption;
@synthesize s3URL = _s3URL;
@synthesize s3ThumbURL = _s3ThumbURL;

-(id) initWithS3Image: (NSString *) s3 photoSource:(id<TTPhotoSource>) src
{
	[super init];
	self.photoSource = src;
	self.s3URL = s3;
	// Work out the thumbURL
	NSArray *parts = [s3 pathComponents];
	NSMutableArray *newParts = [parts mutableCopy];
	[newParts insertObject:@"thumb" atIndex:[newParts count]-1];
	self.s3ThumbURL = [NSString pathWithComponents:newParts];
	
	return self;
}

-(void) ensureURLLoaded
{
	if (_URL == nil)
	{
		ASIS3ObjectRequest *request = [ASIS3ObjectRequest requestWithBucket:@"camflow-images" key:self.s3URL];
		[request startSynchronous];
		NSData *imageData = request.responseData;
		UIImage *image = [UIImage imageWithData:imageData]; 
		NSString *url = [[TTURLCache sharedCache] storeTemporaryImage:image toDisk:YES];
		_URL = url;
	}
}

-(void) ensureThumbURLLoaded
{
	if (_thumbURL == nil)
	{
		ASIS3ObjectRequest *request = [ASIS3ObjectRequest requestWithBucket:@"camflow-images" key:self.s3ThumbURL];
		[request startSynchronous];
		NSData *imageData = request.responseData;
		UIImage *image = [UIImage imageWithData:imageData]; 
		NSString *url = [[TTURLCache sharedCache] storeTemporaryImage:image toDisk:YES];
		_thumbURL = url;
	}
}



- (NSString*)URLForVersion:(TTPhotoVersion)version {
	if (version == TTPhotoVersionLarge) {
		[self ensureURLLoaded];
		return _URL;
	} else if (version == TTPhotoVersionMedium) {
		[self ensureURLLoaded];
		return _URL;
	} else if (version == TTPhotoVersionSmall) {
		[self ensureThumbURLLoaded];
		return _thumbURL;
	} else if (version == TTPhotoVersionThumbnail) {
		[self ensureThumbURLLoaded];
		return _thumbURL;
	} else {
		return nil;
	}
}
@end
