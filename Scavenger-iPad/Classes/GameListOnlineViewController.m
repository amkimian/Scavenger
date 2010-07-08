//
//  GameListOnlineViewController.m
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/29/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import "GameListOnlineViewController.h"
#import "MenuPopupController.h"
#import "Scavenger_iPadAppDelegate.h"

@implementation GameListOnlineViewController
@synthesize rootController;
@synthesize placemark;
@synthesize geocoder;
@synthesize currentGame;
@synthesize popOver;
@synthesize awsScavenger;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	self.title = @"Games";
	locationTools = [[LocationTools alloc] init];
	Scavenger_iPadAppDelegate *ad = (Scavenger_iPadAppDelegate *) [UIApplication sharedApplication].delegate;

	locationTools.coordinate = ad.currentLocation.coordinate;
	locationTools.delegate = self;
	self.awsScavenger = [[AWSScavenger alloc] init];
	self.awsScavenger.delegate = self;
	[locationTools resolveGeocode];
}

-(void) locationFound
{
	[mainTable reloadData];
}

-(IBAction) query:(id) sender
{
	MenuPopupController *controller = [[MenuPopupController alloc] initWithStyle:UITableViewStyleGrouped];
	controller.sectionTitle = @"Search Criteria";
	NSMutableArray *array = [[NSMutableArray alloc] init];
	[array addObject:locationTools.postalCode];
	[array addObject:locationTools.locality];
	[array addObject:locationTools.administrativeArea];
	[array addObject:locationTools.country];

	controller.menuStrings = array;	
	controller.delegate = self;
	controller.tag = 1;
	
	self.popOver = [[UIPopoverController alloc] initWithContentViewController:controller];
	//[self.popOver setPopoverContentSize:controller.view.bounds.size];
	[self.popOver presentPopoverFromBarButtonItem:(UIBarButtonItem *) sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	[controller release];

}

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


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	switch(section)
	{
		case 0:
			return [[self.rootController.fetchedResultsController fetchedObjects] count];
		case 1:
			return [awsScavenger.searchResults count];
	}
	return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch(section)
	{
		case 0:
			return @"Local Games";
		case 2:
			return @"Remote Games";
	}
	return nil;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
	switch(indexPath.section)
	{
		case 0:
		{
			GameObject *game = (GameObject *) [[self.rootController.fetchedResultsController fetchedObjects] objectAtIndex:indexPath.row];
			cell.textLabel.text = game.name;
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			break;
		}
		case 1:
		{
			SimpleDbItem *item = [awsScavenger.searchResults objectAtIndex:indexPath.row];
			cell.textLabel.text = item.name;
			break;			
		}
	}
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


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
 // Make the detail view center on this game
	[rootController centerOnGame: (GameObject *) [[self.rootController.fetchedResultsController fetchedObjects] objectAtIndex:indexPath.row]];	
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


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	// Clicked on detail view for local game
	if (indexPath.section == 0)
	{
		NSLog(@"Selected local game");
		MenuPopupController *controller = [[MenuPopupController alloc] initWithNibName:nil bundle:nil];
		controller.delegate = self;
		self.currentGame = (GameObject *) [[self.rootController.fetchedResultsController fetchedObjects] objectAtIndex: indexPath.row];	
		controller.menuStrings = [[NSArray alloc] initWithObjects:@"Publish",@"Unpublish",@"Copy (Test)", nil];
		controller.modalPresentationStyle = UIModalPresentationFormSheet;
		[self presentModalViewController:controller animated:YES];
		//self.popOver = [[UIPopoverController alloc] initWithContentViewController:controller];
		//[self.popOver setPopoverContentSize:controller.view.bounds.size];
//		UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];		
//		[self.popOver presentPopoverFromRect:[cell convertRect:button.frame fromView:button] inView:cell permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];		
	}	
}

-(void) didSelectItem: (NSUInteger) item from:(MenuPopupController *) sender
{
	if (sender.tag == 1)
	{
		[self.popOver dismissPopoverAnimated:YES];
		// Do something with the query selection
		switch(item)
		{
			case 0:
				// Postal code
			{
				NSString *query = [NSString stringWithFormat:@"select * from scgames where PostalCode='%@'", locationTools.postalCode];
				[awsScavenger performSelect:query];
			}
				break;
			case 1:
				// City
			{
				NSString *query = [NSString stringWithFormat:@"select * from scgames where Locality='%@'", locationTools.locality];
				[awsScavenger performSelect:query];
			}
				break;
			case 2:
				// State
			{
				NSString *query = [NSString stringWithFormat:@"select * from scgames where AdminArea='%@'", locationTools.administrativeArea];
				[awsScavenger performSelect:query];
			}
				break;
			case 3:
				// Country
			{
				NSString *query = [NSString stringWithFormat:@"select * from scgames where Country='%@'", locationTools.country];
				[awsScavenger performSelect:query];
			}
			break;		
		}
	}
	else
	{
		switch(item)
		{
			case 0:
				// Publish
				[awsScavenger publishGame:self.currentGame];
				break;
			case 1:
				// Unpublish
				[awsScavenger unpublishGame:self.currentGame];
				break;
			case 2:
				// Copy (test)
				[awsScavenger copyGameTest:self.currentGame];
				break;
		}
		[self dismissModalViewControllerAnimated:YES];
	}
}

-(void) awsDataChanged
{
	[mainTable reloadData];
}

@end

