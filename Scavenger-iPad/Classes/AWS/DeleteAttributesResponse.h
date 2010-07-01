//
//  DeleteAttributesResponse.h
//  Scavenger-iPad
//
//  Created by Alan Moore on 6/30/10.
//  Copyright 2010 Mount Diablo Software (Alan Moore). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DeleteAttributesResponseDelegateMethod)
- (void) deleteAttributesParseComplete;
@end

@interface DeleteAttributesResponse : NSObject {
	id delegate;
}

@property (nonatomic, retain) id delegate;

- (void)parserDidEndDocument:(NSXMLParser *)parser;
- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;
- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;
- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;

@end
