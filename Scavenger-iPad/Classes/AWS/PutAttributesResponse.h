//
//  PutAttributesResponse.h
//  GetSomeSnow
//
//  Created by Eric Lee on 12/15/08.
//  Copyright LearnAws.com 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSObject (PutAttributesResponseDelegateMethod)
- (void) putAttributesParseComplete;
@end

@interface PutAttributesResponse : NSObject {
	id delegate;
}

@property (nonatomic, retain) id delegate;

- (void)parserDidEndDocument:(NSXMLParser *)parser;
- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;
- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;
- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;

@end
