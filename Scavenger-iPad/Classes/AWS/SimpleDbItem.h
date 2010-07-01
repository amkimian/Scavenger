//
//  SimpleDbItem.h
//  GetSomeSnow
//
//  Created by Eric Lee on 12/15/08.
//  Copyright LearnAws.com 2008. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SimpleDbItem : NSObject {

	NSString *name;
	NSMutableDictionary *attributes;
}

@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSMutableDictionary *attributes;

@end
