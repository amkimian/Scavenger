//
//  SimpleDbAttribute.m
//  GetSomeSnow
//
//  Created by Eric Lee on 12/15/08.
//  Copyright LearnAws.com 2008. All rights reserved.
//

#import "SimpleDbAttribute.h"


@implementation SimpleDbAttribute

@synthesize name, value, replace;

+ (SimpleDbAttribute*) create:(NSString*)name value:(NSString*)value replace:(bool)replace {
	
	SimpleDbAttribute *attribute = [[SimpleDbAttribute alloc] init];	
	attribute.name = name;
	attribute.value = value;
	
	if (replace == false)
	{
		attribute.replace = @"FALSE";
	}
	else
	{
		attribute.replace = @"TRUE";
	}
	
	return attribute;
}

@end
