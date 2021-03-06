//
//  GameSounds.m
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/24/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import "GameSounds.h"


@implementation GameSounds

#pragma mark -
#pragma mark Properties
@synthesize player;

#pragma mark -
#pragma mark Setup

-(id) init
{
	ableToPlay = YES;
	return self;
}

#pragma mark -
#pragma mark Main Api

- (void)playAlert
{
         /*
         * Here we grab our path to our resource
         */
	if (ableToPlay == YES)
	{
        NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
        resourcePath = [resourcePath stringByAppendingString:@"/alert.m4a"];
        NSLog(@"Path to play: %@", resourcePath);
        NSError* err;
		
        //Initialize our player pointing to the path to our resource
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:
				  [NSURL fileURLWithPath:resourcePath] error:&err];
		
        if( err ){
            //bail!
            NSLog(@"Failed with reason: %@", [err localizedDescription]);
        }
        else{
            //set our delegate and begin playback
            player.delegate = self;
			ableToPlay = NO;
            [player play];
        }
	}
}

#pragma mark -
#pragma mark Audio Delegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
	NSLog(@"Did finish");
	ableToPlay = YES;
}

@end
