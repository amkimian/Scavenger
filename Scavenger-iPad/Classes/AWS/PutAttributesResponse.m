//
//  PutAttributesResponse.m
//  GetSomeSnow
//
//  Created by Eric Lee on 12/15/08.
//  Copyright LearnAws.com 2008. All rights reserved.
//

#import "PutAttributesResponse.h"


@implementation PutAttributesResponse

@synthesize delegate;

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{			
	//
	// Nothing to do
	//
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	//
	// Fire our delegate to let people know that we are done
	//
	if ([self.delegate respondsToSelector:@selector(putAttributesParseComplete)]) 
	{		
		[self.delegate putAttributesParseComplete];
    }	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	//
	// Nothing to do here because all of our values are in attributes
	//
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	//
	// Nothing to do
	//
}

@end
