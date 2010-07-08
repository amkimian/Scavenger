//
//  AWSScavenger.m
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/29/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import "AWSScavenger.h"
#import "GameObject+Extensions.h"
#import "LocationObject+Extensions.h"
#import "LocationPointObject.h"
#import "PlaceMarkObject.h"
#import "ASIS3Request.h"
#import "ASIS3ObjectRequest.h"

@implementation AWSScavenger

#pragma mark -
#pragma mark Properties

@synthesize simpleDb;
@synthesize searchResults;
@synthesize delegate;

#pragma mark -
#pragma mark Setup

-(id) init
{
	self.simpleDb = [[SimpleDb alloc] init];
	self.simpleDb.delegate = self;
	[self.simpleDb setAWSAccount:@"0289QDXAHCXX0JH9GXR2" secret: @"o3Nw5NnnamrywCy7m6gIEBEQiKZrnROP/cxuvvLy"];
	[ASIS3Request setSharedSecretAccessKey:@"o3Nw5NnnamrywCy7m6gIEBEQiKZrnROP/cxuvvLy"];
	[ASIS3Request setSharedAccessKey:@"0289QDXAHCXX0JH9GXR2"];
	return self;
}

#pragma mark -
#pragma mark SimpleDBDelegate

- (void) listDomainsComplete:(NSMutableArray*) domains
{
	for(NSString *domain in domains)
	{
		NSLog(@"Domain is %@", domain);
	}
}

-(void) selectComplete:(NSMutableArray *) items
{
	self.searchResults = items;
	[self.delegate awsDataChanged];
}


#pragma mark -
#pragma mark Main Api

-(void) listDomains
{
	[self.simpleDb listDomains];
}


-(void) unpublishGame: (GameObject *) game
{
	NSString *itemName = [NSString stringWithFormat:@"%@-%@", [UIDevice currentDevice].uniqueIdentifier, game.name];
	[self.simpleDb deleteAttributes:@"scgames" itemName:itemName attributes:nil];
}

-(void) performSelect: (NSString *) query
{
	[self.simpleDb select:query];
}

-(void) publishGame: (GameObject *) game
{
	// Get the attributes for this game
	// Work out whether this game has already been published
	// Update or insert as appropriate
	
	// Name is deviceId + Name
	// Attributes...
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Publishing" message:@"Publishing game" delegate:nil 
										  cancelButtonTitle:nil otherButtonTitles:nil];
	[alert show];
	
	[self unpublishGame: game];
	
	NSString *itemName = [NSString stringWithFormat:@"%@-%@", [UIDevice currentDevice].uniqueIdentifier, game.name];
	
	
	NSMutableArray *attributes = [[NSMutableArray alloc] init];
	
	// Get coordinate of first location of type "Start"	
	// Game Object should already be reverse geocoded
	
	[self addAttribute: @"Country" withValue: game.placeMark.country intoArray:attributes];
	[self addAttribute: @"Locality" withValue: game.placeMark.locality intoArray:attributes];
	[self addAttribute: @"AdminArea" withValue: game.placeMark.administrativeArea intoArray:attributes];
	[self addAttribute: @"SubArea" withValue: game.placeMark.subAdministrativeArea intoArray:attributes];
	[self addAttribute: @"PostalCode" withValue: game.placeMark.postalCode intoArray:attributes];
	
	// Need to add DeviceID
	// Game name
	// Latitude
	// Longitude
	// Stars
	// Description (new field in Game object)
	
	LocationObject *startLocation = [game getLocationOfType:LTYPE_START];
	
	[self addAttribute: @"Name" withValue: game.name intoArray:attributes];
	[self addAttribute: @"Latitude" withValue: [NSString stringWithFormat: @"%@", startLocation.firstPoint.latitude] intoArray:attributes];
	[self addAttribute: @"Longitude" withValue: [NSString stringWithFormat: @"%@", startLocation.firstPoint.longitude] intoArray:attributes];
	[self addAttribute: @"DeviceID" withValue: [UIDevice currentDevice].uniqueIdentifier intoArray:attributes];
	
	// And description when we have it
	
	if ([attributes count] > 0)
	{
		[self.simpleDb putAttributes:@"scgames" itemName:itemName attributes:attributes];
		// And write the configuration string to S3
		[self pushGameToS3:game withId:itemName];
	}
	else
	{
		NSLog(@"There is nothing to publish!");
	}
	[alert dismissWithClickedButtonIndex:0 animated:YES];
	[alert release];
}


#pragma mark -
#pragma mark Internal

-(void) pushGameToS3: (GameObject *) game withId: (NSString *) gameId
{
	NSString *error;
	NSDictionary *gameDict = [game getCopyAsExportDictionary];
	NSData *gameData = [NSPropertyListSerialization dataFromPropertyList:gameDict
																  format:NSPropertyListXMLFormat_v1_0
														errorDescription:&error];
	ASIS3ObjectRequest *request = 
	[ASIS3ObjectRequest PUTRequestForData:gameData withBucket:@"scavenger-games" key:gameId];
	[request startSynchronous];
	[gameDict release];
}

-(void) copyGameTest: (GameObject *) game
{
	NSString *error;
	NSDictionary *gameDict = [game getCopyAsExportDictionary];
	NSData *gameData = [NSPropertyListSerialization dataFromPropertyList:gameDict
																  format:NSPropertyListXMLFormat_v1_0
														errorDescription:&error];
	// And back
	
	NSDictionary *gameDictBack = [NSPropertyListSerialization propertyListFromData:gameData 
																  mutabilityOption:NSPropertyListMutableContainers 
																			format:nil 
																  errorDescription:&error];
	GameObject *newGame = [GameObject newFromExportDictionary:gameDictBack inManagedObjectContext:[game managedObjectContext]];
	game.name = [NSString stringWithFormat: @"Copy of %@", newGame.name];
}

-(void) addAttribute: (NSString *) name withValue: (NSString *) value intoArray: (NSMutableArray *) array
{
	if (value)
	{
		SimpleDbAttribute *attr = [[SimpleDbAttribute alloc] init];
		attr.name = name;
		attr.value = value;
		[array addObject: attr];	
		[attr release];
	}
}

@end
