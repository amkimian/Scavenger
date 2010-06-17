//
//  ChooseListPopupController.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/17/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationObject+Extensions.h"

@protocol ChooseListDidChooseDelegate;

@interface ChooseListPopupController : UITableViewController {
	id<ChooseListDidChooseDelegate> delegate;
}

@property(nonatomic, retain) id<ChooseListDidChooseDelegate> delegate;
@end

@protocol ChooseListDidChooseDelegate
-(void) didChoose: (LocationType) type from: (ChooseListPopupController *) sender;
@end
