//
//  S3Photo.h
//  CamFlow
//
//  Created by Alan Moore on 7/15/10.
//  Copyright 2010 Mount Diablo Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"

@interface S3Photo : NSObject <TTPhoto> {
	id<TTPhotoSource> _photoSource;
	NSString* _s3URL;
	NSString* _thumbURL;
	NSString* _smallURL;
	NSString* _URL;
	CGSize _size;
	NSInteger _index;
	NSString* _caption;
}

@property(nonatomic, copy) NSString *s3URL;

-(id) initWithS3Image: (NSString *) s3URL photoSource:(id<TTPhotoSource>) src;
-(void) ensureLoaded;

@end
