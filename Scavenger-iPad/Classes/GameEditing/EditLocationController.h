//
//  EditLocationController.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/17/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationObject+Extensions.h"
#import "UnitsEditCell.h"

static const int KEYBOARD_HEIGHT = 200; // the height of the keyboard

@protocol EditLocationEndDelegate;

@interface EditLocationController : UITableViewController<UnitsEditCellDelegate> {
	id<EditLocationEndDelegate> delegate;
	LocationObject *location;
	BOOL keyboardShown;
}

-(UnitsEditCell *) getUnitsCell;
-(UITableViewCell *) getStandardCell;
-(UITableViewCell *) getSubtitleCell;
-(void) doneEditing;

@property(nonatomic, retain) LocationObject *location;
@property(nonatomic, retain) id<EditLocationEndDelegate> delegate;
@end

@protocol EditLocationEndDelegate
-(void) editLocationDidFinishEditing:(EditLocationController *) controller;
@end
