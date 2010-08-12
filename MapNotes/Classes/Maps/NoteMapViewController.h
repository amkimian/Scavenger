//
//  NoteMapViewController.h
//  MapNotes
//
//  Created by Alan Moore on 8/11/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface NoteMapViewController : UIViewController<UISplitViewControllerDelegate> {
	IBOutlet MKMapView *mapView;
}

@end
