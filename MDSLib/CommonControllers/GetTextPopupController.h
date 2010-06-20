//
//  GetTextPopupController.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/16/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GetTextPopupDelegate;

@interface GetTextPopupController : UIViewController {
	id<GetTextPopupDelegate> delegate;
	IBOutlet UITextField *textField;
}

-(IBAction) done: (id) sender;

@property(retain, nonatomic) id<GetTextPopupDelegate> delegate;
@property(retain, nonatomic) UITextField *textField;
@end

@protocol GetTextPopupDelegate
-(void) textChangedFrom: (GetTextPopupController *) sender;
@end

