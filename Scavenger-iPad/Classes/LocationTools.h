//
//  LocationTools.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 7/1/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
/**
 * A class to help with obtaining location information
 */

@protocol LocationToolsDelegate;

@interface LocationTools : NSObject  <MKReverseGeocoderDelegate> {
	CLLocationCoordinate2D coordinate;
	NSString *country;
	NSString *locality;
	NSString *postalCode;
	NSString *administrativeArea;
	BOOL valid;
	MKReverseGeocoder *geocoder;
	id<LocationToolsDelegate> delegate;
}

@property(nonatomic) CLLocationCoordinate2D coordinate;
@property(nonatomic, retain) NSString *country;
@property(nonatomic, retain) NSString *locality;
@property(nonatomic, retain) NSString *postalCode;
@property(nonatomic, retain) NSString *administrativeArea;
@property(nonatomic, retain) MKReverseGeocoder *geocoder;
@property(nonatomic) BOOL valid;
@property(nonatomic, retain) id<LocationToolsDelegate> delegate;

-(void) resolveGeocode;

-(void) mapKitResolve;
-(void) alternateResolve;

@end

@protocol LocationToolsDelegate
-(void) locationFound;
@end
