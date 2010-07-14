//
//  FolderListTableViewController.m
//  CamFlow
//
//  Created by Alan Moore on 7/10/10.
//  Copyright 2010 Mount Diablo Software. All rights reserved.
//

#import "FolderListTableViewController_iPhone.h"
#import "AppDelegate_iPhone.h"
#import "CamFolderObject.h"
#import "CamFlowPhotoUploader.h"

@implementation FolderListTableViewController_iPhone
@synthesize folderType;
@synthesize currentFolder;

#pragma mark -
#pragma mark Initialization


- (id)initWithStyle:(UITableViewStyle)style andType:(FolderType) fType {
	folderType = fType;
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
		UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
																				   target:self
																				   action:@selector(insertNewObject:)];
		
		NSArray *array = [[NSArray alloc] initWithObjects:addButton, nil];	
		self.toolbarItems = array;
		self.navigationItem.rightBarButtonItem = self.editButtonItem;
		self.navigationController.toolbarHidden = NO;
		//self.navigationItem.leftBarButtonItem = self.editButtonItem;
		
		// setup tab bar controller
		switch(folderType)
		{
			case FolderType_CamMode:	
				self.tabBarItem.image = [UIImage imageNamed:@"86-camera.png"];
				self.tabBarItem.title = @"Camera";
				self.title = @"Camera";
				break;
			case FolderType_PlayMode:
				self.tabBarItem.image = [UIImage imageNamed:@"45-movie1.png"];
				self.tabBarItem.title = @"Play";
				self.title = @"Play";
				break;
		}
    }
    return self;
}


-(void) insertNewObject: (id) sender
{
	
}


#pragma mark -
#pragma mark View lifecycle

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (section == 0)
	{
		return 1;
	}
	else
	{
		AppDelegate_iPhone *ip = APPDELEGATE_IPHONE;
		return [[ip getMyFolders] count];
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	if (indexPath.section == 0)
	{
		if (self.folderType == FolderType_CamMode)
		{
			cell.textLabel.text = @"Please select a stream to save the camera images to";
		}
		else
		{
			cell.textLabel.text = @"Please select a stream to view";
		}
	}
	else
	{
		// Configure the cell...
		AppDelegate_iPhone *ip = APPDELEGATE_IPHONE;
		CamFolderObject *folder = [[ip getMyFolders ] objectAtIndex:indexPath.row];
		cell.textLabel.text = folder.folderName;
	}
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
	if (indexPath.section == 0)
	{
		return NO;
	}
    return YES;
}



/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.folderType == FolderType_CamMode)
	{
		AppDelegate_iPhone *ip = APPDELEGATE_IPHONE;
		CamFolderObject *folder = [[ip getMyFolders] objectAtIndex:indexPath.row];
		self.currentFolder = folder.folderName;
		UIImagePickerController *ic = [[UIImagePickerController alloc] init];
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
		{
			ic.sourceType = UIImagePickerControllerSourceTypeCamera;
			// Need to do a little bit more than this...!
		}
		else
		{
			ic.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		}
		ic.delegate = self;
		[self presentModalViewController:ic animated:YES];
	}
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark Image Picker Controller

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	NSLog(@"Picked image");
	[self dismissModalViewControllerAnimated:YES];
	UIImage *realImage = (UIImage *) [info valueForKey:UIImagePickerControllerOriginalImage];
	CamFlowPhotoUploader *cf = [[CamFlowPhotoUploader alloc] init];
	[cf uploadImage: realImage toFolder: self.currentFolder];
}

@end

