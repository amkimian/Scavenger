//
//  FolderListTableViewController.h
//  CamFlow
//
//  Created by Alan Moore on 7/10/10.
//  Copyright 2010 Mount Diablo Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FolderListTableViewController_iPhone : UITableViewController {
	BOOL camMode;
}

@property(nonatomic) BOOL camMode;
-(void) insertNewObject: (id) sender;
@end
