//
//  DeviceFolderTableViewController.h
//  CamFlow
//
//  Created by Alan Moore on 7/13/10.
//  Copyright 2010 Mount Diablo Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PairedDeviceObject.h"

@interface DeviceFolderTableViewController : UITableViewController {
	PairedDeviceObject *pairedDevice;
}

@property(nonatomic, retain) PairedDeviceObject *pairedDevice;

- (id)initWithStyle:(UITableViewStyle)style andPairedDevice: (PairedDeviceObject *)pd;

@end
