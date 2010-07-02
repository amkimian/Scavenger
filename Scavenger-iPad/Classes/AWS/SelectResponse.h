//
//  SelectResponse.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 7/1/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleDbItem.h"
#import "SimpleDbAttribute.h"

@interface NSObject (SelectResponseDelegateMethod)
- (void) selectParseComplete;
@end

@interface SelectResponse : NSObject {
	
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
