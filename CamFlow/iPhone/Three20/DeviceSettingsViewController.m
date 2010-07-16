//
//  DeviceSettingsViewController.m
//  CamFlow
//
//  Created by Alan Moore on 7/14/10.
//  Copyright 2010 Mount Diablo Software. All rights reserved.
//

#import "DeviceSettingsViewController.h"
#import "AppDelegate_iPhone.h"
#import "PairedDeviceObject.h"


@implementation DeviceSettingsViewController
-(id) init
{
	[super init];
	self.tabBarItem.image = [UIImage imageNamed:@"111-user.png"];
	self.tabBarItem.title = @"Settings";
	self.title = @"Settings";
	self.navigationItem.rightBarButtonItem =
	[[[UIBarButtonItem alloc] initWithTitle:@"Pair" style:UIBarButtonItemStyleBordered
									 target:self action:@selector(pairDevice)] autorelease];
	return self;
}


-(void) viewDidLoad
{
	[self resetContent];	
}

-(void) pairDevice
{
	// Pair up a new device
	GKPeerPickerController *peer = [[GKPeerPickerController alloc] init];
	peer.delegate = self;
	[peer show];
}

-(void) resetContent
{
	NSMutableArray *data = [[NSMutableArray alloc] init];
	AppDelegate_iPhone *ip = APPDELEGATE_IPHONE;
	NSArray *pairedDevices = ip.fetchedResultsController.fetchedObjects;
	for(PairedDeviceObject *f in pairedDevices)
	{
		TTTableSubtitleItem *item = [TTTableSubtitleItem itemWithText:f.name subtitle:f.deviceId URL:[NSString stringWithFormat:@"cf://settings/%@",f.name]];
		[data addObject:item];		
	}
	self.dataSource = [TTListDataSource dataSourceWithItems:data];
}

- (void)peerPickerController:(GKPeerPickerController *)picker didSelectConnectionType:(GKPeerPickerConnectionType)type
{
	
}

- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerIDtoSession:(GKSession *)session
{
	// This peer needs to be passed right back to the appDelegate
	// And we then navigate back.
	
	// A paired device is visible on the play menu and on the camera menu as a destination
	// In addition, when a paired device has exchanged its deviceID and well known name
	// that will become a potential target for an internet sharing of pictures
	// Here is how the picture sending works from a UI
	
	// Receiver selects the device from the Play menu - this show a photo view and sends data down the 
	// line to say "ready to receive pictures"
	
	// On the sender, the peer session state is used to control an icon next to the folder
	// in the camera folder mode. Only those which have the mode will get the URL to go into
	// picture sending mode.
	
	// Then, information on the device/folder in the picture mode will determine whether to send
	// the information back to the selected peers.

	// Paired devices disappear when we shut the application or the connection is lost
}

/*
- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type
{
	
}
 */

- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker
{
	
}

@end
