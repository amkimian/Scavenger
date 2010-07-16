//
//  PhotoFolderSource.h
//  CamFlow
//
//  Created by Alan Moore on 7/15/10.
//  Copyright 2010 Mount Diablo Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"

@interface PhotoFolderSource : TTURLRequestModel <TTPhotoSource> {
	NSMutableArray* _photos;
}
@property(nonatomic, retain) NSMutableArray *photos;

@end
