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
#import "AWSScavenger.h"
#import "LocationTools.h"

@interface GameListOnlineViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, LocationToolsDelegate, MenuPopupDelegate> {
	GameListViewController *rootController;
	MKPlacemark *placemark;
	MKReverseGeocoder *geocoder;
	IBOutlet UITableView *mainTable;
	GameObject *currentGame;
	UIPopoverController *popOver;
	AWSScavenger *awsScavenger;
	LocationTools *locationTools;
}

-(IBAction) done:(id) sender;

@property(nonatomic, retain) GameListViewController *rootController;
@property(nonatomic, retain) MKPlacemark *placemark;
@property(nonatomic, retain) MKReverseGeocoder *geocoder;
@property(nonatomic, retain) GameObject *currentGame;
@property (nonatomic, retain) UIPopoverController *popOver;
@property (nonatomic, retain) AWSScavenger *awsScavenger;
@end
