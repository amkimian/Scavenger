//
//  TextEditController.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/17/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationObject+Extensions.h"


@interface TextEditController : UIViewController<UITextViewDelegate> {
	LocationObject *location;
	NSString *tagToEdit;
	NSString *labelText;
	IBOutlet UITextView *textView;
	IBOutlet UILabel *label;
}

-(IBAction) didEndEdit: (id) sender;

@property(nonatomic, retain) LocationObject *location;
@property(nonatomic, retain) NSString *tagToEdit;
@property(nonatomic, retain) NSString *labelText;
@end
