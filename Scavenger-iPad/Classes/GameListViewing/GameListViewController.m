    //
//  GameListViewController.m
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/16/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import "GameListViewController.h"
#import "MapTypePopupController.h"
#import "GameEditViewController.h"
#import "MenuPopupController.h"
#import "GamePlayViewController.h"
#import "GameObject.h"
#import "GameObject+Export.h"
#import "GameListOnlineViewController.h"
#import "AWSScavenger.h"
#import "Scavenger_iPadAppDelegate.h"

@implementation GameListViewController
@synthesize managedObjectContext;
@synthesize fetchedResultsController;
@synthesize popOver;
@synthesize currentGame;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

-(void) locationChangeNotification: (NSNotification *) n
{
	if (centerOnLocationUpdates == YES)
	{
		Scavenger_iPadAppDelegate *ad = (Scavenger_iPadAppDelegate *) [UIApplication sharedApplication].delegate;
		MKCoordinateRegion region = MKCoordinateRegionMake(ad.currentLocation.coordinate,
													   MKCoordinateSpanMake(0.01f, 0.01f));
		[mapView setRegion:region animated:YES];
		centerOnLocationUpdates = NO;
	}
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	// Fetch the games and create the annotations...
	self.title = @"";
	centerOnLocationUpdates = YES;
	
	// Register for location updates
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationChangeNotification:) name:@"locationChanged" object:nil];
	
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
																			   target:self
																			   action:@selector(insertNewObject)];
	
	self.navigationItem.rightBarButtonItem = addButton;
	[addButton release];
	
	// Also setup the toolbar items (we do it this way programattically...)
	
	UIBarButtonItem *mapButton = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStyleBordered target:self action:@selector(chooseMapType:)];
	UIBarButtonItem *flexibleButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																			   target:nil
																			   action:nil];
	
	NSArray *array = [[NSArray alloc] initWithObjects:flexibleButton,mapButton, nil];	
	self.toolbarItems = array;
	
	[mapButton release];
	[flexibleButton release];
	[array release];
	
	// Now need to fetch the games and put out the annotations...
	NSError *error;
	
	if (![[self fetchedResultsController] performFetch: &error])
	{
		NSLog(@"Could not load data: %@", [error description ]);
	}
    [super viewDidLoad];
	[self addAllAnnotations];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


#pragma -
#pragma buttonActions

-(IBAction) chooseMapType: (id) sender
{
	MapTypePopupController *mapTypeController = [[MapTypePopupController alloc] initWithNibName:nil bundle:nil];
	mapTypeController.delegate = self;
	mapTypeController.mapType = mapView.mapType;

	self.popOver = [[UIPopoverController alloc] initWithContentViewController:mapTypeController];
	[self.popOver setPopoverContentSize:mapTypeController.view.bounds.size];
	[self.popOver presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	
	[mapTypeController release];
}


-(void) changeMapType: (MKMapType) mapType from:(MapTypePopupController *) sender
{
	mapView.mapType = mapType;
	[self.popOver dismissPopoverAnimated:YES];
	self.popOver = nil;
}

-(void) insertNewObject
{
	GetTextPopupController *controller = [[GetTextPopupController alloc] initWithNibName:nil bundle:nil];
	controller.delegate = self;
	self.popOver = [[UIPopoverController alloc] initWithContentViewController:controller];
	[self.popOver setPopoverContentSize:controller.view.bounds.size];
	[self.popOver presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	[controller release];
}

-(void) textChangedFrom: (GetTextPopupController *) sender
{
	// Create a game, with a location (of type map) centered on the current view of the map
	// Popup an edit control to get the text for the name of the game, then insert and add the annotation to the screen
	// To edit this new game a user will select the annotation and click edit (or do we simply push the edit control directly here?)
	
	NSLog(@"Add new game");
	
	NSEntityDescription *edesc = [NSEntityDescription entityForName:@"Game" inManagedObjectContext:managedObjectContext];
	GameObject *game = [[GameObject alloc] initWithEntity:edesc insertIntoManagedObjectContext:managedObjectContext];
	game.name = sender.textField.text;

	[self.popOver dismissPopoverAnimated:YES];
	self.popOver = nil;

	[[game newLocationOfType:LTYPE_START at:mapView.centerCoordinate] release];
	
	[self addGameAnnotation: game];
}

/**
 * Add an annotation to the mapView for this game
 */

-(void) addGameAnnotation: (GameObject *) game
{
	[mapView addAnnotation:game];
}

-(void) reloadData
{
	NSError *error;
	
	if (![[self fetchedResultsController] performFetch: &error])
	{
		NSLog(@"Could not load data: %@", [error description ]);
	}	
}

-(void) addAllAnnotations
{
	[self reloadData];
	[mapView removeAnnotations:[mapView annotations]];
	NSArray *games = [self fetchedResultsController].fetchedObjects;
	for(GameObject *g in games)
	{
		[self addGameAnnotation: g];
	}
}

- (NSFetchedResultsController *)fetchedResultsController
{
	// if a fetched results controller has already been initialized
	if (fetchedResultsController != nil)
		return fetchedResultsController; // return the controller
	
	// create the fetch request for the entity
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	
	// edit the entity name as appropriate.
	NSEntityDescription *entity = [NSEntityDescription entityForName:
								   @"Game" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	// edit the sort key as appropriate.
	NSSortDescriptor *sortDescriptor =
	[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	NSArray *sortDescriptors =
	[[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	// edit the section name key path and cache name if appropriate
	// nil for section name key path means "no sections"
	NSFetchedResultsController *aFetchedResultsController =
	[[NSFetchedResultsController alloc] initWithFetchRequest:
	 fetchRequest managedObjectContext:managedObjectContext
										  sectionNameKeyPath:nil cacheName:@"Root"];
	
	aFetchedResultsController.delegate = self;
	self.fetchedResultsController = aFetchedResultsController;
	
	[aFetchedResultsController release]; // release temporary controller
	[fetchRequest release]; // release fetchRequest NSFetcheRequest
	[sortDescriptor release]; // release sortDescriptor NSSortDescriptor
	[sortDescriptors release]; // release sortDescriptor NSArray
	
	return fetchedResultsController;
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

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
      // try to dequeue an existing pin view first
        static NSString* BridgeAnnotationIdentifier = @"bridgeAnnotationIdentifier";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)
		[mapView dequeueReusableAnnotationViewWithIdentifier:BridgeAnnotationIdentifier];
        if (!pinView)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView* customPinView = [[[MKPinAnnotationView alloc]
												   initWithAnnotation:annotation reuseIdentifier:BridgeAnnotationIdentifier] autorelease];
			GameObject *g = (GameObject *) annotation;
			if ([g canResume])
			{
				customPinView.pinColor = MKPinAnnotationColorGreen;
			}
			else
			{
				customPinView.pinColor = MKPinAnnotationColorPurple;
			}
			
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            
            // add a detail disclosure button to the callout which will open a new view controller page
            //
            // note: you can assign a specific call out accessory view, or as MKMapViewDelegate you can implement:
            //  - (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;
            //
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            //[rightButton addTarget:self
            //                action:@selector(showDetails:)
            //      forControlEvents:UIControlEventTouchUpInside];
            customPinView.rightCalloutAccessoryView = rightButton;
			
            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	NSLog(@"Disclosure tapped");
	MenuPopupController *controller = [[MenuPopupController alloc] initWithNibName:nil bundle:nil];
	controller.delegate = self;
	self.currentGame = (GameObject *) view.annotation;	
	if ([currentGame canResume])
	{
		controller.menuStrings = [[NSArray alloc] initWithObjects:@"Resume",@"Play",@"Edit",@"Transmit",@"Mail",@"Delete", nil];
	}
	else
	{
		controller.menuStrings = [[NSArray alloc] initWithObjects:@"Play",@"Edit",@"Transmit",@"Mail",@"Delete", nil];
	}
	
	self.popOver = [[UIPopoverController alloc] initWithContentViewController:controller];
	[self.popOver setPopoverContentSize:controller.view.bounds.size];
	[self.popOver presentPopoverFromRect:control.bounds inView:control permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
	[controller release];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{   
    [self dismissModalViewControllerAnimated:YES];
}

-(void) didSelectItem: (NSUInteger) item from:(MenuPopupController *) sender
{
	if (![self.currentGame canResume])
	{
		item++;
	}
	switch(item)
	{
		case 1:
			// Play
			[currentGame removeLocationOfType: LTYPE_PLAYER];
			// Drop through
		case 0:
			// Resume
		{
			GamePlayViewController *playController = [[GamePlayViewController alloc] initWithNibName: nil bundle:nil];
			[currentGame createGameRun];
			playController.gameRun = currentGame.gameRun;
			playController.overlayView.gameRun = currentGame.gameRun;
			if (playController.gameRun == nil) // otherwise it's a resume. Or maybe if the game has ended we should recreate
			{
				playController.gameRun = [currentGame createGameRun];
			}
			[[self navigationController] pushViewController:playController animated:YES];
			[playController release];
		}
			break;
		case 2:
		{
			GameEditViewController *editController = [[GameEditViewController alloc] initWithNibName:nil bundle:nil];
			editController.game = currentGame;
			UINavigationController *nav = [self navigationController];
			[nav pushViewController:editController animated:YES];
			[editController release];
		}		
			break;
		case 3:
			// Transmit
			break;
		case 4:
			// Email
		{
			NSString *error;
			NSDictionary *gameDict = [currentGame getCopyAsExportDictionary];
			NSData *gameData = [NSPropertyListSerialization dataFromPropertyList:gameDict
																		  format:NSPropertyListXMLFormat_v1_0
																errorDescription:&error];
			if (gameData)
			{
				MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
				mail.mailComposeDelegate = self;
				[mail setSubject:currentGame.name];
				[mail addAttachmentData:gameData mimeType:@"application/xml" fileName:@"game.xml"];
				[self presentModalViewController:mail animated:YES];				
			}
			[gameDict release];
		}
			break;
		case 5:
			// Delete
			[[self managedObjectContext] deleteObject:currentGame];
			currentGame = nil;
			[self addAllAnnotations];
			break;
	}
	[self.popOver dismissPopoverAnimated:YES];
	self.popOver = nil;			
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	if (viewController == self)
	{
		[self addAllAnnotations];
	}
}

#pragma mark -
#pragma mark SplitViewController delegate

- (void)splitViewController:(UISplitViewController*)svc popoverController:(UIPopoverController*)pc willPresentViewController:(UIViewController *)aViewController
{
	NSLog(@"Nothing to do");
}

- (void)splitViewController:(UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController:(UIPopoverController*)pc
{
	barButtonItem.title = @"Games";
	self.navigationItem.leftBarButtonItem = barButtonItem;
	self.title = @"Scavenger Games";
}

- (void)splitViewController:(UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)button
{
	// Hide the toolbar button
	self.navigationItem.leftBarButtonItem = nil;	
	self.title = @"";
}

@end
