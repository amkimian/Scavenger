//
//  LocationTools.m
//  Scavenger-iPad
//
//  Created by Alan Moore on 7/1/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import "LocationTools.h"


@implementation LocationTools

#pragma mark -
#pragma mark Properties

@synthesize coordinate;
@synthesize country;
@synthesize locality;
@synthesize postalCode;
@synthesize administrativeArea;
@synthesize geocoder;
@synthesize valid;
@synthesize delegate;

#pragma mark -
#pragma mark Setup

-(id) init
{
	valid = NO;
	return self;
}


#pragma mark -
#pragma mark MKReverseGeocoderDelegate

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
	self.geocoder = nil;
	[self alternateResolve];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)pl
{
	self.geocoder = nil;
	self.country = pl.country;
	self.administrativeArea = pl.administrativeArea;
	self.locality = pl.locality;
	self.postalCode = pl.postalCode;
	valid = YES;
	[delegate locationFound];
}

#pragma mark -
#pragma mark ReverseGeocodeApi

-(void) resolveGeocode
{
	[self mapKitResolve];
}

-(void) mapKitResolve
{
	self.geocoder = [[MKReverseGeocoder alloc] initWithCoordinate:coordinate];
	self.geocoder.delegate = self;
	[self.geocoder start];
}

-(void) alternateResolve
{
	// Show network activity Indicator (no need really as its very quick)
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	
	// Use Google Service
	// OK the code is verbose to illustrate step by step process
	
	// Form the string to make the call, passing in lat long 
	NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%lf,%lf&output=csv&sensor=false&key=scavenger",	 coordinate.latitude,coordinate.longitude];
	
	// Turn it into a URL
	NSURL *urlFromURLString = [NSURL URLWithString:urlString];
	
	// Use UTF8 encoding
	NSStringEncoding encodingType = NSUTF8StringEncoding;
	
	// reverseGeoString is what comes back with the goodies
	NSString *reverseGeoString = [NSString stringWithContentsOfURL:urlFromURLString encoding:encodingType error:nil];
	
	// 200,8,"2-16 Lee St, Walnut Creek, CA 94595, USA"
	// If it fails it returns nil	
	if (reverseGeoString != nil)
	{
		
		// Find first "
		NSRange position = [reverseGeoString rangeOfString:@"\""];
		if (position.length != 0)
		{
			NSString *subString = [reverseGeoString substringFromIndex:position.location+1];
			NSArray *items = [[subString substringToIndex:[subString length]-1] componentsSeparatedByString:@","];
			if ([items count] > 3)
			{
				self.country = [items objectAtIndex:3];
				self.locality = [items objectAtIndex:1];
				NSArray *parts = [(NSString *)[items objectAtIndex:2] componentsSeparatedByString:@" "];
				self.postalCode = [parts objectAtIndex:2];
				self.administrativeArea = [parts objectAtIndex:1];
				valid = YES;
				[delegate locationFound];
			}
		}
	}
	
	// Hide network activity indicator
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];	
}

@end
