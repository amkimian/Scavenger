//
//  GameScoreTableViewController.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/23/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameRunObject+Extensions.h"

@interface GameScoreTableViewController : UITableViewController {
	GameRunObject *gameRun;
}

@property(nonatomic, retain) GameRunObject *gameRun;

@end
