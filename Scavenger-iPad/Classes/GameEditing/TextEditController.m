    //
//  TextEditController.m
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/17/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import "TextEditController.h"
#import <QuartzCore/QuartzCore.h>

@implementation TextEditController

#pragma mark -
#pragma mark Properties

@synthesize location;
@synthesize tagToEdit;
@synthesize labelText;

#pragma mark -
#pragma mark View Lifecycle

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
	return YES;
}

- (void)textViewDidEndEditing:(UITextView *)tView
{
	[location setValue:tView.text forKey:tagToEdit];	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	NSString *value = [location valueForKey:tagToEdit];
	textView.text = value;
	textView.layer.cornerRadius = 8;
	label.text = labelText;
}

-(IBAction) didEndEdit: (id) sender
{
	[location setValue:textView.text forKey:tagToEdit];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
