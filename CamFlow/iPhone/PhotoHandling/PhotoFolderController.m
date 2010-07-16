//
//  PhotoFolderController.m
//  CamFlow
//
//  Created by Alan Moore on 7/15/10.
//  Copyright 2010 Mount Diablo Software. All rights reserved.
//

#import "PhotoFolderController.h"
#import "ASIS3BucketRequest.h"
#import "PhotoFolderSource.h"
#import "S3Photo.h"

@implementation PhotoFolderController
@synthesize deviceID;
@synthesize folder;

-(id) initWithDevice:(NSString *) d andFolder:(NSString *) f
{
	[super init];
	self.deviceID = d;
	self.folder = f;
	
	// Now setup the array of photos
	[self setupPhotos];
	return self;
}

-(void) setupPhotos
{
	ASIS3BucketRequest *bRequest = [ASIS3BucketRequest requestWithBucket:@"camflow-images"];
	bRequest.prefix = [NSString stringWithFormat: @"%@/%@", self.deviceID, self.folder];
	bRequest.delimiter = @".jpg";
	
	[bRequest startSynchronous];
		
	NSMutableArray *photos = [[NSMutableArray alloc] init];
	PhotoFolderSource *source = [[PhotoFolderSource alloc] init];
	for(NSString *imageName in bRequest.commonPrefixes)
	{
		S3Photo *p = [[S3Photo alloc] initWithS3Image:imageName photoSource:source];
		[photos addObject:p];
		NSLog(@"Image url is %@", imageName);
	}
	
	for (int i = 0; i < photos.count; ++i) {
		id<TTPhoto> photo = [photos objectAtIndex:i];
		if ((NSNull*)photo != [NSNull null]) {
			photo.photoSource = source;
			photo.index = i;
		}
    }
	
	source.photos = photos;
	[self setPhotoSource: source];
}


@end
