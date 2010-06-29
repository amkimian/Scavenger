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

@interface GameListOnlineViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, MKReverseGeocoderDelegate> {
	GameListViewController *rootController;
	MKPlacemark *placemark;
	MKReverseGeocoder *geocoder;
	IBOutlet UITableView *mainTable;
}

-(IBAction) done:(id) sender;

@property(nonatomic, retain) GameListViewController *rootController;
@property(nonatomic, retain) MKPlacemark *placemark;
@property(nonatomic, retain) MKReverseGeocoder *geocoder;
@end
