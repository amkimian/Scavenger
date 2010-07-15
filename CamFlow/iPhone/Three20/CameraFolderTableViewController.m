//
//  CameraFolderTableViewController.m
//  CamFlow
//
//  Created by Alan Moore on 7/14/10.
//  Copyright 2010 Mount Diablo Software. All rights reserved.
//

#import "CameraFolderTableViewController.h"
#import "AppDelegate_iPhone.h"
#import "CamFolderObject.h"

@implementation CameraFolderTableViewController
@synthesize sds;

-(id) init
{
	[super init];
	self.tabBarItem.image = [UIImage imageNamed:@"86-camera.png"];
	self.tabBarItem.title = @"Camera";
	self.title = @"Camera";		
	return self;
}

-(void) viewDidLoad
{
	
	self.sds = [[TTSectionedDataSource alloc] init];
	
	// Now create the sections and content for the table view
	[self resetContent];
}

-(void) resetContent
{
	NSMutableArray *sections = [[NSMutableArray alloc]  init];
	[sections addObject:@""];
	[sections addObject:@"Folders"];
	NSMutableArray *data = [[NSMutableArray alloc] init];
	NSMutableArray *topSection = [[NSMutableArray alloc] init];
	[topSection addObject:[TTTableStyledTextItem itemWithText:[TTStyledText textFromXHTML:@"Please select a <i>folder</i> to take pictures into:"]]];
	[data addObject:topSection];
	NSMutableArray *folders = [[NSMutableArray alloc] init];
	AppDelegate_iPhone *ip = APPDELEGATE_IPHONE;
	NSArray *objFolders = [ip getMyFolders];
	for(CamFolderObject *f in objFolders)
	{
		TTTableTextItem *item = [TTTableTextItem itemWithText:f.folderName URL:[NSString stringWithFormat:@"cf://camera/2",f.folderName]];
		[folders addObject:item];		
	}
	[data addObject:folders];
	self.dataSource = [TTSectionedDataSource dataSourceWithItems:data sections:sections];
	//self.dataSource = self.sds;
}

@end
