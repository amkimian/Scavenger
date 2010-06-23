    //
//  ExpandableViewController.m
//  MDSLib
//
//  Created by Alan Moore on 6/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ExpandableViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation ExpandableViewController

-(void) awakeFromNib
{
	NSLog(@"Hello, here I am");	
	showingSmall = YES;
	largeSize = view.bounds.size;
	smallSize = view.bounds.size;
	smallSize.height = 50;
	CGRect bounds = view.bounds;
	bounds.size = smallSize;
	view.bounds = bounds;
	view.layer.shadowColor = [[UIColor grayColor] CGColor];
	view.layer.shadowOffset = CGSizeMake(10.0f, 10.0f);
	view.layer.shadowOpacity = 1.0f;
	view.layer.shadowRadius = 10.0f;
	view.layer.cornerRadius = 25;
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		showingSmall = YES;
		// Do we have the lower level views at this point?
		NSLog(@"Small view is %@", viewSmall);
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

/*
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
*/

- (void)dealloc {
    [super dealloc];
}

-(IBAction) toggle: (id) sender
{
	NSLog(@"Toggle clicked");
	[UIView beginAnimations:@"expander" context:nil];
	[UIView setAnimationDuration:0.75];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	
	if (showingSmall)
	{
		// Now show large
		CGRect bounds = view.bounds;
		bounds.size = largeSize;
		view.bounds = bounds;
		showingSmall = NO;
	}
	else
	{
		CGRect bounds = view.bounds;
		bounds.size = smallSize;
		view.bounds = bounds;
		showingSmall = YES;
	}
	[UIView commitAnimations];
}

+(void) _keepAtLinkTime
{
	
}
@end
