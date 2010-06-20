//
//  MapTypePopupController.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/16/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

/*
 * This class handles the popover controller for selecting a type of map type
 */

@protocol MapTypeChangedDelegate;

@interface MapTypePopupController : UIViewController {
	id<MapTypeChangedDelegate> delegate;
	IBOutlet UISegmentedControl *segmentControl;
	MKMapType mapType;
}

@property(retain, nonatomic) id<MapTypeChangedDelegate> delegate;
@property(nonatomic) MKMapType mapType;

-(IBAction) selectionChanged: (id) sender;

-(void) updateMapType;

@end

@protocol MapTypeChangedDelegate
-(void) changeMapType: (MKMapType) mapType from:(MapTypePopupController *) sender;
@end;
