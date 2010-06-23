//
//  HardwareStatusView.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/23/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HardwareObject+Extensions.h"
/**
 * This view is for a HUD of the status of Hardware
 */

@interface HardwareStatusView : UIView {
	HardwareObject *hardware;
}

-(CGRect) getMainRectangle;

@property(nonatomic, retain) HardwareObject *hardware;

@end
