//
//  DeviceSettingsViewController.h
//  CamFlow
//
//  Created by Alan Moore on 7/14/10.
//  Copyright 2010 Mount Diablo Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"
#import <GameKit/GameKit.h>

@interface DeviceSettingsViewController  : TTTableViewController<GKPeerPickerControllerDelegate>  {

}

-(void) resetContent;
-(void) pairDevice;

@end
