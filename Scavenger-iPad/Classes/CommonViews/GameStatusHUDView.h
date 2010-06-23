//
//  GameStatusHUDView.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/23/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameRunObject+Extensions.h"
#import "HardwareObject+Extensions.h"

@interface GameStatusHUDView : UIView {
	GameRunObject *gameRun;
}

@property(nonatomic, retain) GameRunObject *gameRun;
@end
