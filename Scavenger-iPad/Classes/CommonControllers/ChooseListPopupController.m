//
//  ChooseListPopupController.m
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/17/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import "ChooseListPopupController.h"


@implementation ChooseListPopupController
@synthesize delegate;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	UITableView *tableView = [self tableView];
	CGRect bounds = tableView.bounds;
	bounds.size.width = 200;
	tableView.bounds = bounds;
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
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
   switch(section)
	{
		case 0:
			return 2;
		case 1:
			return 5;
		case 2:
			return 3;
	}
	return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch(section)
	{
		case 0:
			return @"Standard Locations";
		case 1:
			return @"Hazards";
		case 2:
			return @"Bonuses";
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
    
	switch(indexPath.section)
	{
		case 0:
		{
			switch(indexPath.row)
			{
				case 0:
					cell.textLabel.text =  @"Start";
					break;
				case 1:
					cell.textLabel.text = @"End";
					break;
			}
		}
		break;
		case 1:
		{
			switch(indexPath.row)
			{
				case 0:
					cell.textLabel.text = @"Radar";
					break;
				case 1:
					cell.textLabel.text = @"Find Hazard";
					break;
				case 2:
					cell.textLabel.text = @"Find Rally";
					break;
				case 3:
					cell.textLabel.text = @"Location Ping";
					break;
				case 4:
					cell.textLabel.text = @"Fix";
					break;
			}
		}
			break;
		case 2:
		{
			switch(indexPath.row)
			{
				case 0:
					cell.textLabel.text = @"Charge";
					break;
				case 1:
					cell.textLabel.text = @"Score";
					break;
				case 2:
					cell.textLabel.text = @"Fix";
					break;
			}
		}
			break;
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
	// Send to the delegate
	LocationType whichLocType = LTYPE_START;
	
	switch(indexPath.section)
	{
		case 0:
		{
			switch(indexPath.row)
			{
				case 0:
					whichLocType = LTYPE_START;
					break;
				case 1:
					whichLocType = LTYPE_END;
					break;
			}
		}
			break;
		case 1:
		{
			switch(indexPath.row)
			{
				case 0:
					whichLocType = LTYPE_HAZARD_RADAR;
					break;
				case 1:
					whichLocType = LTYPE_HAZARD_FIND_HAZARD;
					break;
				case 2:
					whichLocType = LTYPE_HAZARD_FIND_RALLY;
					break;
				case 3:
					whichLocType = LTYPE_HAZARD_LOC_PING;
					break;
				case 4:
					whichLocType = LTYPE_HAZARD_FIX;
					break;
			}
			break;
		}
		case 2:
		{
			switch(indexPath.row)
			{
				case 0:
					whichLocType = LTYPE_RALLY_CHARGE;
					break;
				case 1:
					whichLocType = LTYPE_RALLY_SCORE;
					break;
				case 2:
					whichLocType = LTYPE_RALLY_FIX;
					break;
			}
			break;
		}								
	}	
	
	[delegate didChoose:whichLocType from:self];
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


@end

