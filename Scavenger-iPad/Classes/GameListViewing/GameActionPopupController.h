//
//  GameActionPopupController.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/16/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
	GAME_EDIT,
	GAME_PLAY,
	GAME_SEND
} GameActionType;

@protocol GameActionDelegate;

@interface GameActionPopupController : UIViewController {
	id<GameActionDelegate> delegate;
	IBOutlet UISegmentedControl *segControl;
}

-(IBAction) changed: (id) sender;

@property(retain, nonatomic) id<GameActionDelegate> delegate;

@end

@protocol GameActionDelegate
-(void) selectedAction: (GameActionType) actionType from: (GameActionPopupController *) sender;
@end