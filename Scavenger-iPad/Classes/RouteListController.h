//
//  RouteListController.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/17/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameObject+Extensions.h"

@protocol RouteListDoneDelegate;

@interface RouteListController : UITableViewController {
	id<RouteListDoneDelegate> delegate;
	GameObject *game;
}

-(void) finished: (id) sender;
-(void) add: (id) sender;

@property(nonatomic, retain) id<RouteListDoneDelegate> delegate;
@property(nonatomic, retain) GameObject *game;
@end

@protocol RouteListDoneDelegate
-(void) didEndRouteList: (RouteListController *) sender;
@end