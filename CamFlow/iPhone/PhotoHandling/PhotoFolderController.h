//
//  PhotoFolderController.h
//  CamFlow
//
//  Created by Alan Moore on 7/15/10.
//  Copyright 2010 Mount Diablo Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"

@interface PhotoFolderController : TTThumbsViewController {
	NSString *deviceID;
	NSString *folder;
}

-(id) initWithDevice:(NSString *) deviceId andFolder:(NSString *) folder;
-(void) setupPhotos;

@property(nonatomic, copy) NSString *deviceID;
@property(nonatomic, copy) NSString *folder;
@end
