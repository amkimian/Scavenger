//
//  QueryWithAttributesResponse.m
//  GetSomeSnow
//
//  Created by Eric Lee on 12/16/08.
//  Copyright LearnAws.com 2008. All rights reserved.
//

#import "QueryWithAttributesResponse.h"

@implementation QueryWithAttributesResponse

@synthesize delegate, items, currentItem, currentAttribute, textInProgress, triggerElements;

-(id) init {

	self = [super init];

	//
	// These are the items we care about getting data from; remember, the nil signifies the end of the initialization objects
	//
	triggerElements = [[NSSet alloc] initWithObjects:@"Item", @"Name", @"Value", nil];

	return self;
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {			

	//
	// Make sure we have our trigger elements
	//
	assert(triggerElements != nil);
	
	if (qName) 
	{
        elementName = qName;
    }
	
	if ([elementName isEqualToString:@"QueryWithAttributesResult"])
	{
		//
		// Start a new list of items
		//
		items = [[NSMutableArray alloc] init];
	}
	else if ([triggerElements containsObject:elementName])
	{
		//
		// Create a new textInProgress if we don't have one already
		//
		if (textInProgress == nil)
		{
			textInProgress = [[NSMutableString alloc] init];
		}
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	
	//
	// Fire our delegate to let people know that we are done
	//
	if ([self.delegate respondsToSelector:@selector(queryWithAttributesParseComplete)]) 
	{		
		[self.delegate queryWithAttributesParseComplete];
    }	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	
	//
	// Let's see what element just ended
	//
	if ([elementName isEqual:@"Name"])
	{
		//
		// This name could belong to <item> or <attribute>. If we have a nil currentItem, then this name belongs to the current item.
		//
		if (currentItem == nil)
		{
			//
			// There should not be any attributes at this point
			//
			assert(currentAttribute == nil);

			//
			// The text should be the value we are building up
			//
			assert(textInProgress != nil);
			
			currentItem = [[SimpleDbItem alloc] init];
			currentItem.name = [[NSString alloc] initWithString:textInProgress];
		}
		else
		{
			//
			// If our currentItem is not nil, then this name belongs to an attribute. We should have a nil current attribute
			// at this time.
			//
			assert(currentAttribute == nil);
			
			//
			// The text should be the value we are building up
			//
			assert(textInProgress != nil);

			currentAttribute = [[SimpleDbAttribute alloc] init];
			currentAttribute.name = [[NSString alloc] initWithString:textInProgress];
		}
	}
	else if ([elementName isEqual:@"Value"])
	{
		//
		// This value belongs to an attribute
		//
		assert(currentItem != nil);
		assert(currentAttribute != nil);
		
		currentAttribute.value = [[NSString alloc] initWithString:textInProgress];
		
		//
		// We have a complete attribute at this point, so we can add it to our item
		//
		[currentItem.attributes setValue:currentAttribute forKey:currentAttribute.name];
		
		//
		// Clean up our current attribute; TODO check to see if this should be a release as well as a nil
		//
		currentAttribute = nil;
	}
	else if ([elementName isEqual:@"Item"])
	{
		//
		// We should have a full item here
		//
		assert(currentItem != nil);
		assert(currentItem.name != nil);
		assert([currentItem.attributes count] > 0);
		
		//
		// We should not have started a new attribute yet
		//
		assert(currentAttribute == nil);
		
		//
		// We should not be building up text
		//
		assert(textInProgress == nil);

		//
		// We should have at least an empty set of items
		//
		assert(items != nil);
		
		//
		// Add this item to our list
		//
		[items addObject:currentItem];
		
		//
		// TODO, should this be a nil or a release and nil?
		//
		currentItem = nil;
	}
		
	//
	// Clear out our text in progress
	//
	textInProgress = nil;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {

	if (string != nil)
	{
		//
		// If textInProgress is not nil, append the text. If textInProgress is nil, then the assumption is that
		// we do not care about the data for this particular element.
		//		
		if (textInProgress != nil)
		{
			[textInProgress appendString:string];
		}
	}
}

@end
