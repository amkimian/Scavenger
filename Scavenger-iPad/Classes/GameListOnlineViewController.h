//
//  GameListOnlineViewController.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/29/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GameListViewController.h"
#import "GameObject.h"

#import "LocationTools.h"

@interface GameListOnlineViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, LocationToolsDelegate, MenuPopupDelegate, 
UINavigationControllerDelegate> {
	GameListViewController *rootController;
	MKPlacemark *placemark;
	MKReverseGeocoder *geocoder;
	IBOutlet UITableView *mainTable;
	GameObject *currentGame;
	UIPopoverController *popOver;

	LocationTools *locationTools;
}

-(IBAction) query:(id) sender;
-(void) gamesChangeNotification: (NSNotification *) n;

@property(nonatomic, retain) GameListViewController *rootController;
@property(nonatomic, retain) MKPlacemark *placemark;
@property(nonatomic, retain) MKReverseGeocoder *geocoder;
@property(nonatomic, retain) GameObject *currentGame;
@property (nonatomic, retain) UIPopoverController *popOver;

@end
