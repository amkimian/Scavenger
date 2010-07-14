//
//  CameraFolderTableViewController.h
//  CamFlow
//
//  Created by Alan Moore on 7/14/10.
//  Copyright 2010 Mount Diablo Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"

@interface CameraFolderTableViewController : TTTableViewController {
	TTSectionedDataSource *sds;
}

@property(nonatomic, retain) TTSectionedDataSource *sds;
-(void) resetContent;
@end
