//
//  FolderListTableViewController.h
//  CamFlow
//
//  Created by Alan Moore on 7/10/10.
//  Copyright 2010 Mount Diablo Software. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
	FolderType_CamMode,
	FolderType_PlayMode
} FolderType;

@interface FolderListTableViewController_iPhone : UITableViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
	FolderType folderType;
	NSString *currentFolder;
}

@property(nonatomic) FolderType folderType;
@property(nonatomic, retain) NSString *currentFolder;

-(void) insertNewObject: (id) sender;
-(id) initWithStyle:(UITableViewStyle)style andType:(FolderType) fType;
@end
