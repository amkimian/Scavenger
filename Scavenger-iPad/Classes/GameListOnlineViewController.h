//
//  GameListOnlineViewController.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/29/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameListViewController.h"

@interface GameListOnlineViewController : UIViewController<UITableViewDelegate,UITableViewDataSource> {
	GameListViewController *rootController;
}

-(IBAction) done:(id) sender;

@property(nonatomic, retain) GameListViewController *rootController;
@end
