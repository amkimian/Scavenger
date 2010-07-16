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

-(id) initWithS3Image: (NSString *) s3 photoSource:(id<TTPhotoSource>) src
{
	[super init];
	self.photoSource = src;
	self.s3URL = s3;
	return self;
}

-(void) ensureLoaded
{
	if (_URL == nil)
	{
		ASIS3ObjectRequest *request = [ASIS3ObjectRequest requestWithBucket:@"camflow-images" key:self.s3URL];
		[request startSynchronous];
		NSData *imageData = request.responseData;
		UIImage *image = [UIImage imageWithData:imageData]; 
		NSString *url = [[TTURLCache sharedCache] storeTemporaryImage:image toDisk:YES];
		_URL = _smallURL = _thumbURL = url;
	}
}


- (NSString*)URLForVersion:(TTPhotoVersion)version {
	[self ensureLoaded];
	return _URL;
	if (version == TTPhotoVersionLarge) {
		return _URL;
	} else if (version == TTPhotoVersionMedium) {
		return _URL;
	} else if (version == TTPhotoVersionSmall) {
		return _smallURL;
	} else if (version == TTPhotoVersionThumbnail) {
		return _thumbURL;
	} else {
		return nil;
	}
}
@end
