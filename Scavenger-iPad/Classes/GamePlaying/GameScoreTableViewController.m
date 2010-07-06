//
//  GameScoreTableViewController.m
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/23/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import "GameScoreTableViewController.h"
#import "HardwareObject.h"
#import "LocationObject+Extensions.h"
#import "GameObject+Extensions.h"


@implementation GameScoreTableViewController

#pragma mark -
#pragma mark Properties

@synthesize gameRun;

#pragma mark -
#pragma mark Setup

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
    }
    return self;
}


#pragma mark -
#pragma mark View lifecycle

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}


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
			return [gameRun.hardware count];
		case 2:
			return 1;
	}
	return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }

    switch(indexPath.section)
	{
		case 0:
			switch(indexPath.row)
		{
			case 0:
				cell.textLabel.text = @"Base Score";
				cell.detailTextLabel.text = [NSString stringWithFormat: @"%@", [gameRun.game getLocationOfType:LTYPE_START].level];
				break;
			case 1:
				cell.textLabel.text = @"Bonus";
				cell.detailTextLabel.text = [NSString stringWithFormat: @"%@", [gameRun.game getLocationOfType:LTYPE_END].maxLevel];
				break;
		}
			break;
		case 1:
		{
			HardwareObject *ho = [[gameRun.hardware allObjects] objectAtIndex: indexPath.row];
			cell.textLabel.text = ho.name;
			cell.detailTextLabel.text = [NSString stringWithFormat: @"%@", ho.level];
		}
			break;
		case 2:
			cell.textLabel.text = @"Total";
			cell.detailTextLabel.text = [NSString stringWithFormat: @"%@",[gameRun currentScore]];
			break;
	}
    // Configure the cell...
    
    return cell;
}





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

