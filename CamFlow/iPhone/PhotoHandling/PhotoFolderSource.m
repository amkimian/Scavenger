//
//  PhotoFolderSource.m
//  CamFlow
//
//  Created by Alan Moore on 7/15/10.
//  Copyright 2010 Mount Diablo Software. All rights reserved.
//

#import "PhotoFolderSource.h"


@implementation PhotoFolderSource
@synthesize title;
@synthesize photos = _photos;

- (NSInteger)numberOfPhotos {
	NSLog(@"Photo count");
	return _photos.count;
}

- (NSInteger)maxPhotoIndex {
	return _photos.count - 1;
}

- (id<TTPhoto>)photoAtIndex:(NSInteger)photoIndex {
	if (photoIndex < _photos.count) {
		id photo = [_photos objectAtIndex:photoIndex];
		if (photo == [NSNull null]) {
			return nil;
		} else {
			return photo;
		}
	} else {
		return nil;
	}
}

- (BOOL)isLoading {
	return NO;
}

- (BOOL)isLoaded {
	return YES;
}

@end
