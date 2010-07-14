//
//  DeviceFolderListController.h
//  CamFlow
//
//  Created by Alan Moore on 7/14/10.
//  Copyright 2010 Mount Diablo Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"
#import "PairedDeviceObject.h"

@interface DeviceFolderListController : TTTableViewController {

}

-(id) initWithDevice:(NSString *) deviceId;
-(void) setupFrom: (PairedDeviceObject *) pd;

@end
