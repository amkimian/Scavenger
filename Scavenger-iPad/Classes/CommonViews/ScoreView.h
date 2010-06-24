//
//  ScoreView.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/23/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import <UIKit/UIKit.h>

/** 
 * A score view simply displays a text label in a pretty way
 */

@interface ScoreView : UIView {
	float scoreValue;
	float bonusValue;
}

@property(nonatomic) float scoreValue;
@property(nonatomic) float bonusValue;

@end
