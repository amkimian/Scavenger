//
//  LocationListView.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/17/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameObject+Extensions.h"

@interface LocationListView : UITableViewController {
	UITableViewCell *tvCell;
	GameObject *game;
}

@property(nonatomic, assign) IBOutlet UITableViewCell *tvCell;
@property(nonatomic, assign) GameObject *game;
@end
