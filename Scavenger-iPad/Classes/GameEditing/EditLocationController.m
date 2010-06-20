//
//  EditLocationController.m
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/17/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import "EditLocationController.h"
#import "TextEditController.h"

@implementation EditLocationController
@synthesize location;
@synthesize delegate;

#pragma mark -
#pragma mark Initialization


- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
		keyboardShown = NO;
		self.title = @"Edit Location";
    }
    return self;
}


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																				target:self
																			   action:@selector(doneEditing)];
	
	self.navigationItem.rightBarButtonItem = doneButton;
	[doneButton release];
}

-(void) doneEditing
{
	[delegate editLocationDidFinishEditing:self];
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
    return 4;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    switch(section)
	{
		case 0:
			return 2;
		case 1:
			return 2;
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
			return @"General";
		case 1:
			return @"Effect";
		case 2:
			return @"Commentary";
	}
	return nil;
}

-(UnitsEditCell *) getUnitsCell
{
	static NSString *CellIdentifier = @"UnitCell";
	UnitsEditCell *cell = (UnitsEditCell *) [[self tableView] dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[[UnitsEditCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
	}
	cell.delegate = self;
	return cell;
}

-(UITableViewCell *) getStandardCell
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
	return cell;
}

-(UITableViewCell *) getSubtitleCell
{
    static NSString *CellIdentifier = @"SubCell";
    
    UITableViewCell *cell = [[self tableView] dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
	return cell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = nil;
	
	switch(indexPath.section)
	{
		case 0:
			switch(indexPath.row)
			{
			case 0:
				if (!location.name)
				{
					location.name = @"Name";
				}
					UnitsEditCell *unitsCell = [self getUnitsCell];
					[unitsCell setLabelText: @"Name"];
					[unitsCell setUnitsText:@""];
					unitsCell.textField.text = location.name;
					unitsCell.tag = @"name";
					cell = unitsCell;
					break;
			case 1:
					cell = [self getStandardCell];
					cell.textLabel.text = @"Location Type";
					cell.detailTextLabel.text = [location locationTypeString];
					break;
			}
			break;
		case 1: // Effect
			switch(indexPath.row)
			{
				case 0:
				{
					UnitsEditCell *unitsCell = [self getUnitsCell];
					[unitsCell setLabelText:@"Amount"];
					[unitsCell setUnitsText:@"points"];
					unitsCell.textField.text = [NSString stringWithFormat: @"%d", [location.score intValue]];
					unitsCell.tag = @"score";
					unitsCell.textField.keyboardType = UIKeyboardTypePhonePad;
					cell = unitsCell;
				}
					break;
				case 1:
				{
					UnitsEditCell *unitsCell = [self getUnitsCell];
					[unitsCell setLabelText:@"Rate"];
					[unitsCell setUnitsText:@"points"];
					unitsCell.textField.text = [NSString stringWithFormat:@"%d", [location.scoreInterval intValue]];
					unitsCell.textField.keyboardType = UIKeyboardTypePhonePad;
					unitsCell.tag = @"scoreInterval";
					cell = unitsCell;
				}
					break;
			}
			break;
		case 2: // Commentary
			cell = [self getSubtitleCell];
			cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
			switch(indexPath.row)
			{
				case 0:
					cell.textLabel.text = @"Enter commentary";
					cell.detailTextLabel.text = @"Text shown when you enter the location";
					break;
				case 1:
					cell.textLabel.text = @"Exit commentary";
					cell.detailTextLabel.text = @"Text shown when you leave the location";
					break;
				case 2:
					cell.textLabel.text = @"Question";
					cell.detailTextLabel.text = @"The question that must be answered";
					break;
			}
			break;
	}	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void) editableCellDidBeginEditing: (UnitsEditCell *) cell
{
	if (!keyboardShown)
	{
		// animate resizing the table to fit the keyboard
		[UIView beginAnimations:nil context:NULL]; // begin animation block
		[UIView setAnimationDuration:0.25]; // set the animation duration
		[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
		CGRect frame = [self tableView].frame; // get the frame of the table
		frame.size.height -= KEYBOARD_HEIGHT; // subtract from the height
		[[self tableView] setFrame:frame]; // apply the new frame
		[UIView commitAnimations]; // end animation block
	} // end if
	
	keyboardShown = YES; // the keyboard appears on the screen
	
	// get the index path for the selected cell
	NSIndexPath *path = [[self tableView] indexPathForCell:cell];
	
	// scroll the table so that the selected cell is at the top
	NSLog(@"Scrolling table to show cell");
	[[self tableView] scrollToRowAtIndexPath:path atScrollPosition:
	 UITableViewScrollPositionTop animated:YES];	
}

-(void) editableCellDidEndEditing: (UnitsEditCell *) cell
{
	NSString *newText = cell.textField.text;
	
	// Use the tag on the cell to determine what to change
	
	// This will currently always be the size
	
	if ([cell.tag isEqualToString:@"name"])
	{
		[location setValue:newText forKey:cell.tag];
	}
	else
	{
		[location setValue:[NSNumber numberWithFloat: [newText floatValue]] forKey:cell.tag];
	}
	//[[NSNotificationCenter defaultCenter] postNotificationName:@"locationDataChanged" object:self];	
}

-(void) editableCellDidEndOnExit: (UnitsEditCell *) cell
{
	// resize the table to fit the keyboard
	CGRect frame = [self tableView].frame; // get the frame of the table
	frame.size.height += KEYBOARD_HEIGHT; // subtract from the height
	[[self tableView] setFrame:frame]; // apply the new frame	
	keyboardShown = NO; // hide the keyboard	
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
		if (indexPath.section == 3)
		{
			if (indexPath.row == 0)
			{
				TextEditController *controller = [[TextEditController alloc] initWithNibName:nil bundle:nil];
				controller.tagToEdit = @"enterCommentary";
				controller.location = location;
				controller.labelText = @"Commentary when entering location";
				[[self navigationController] pushViewController: controller animated:YES];
			}
			else if (indexPath.row == 1)
			{
				TextEditController *controller = [[TextEditController alloc] initWithNibName:nil bundle:nil];
				controller.tagToEdit = @"exitCommentary";
				controller.location = location;
				controller.labelText = @"Commentary when leaving location";
				[[self navigationController] pushViewController: controller animated:YES];
			}
		}
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
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
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

