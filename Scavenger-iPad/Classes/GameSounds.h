//
//  GameSounds.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/24/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface GameSounds : NSObject<AVAudioPlayerDelegate> {
	AVAudioPlayer* player;
	BOOL ableToPlay;
}

- (void)playAlert;

@property(nonatomic, retain) AVAudioPlayer *player;
@end
