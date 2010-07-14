//
//  DeviceListViewController.m
//  CamFlow
//
//  Created by Alan Moore on 7/14/10.
//  Copyright 2010 Mount Diablo Software. All rights reserved.
//

#import "DeviceListViewController.h"
#import "AppDelegate_iPhone.h"
#import "PairedDeviceObject.h"

@implementation DeviceListViewController
-(void) viewDidLoad
{
	self.tabBarItem.image = [UIImage imageNamed:@"45-movie1.png"];
	self.tabBarItem.title = @"Play";
	self.title = @"Play";
	[self resetContent];
	
}

-(void) resetContent
{
	NSMutableArray *data = [[NSMutableArray alloc] init];
	AppDelegate_iPhone *ip = APPDELEGATE_IPHONE;
	NSArray *pairedDevices = ip.fetchedResultsController.fetchedObjects;
	for(PairedDeviceObject *f in pairedDevices)
	{
		TTTableTextItem *item = [TTTableTextItem itemWithText:f.name URL:[NSString stringWithFormat:@"cf://viewer/%@",f.name]];
		[data addObject:item];		
	}
	self.dataSource = [TTListDataSource dataSourceWithItems:data];
}

@end

