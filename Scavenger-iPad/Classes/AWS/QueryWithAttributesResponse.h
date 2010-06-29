//
//  QueryWithAttributesResponse.h
//  GetSomeSnow
//
//  Created by Eric Lee on 12/16/08.
//  Copyright LearnAws.com 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SimpleDbItem.h"
#import "SimpleDbAttribute.h"

@interface NSObject (QueryWithAttributesResponseDelegateMethod)
- (void) queryWithAttributesParseComplete;
@end

@interface QueryWithAttributesResponse : NSObject {
	
	id delegate;
	
	NSMutableArray *items;	
	SimpleDbItem *currentItem;
	SimpleDbAttribute *currentAttribute;

	NSSet *triggerElements;
	NSMutableString *textInProgress;
}

@property (nonatomic, retain) id delegate;
@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, retain) SimpleDbItem *currentItem;
@property (nonatomic, retain) SimpleDbAttribute* currentAttribute;

@property (nonatomic, retain) NSMutableString* textInProgress;
@property (nonatomic, retain) NSSet* triggerElements;

- (void)parserDidEndDocument:(NSXMLParser *)parser;
- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;
- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;
- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;

@end
