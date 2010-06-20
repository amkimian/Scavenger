//
//  SingleLocationView.h
//  POC-Location
//
//  Created by Alan Moore on 6/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LocationObject+Extensions.h"

@protocol SingleLocationViewDelegate;
typedef enum
{
	MODE_DELETE,
	MODE_MOVE,
	MODE_ADD
} EditMode_T;

@interface SingleLocationView : UIView<MKMapViewDelegate>{
	id<SingleLocationViewDelegate> delegate;
	EditMode_T mode;
	LocationObject *location;
	LocationPointObject *selectedLocationPoint;
}

@property(nonatomic, retain) LocationObject *location;
@property(nonatomic, retain) id<SingleLocationViewDelegate> delegate;
@property(nonatomic, retain) LocationPointObject *selectedLocationPoint;
@property(nonatomic) EditMode_T mode;
@end


@protocol SingleLocationViewDelegate
-(void) selectedLocationPoint: (LocationPointObject *) point;
-(void) clickedWithNoSelectionAtPoint: (CGPoint) point;
@end