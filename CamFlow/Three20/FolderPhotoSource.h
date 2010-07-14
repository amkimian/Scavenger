//
//  FolderPhotoSource.h
//  CamFlow
//
//  Created by Alan Moore on 7/13/10.
//  Copyright 2010 Mount Diablo Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"

@interface FolderPhotoSource : TTModel<TTPhotoSource> {
	NSString *title;
	NSInteger numberOfPhotos;
	NSInteger maxPhotoIndex;
}

@property(nonatomic, copy) NSString *title;
@property(nonatomic) NSInteger numberOfPhotos;
@property(nonatomic) NSInteger maxPhotoIndex;

-(id<TTPhoto>) photoAtIndex:(int) index;

@end
