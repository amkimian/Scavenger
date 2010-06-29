//
//  SimpleDbItem.m
//  GetSomeSnow
//
//  Created by Eric Lee on 12/15/08.
//  Copyright LearnAws.com 2008. All rights reserved.
//

#import "SimpleDbItem.h"

@implementation SimpleDbItem

@synthesize name, attributes;

-(id) init {

    self = [super init];
    
	name = nil;
	attributes = [[NSMutableDictionary alloc] init];
	
	return self;
}

@end
