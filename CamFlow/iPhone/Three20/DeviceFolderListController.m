//
//  DeviceFolderListController.m
//  CamFlow
//
//  Created by Alan Moore on 7/14/10.
//  Copyright 2010 Mount Diablo Software. All rights reserved.
//

#import "DeviceFolderListController.h"
#import "AppDelegate_iPhone.h"
#import "PairedDeviceObject.h"
#import "CamFolderObject.h"

@implementation DeviceFolderListController

-(id) initWithDevice:(NSString *) deviceId
{
	  if (self = [super init]) {
		  
	// Setup the data source by looking for this device Id information
	
		  AppDelegate_iPhone *ip = APPDELEGATE_IPHONE;	
		  NSArray *devices = ip.fetchedResultsController.fetchedObjects;
		  for(PairedDeviceObject *pd in devices)
		  {
			if ([pd.name isEqualToString:deviceId])
			{
				[self setupFrom: pd];
			}
		}
	  }
	return self;
}

-(void) setupFrom: (PairedDeviceObject *) pd
{
	self.title = pd.name;
	NSMutableArray *folders = [[NSMutableArray alloc] init];
	for(CamFolderObject *f in [pd.folders allObjects])
	{
		TTTableTextItem *item = [TTTableTextItem itemWithText:f.folderName URL:[NSString stringWithFormat:@"cf://viewer/%@/%@",pd.name,f.folderName]];
		[folders addObject:item];			
	}
	self.dataSource = [TTListDataSource dataSourceWithItems:folders];
}

@end
