//
//  MenuPopupController.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/17/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuPopupDelegate;

@interface MenuPopupController : UITableViewController {
	id<MenuPopupDelegate> delegate;
	NSArray *menuStrings;
	
}

@property(nonatomic, retain) id<MenuPopupDelegate> delegate;
@property(nonatomic, retain) NSArray *menuStrings;

@end

@protocol MenuPopupDelegate
-(void) didSelectItem: (NSUInteger) item from:(MenuPopupController *) sender;
@end