//
//  SimpleDbAttribute.h
//  GetSomeSnow
//
//  Created by Eric Lee on 12/15/08.
//  Copyright LearnAws.com 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleDbAttribute : NSObject {

	NSString *name;
	NSString *value;
	NSString *replace;	
}

+ (SimpleDbAttribute*) create:(NSString*)name value:(NSString*)value replace:(bool)replace;

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *value;
@property (nonatomic, retain) NSString *replace;

@end
