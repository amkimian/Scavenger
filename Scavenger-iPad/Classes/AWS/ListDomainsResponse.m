//
//  ListDomainsResponse.m
//  GetSomeSnow
//
//  Created by Eric Lee on 12/14/08.
//  Copyright Oodol 2008. All rights reserved.
//

#import "ListDomainsResponse.h"


@implementation ListDomainsResponse

@synthesize delegate, domains;

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{			
	if (qName) 
	{
        elementName = qName;
    }
	
	if ([elementName isEqualToString:@"ListDomainsResult"])
	{
		//
		// Start a new list of domains
		//
		domains = [[NSMutableArray alloc] init];
	}
	else if ([elementName isEqualToString:@"DomainName"])
	{
		
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	//
	// Fire our delegate to let people know that we are done
	//
	if ([self.delegate respondsToSelector:@selector(listDomainsParseComplete)]) 
	{		
		[self.delegate listDomainsParseComplete];
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
		[domains addObject:string];
	}
}

@end
