//
//  GameActionPopupController.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/16/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameObject.h"
typedef enum
{
	GAME_EDIT,
	GAME_PLAY,
	GAME_SEND,
	GAME_DELETE
} GameActionType;

@protocol GameActionDelegate;

@interface GameActionPopupController : UIViewController {
	id<GameActionDelegate> delegate;
	GameObject *game;
}

-(IBAction) changed: (id) sender;

@property(retain, nonatomic) id<GameActionDelegate> delegate;
@property(retain, nonatomic) GameObject *game;

@end

@protocol GameActionDelegate
-(void) selectedAction: (GameActionType) actionType from: (GameActionPopupController *) sender;
@end