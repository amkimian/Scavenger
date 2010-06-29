//
//  QueryResponse.m
//  GetSomeSnow
//
//  Created by Eric Lee on 12/15/08.
//  Copyright LearnAws.com 2008. All rights reserved.
//

#import "QueryResponse.h"

@implementation QueryResponse

@synthesize delegate, items;

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{			
	if (qName) 
	{
        elementName = qName;
    }
	
	if ([elementName isEqualToString:@"QueryResult"])
	{
		//
		// Start a new list of items
		//
		items = [[NSMutableArray alloc] init];
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	//
	// Fire our delegate to let people know that we are done
	//
	if ([self.delegate respondsToSelector:@selector(queryParseComplete)]) 
	{		
		[self.delegate queryParseComplete];
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
	if (string != nil)
	{
		//
		// Add this new domain to our list
		//
		[items addObject:string];
	}
}

@end
