//
//  ListDomainsResponse.h
//  GetSomeSnow
//
//  Created by Eric Lee on 12/14/08.
//  Copyright Oodol 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSObject (ListDomainsResponseDelegateMethod)
	- (void) listDomainsParseComplete;
@end

@interface ListDomainsResponse : NSObject {
	
	id delegate;
	NSMutableArray *domains;
}

@property (nonatomic, retain) id delegate;
@property (nonatomic, retain) NSMutableArray* domains;
 
- (void)parserDidEndDocument:(NSXMLParser *)parser;
- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;
- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;
- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;

@end
