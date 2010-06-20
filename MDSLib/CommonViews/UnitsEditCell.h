//
//  UnitsEditCell.h
//  MDSTH
//
//  Created by Alan Moore on 6/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * A units edit cell has
 * a Bold label at the left
 * then a units (e.g. meters) at the right
 * and a value to the left of the units
 * You can edit the value of the units
 */

@protocol UnitsEditCellDelegate;

@interface UnitsEditCell : UITableViewCell  <UITextFieldDelegate>{
	id<UnitsEditCellDelegate> delegate;
	UILabel *leftLabel;
	UILabel *unitsLabel;
	UITextField *textField;
	
	NSString *tag;
}

@property (nonatomic, retain) UITextField *textField;
@property (readonly, retain) UILabel *leftLabel;
@property (readonly, retain) UILabel *unitsLabel;
@property (nonatomic, retain) NSString *tag;

@property (nonatomic, assign) id<UnitsEditCellDelegate> delegate;

- (void)setLabelText:(NSString *)text; // set the text of label
- (void)setUnitsText:(NSString *)text; // set the text of the units

@end

@protocol UnitsEditCellDelegate
-(void) editableCellDidBeginEditing: (UnitsEditCell *) cell;
-(void) editableCellDidEndEditing: (UnitsEditCell *) cell;
-(void) editableCellDidEndOnExit: (UnitsEditCell *) cell;

@end
