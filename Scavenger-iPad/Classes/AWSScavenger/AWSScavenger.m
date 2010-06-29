//
//  AWSScavenger.m
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/29/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import "AWSScavenger.h"


@implementation AWSScavenger
@synthesize simpleDb;

-(id) init
{
	self.simpleDb = [[SimpleDb alloc] init];
	self.simpleDb.delegate = self;
	[self.simpleDb setAWSAccount:@"0289QDXAHCXX0JH9GXR2" secret: @"o3Nw5NnnamrywCy7m6gIEBEQiKZrnROP/cxuvvLy"];
	return self;
}

-(void) listDomains
{
	[self.simpleDb listDomains];
}

- (void) listDomainsComplete:(NSMutableArray*) domains
{
	for(NSString *domain in domains)
	{
		NSLog(@"Domain is %@", domain);
	}
}

@end
