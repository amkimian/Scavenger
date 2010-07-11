//
//  AppDelegate_iPhone.h
//  CamFlow
//
//  Created by Alan Moore on 7/10/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate_Shared.h"

#define APPDELEGATE_IPHONE (AppDelegate_iPhone *) [UIApplication sharedApplication].delegate

@interface AppDelegate_iPhone : AppDelegate_Shared<UITabBarControllerDelegate> {
}


@end

