//
//  GameListViewController.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/16/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * This view controller handles the first view that gets shown from application
 * start. The main view is of a map view (with ancilliary controls for that)
 *
 * There's also an add button for creating a new game.
 * Games (that have a start location) are shown on the map as annotations
 */

@interface GameListViewController : UIViewController {
	NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@end
