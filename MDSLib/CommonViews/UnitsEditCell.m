//
//  UnitsEditCell.m
//  MDSTH
//
//  Created by Alan Moore on 6/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UnitsEditCell.h"


@implementation UnitsEditCell
@synthesize delegate;
@synthesize leftLabel;
@synthesize unitsLabel;
@synthesize textField;
@synthesize tag;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		// Left label
		leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10,0,20)];
		leftLabel.font = [UIFont boldSystemFontOfSize:17];
		unitsLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width,10,0,20)];
		unitsLabel.textColor = [UIColor darkGrayColor];
		
		// TODO - need the above bold
		textField = [[UITextField alloc] initWithFrame:CGRectMake(0,10,0,20)]; 
		textField.textColor = [UIColor blueColor];
		textField.delegate = self;
		textField.textAlignment = UITextAlignmentRight;
		
		[textField addTarget: self action:@selector(textFieldDidEndOnExit) forControlEvents:UIControlEventEditingDidEndOnExit];
		
		[self.contentView addSubview:leftLabel];
		[self.contentView addSubview:textField];
		[self.contentView addSubview:unitsLabel];
    }
    return self;
}

-(void) textFieldDidEndOnExit
{
	[textField resignFirstResponder];
	[delegate editableCellDidEndOnExit:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setLabelText:(NSString *) text
{
	leftLabel.text = text;
	CGSize size = [text sizeWithFont: leftLabel.font];
	CGRect labelFrame = leftLabel.frame;
	labelFrame.size.width = size.width;
	leftLabel.frame = labelFrame;
	
	CGRect textFieldFrame = textField.frame;
	textFieldFrame.origin.x = size.width + 30;
	textFieldFrame.size.width = self.frame.size.width - textFieldFrame.origin.x - unitsLabel.frame.size.width - 40;
	textField.frame = textFieldFrame;
}

-(void) setUnitsText:(NSString *) text
{
	unitsLabel.text = text;
	CGSize size = [text sizeWithFont: unitsLabel.font];
	CGRect unitsLabelFrame = unitsLabel.frame;
	float useWidth = 500.0;
	unitsLabelFrame.size.width = size.width;
	unitsLabelFrame.origin.x = useWidth - size.width - 30;
	unitsLabel.frame = unitsLabelFrame;
	
	CGRect textFieldFrame = textField.frame;
	CGRect leftLabelFrame = leftLabel.frame;
	
	textFieldFrame.origin.x = leftLabelFrame.size.width + 30;
	textFieldFrame.size.width = useWidth - textFieldFrame.origin.x - unitsLabel.frame.size.width - 40;
	textField.frame = textFieldFrame;
}

- (void)dealloc {
    [super dealloc];
}

// delegate method of UITextField, called when a text field begins editing
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	[delegate editableCellDidBeginEditing:self]; // inform the delegate
} // end method textFieldDidBeginEditing:

// delegate method of UITextField, called when a text field ends editing
- (void)textFieldDidEndEditing:(UITextField *)textField
{
	[delegate editableCellDidEndEditing:self]; // inform the delegate
} // end method textFieldDidEndEditing:

@end
