//
//  SimpleDb.m
//  GetSomeSnow
//
//  Created by Eric Lee on 12/11/08.
//  Copyright LearnAws.com 2008. All rights reserved.
//

#import "SimpleDb.h"
#import "NSDataExtensions.h"

@implementation SimpleDb

@synthesize key, secret, delegate, listDomainsResponse, createDomainResponse, putAttributesResponse, queryResponse, queryWithAttributesResponse;

- (void) setAWSAccount:(NSString*) _key secret:(NSString*) _secret 
{	
	//
	// Store these values
	//
	self.key = _key;
	self.secret = _secret;
}

//
// This is a method that can be used to generate an unique id for an item in SimpleDb
//
- (NSString*) getUniqueId {
	
	return [self getTimestamp];
}

- (void) listDomains {
	
	//
	// First thing we need is a timestamp
	//
	NSString* timeStamp = [self getTimestamp];

	//
	// Build up an array of parameters in our request
	//
	NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
	
	[parameters setValue:self.key forKey:@"AWSAccessKeyId"];
	[parameters setValue:@"ListDomains" forKey:@"Action"];
	[parameters setValue:@"2007-11-07" forKey:@"Version"];
	[parameters setValue:@"1" forKey:@"SignatureVersion"];
	[parameters setValue:timeStamp forKey:@"Timestamp"];	
	
	//
	// This string should sort values, but not do any URL escaping; this is probably correct
	//
	NSString *stringForSignature = [self getStringForSignature:parameters];
	
	NSString *signature = [self makeSignature:secret data:[stringForSignature dataUsingEncoding:NSASCIIStringEncoding]];

	//
	// Now that we have our authorization signature, make our actual request and parse the return value
	//	
	NSMutableString *queryParams = [self getQueryString:parameters];
	
	//
	// Add in our signature value
	//
	[queryParams appendFormat:@"Signature=%@", [signature stringByEscapingHTTPReserved]];
	
	//
	// Construct our entire URL
	//
	NSString *urlAsString = [NSString stringWithFormat:@"http://sdb.amazonaws.com?%@", queryParams];
	NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL: [NSURL URLWithString:urlAsString]];
	
	//	
    // Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
	//
	if (self.listDomainsResponse == nil)
	{
		listDomainsResponse = [[ListDomainsResponse alloc] init];
		[listDomainsResponse setDelegate:self];
	}
	
    [parser setDelegate:listDomainsResponse];
    
	//
	// Depending on the XML document you're parsing, you may want to enable these features of NSXMLParser.
	//
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    
	//
	// Start our parsing
	//
    [parser parse];    
    [parser release];
}

- (void) createDomain:(NSString*)name {
	
	//
	// Get our invocation URL
	//
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];	
	[params setValue:name forKey:@"DomainName"];
	
	NSXMLParser *parser = [self invoke:@"CreateDomain" invokeParameters:params];
	
	//	
    // Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
	//
	if (self.createDomainResponse == nil)
	{
		createDomainResponse = [[CreateDomainResponse alloc] init];
		[createDomainResponse setDelegate:self];
	}
	
    [parser setDelegate:listDomainsResponse];
	
	[parser parse];
	[parser release];
}

- (void) putAttributes:(NSString*)domainName itemName:(NSString*)itemName attributes:(NSMutableArray*)attributes {

	//
	// Name our attributes from 0 to n as Attribute.X.Name/Attribute.X.Value
	//
	NSMutableDictionary *restReadyParameters = [[NSMutableDictionary alloc] init];

	NSEnumerator *e = [attributes objectEnumerator];
	SimpleDbAttribute *replaceableAttribute;
	int i = 0;
	
	while (replaceableAttribute = [e nextObject]) 
	{
		NSString *attributeNName = [NSString stringWithFormat:@"Attribute.%d.Name", i];
		NSString *attributeNValue = [NSString stringWithFormat:@"Attribute.%d.Value", i];
		NSString *attributeNReplace = [NSString stringWithFormat:@"Attribute.%d.Replace", i];
		
		[restReadyParameters setValue:replaceableAttribute.name forKey:attributeNName];
		[restReadyParameters setValue:replaceableAttribute.value forKey:attributeNValue];
		[restReadyParameters setValue:replaceableAttribute.replace forKey:attributeNReplace];
		i++;
	} 	
	
	[restReadyParameters setValue:domainName forKey:@"DomainName"];	
	[restReadyParameters setValue:itemName forKey:@"ItemName"];
	
	//
	// Invoke our method
	//
	NSXMLParser *parser = [self invoke:@"PutAttributes" invokeParameters:restReadyParameters];
	
	//	
    // Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
	//
	if (self.putAttributesResponse == nil)
	{
		putAttributesResponse = [[PutAttributesResponse alloc] init];
		[putAttributesResponse setDelegate:self];
	}
	
    [parser setDelegate:putAttributesResponse];
	
	[parser parse];
	[parser release];
}

- (void) query:(NSString*)domainName expression:(NSString*)expression {
	
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
	
	[params setValue:domainName forKey:@"DomainName"];
	
	if (expression != nil)
	{
		[params setValue:expression forKey:@"QueryExpression"];
	}
		
	//
	// Invoke our method
	//
	NSXMLParser *parser = [self invoke:@"Query" invokeParameters:params];
	
	//	
    // Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
	//
	if (self.queryResponse == nil)
	{
		queryResponse = [[QueryResponse alloc] init];
		[queryResponse setDelegate:self];
	}
	
    [parser setDelegate:queryResponse];
	
	[parser parse];
	[parser release];
}

- (void) queryWithAttributes:(NSString*)domainName expression:(NSString*)expression {
	
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
	
	[params setValue:domainName forKey:@"DomainName"];
	
	if (expression != nil)
	{
		[params setValue:expression forKey:@"QueryExpression"];
	}
	
	//
	// Invoke our method
	//
	NSXMLParser *parser = [self invoke:@"QueryWithAttributes" invokeParameters:params];
	
	//	
    // Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
	//
	if (self.queryWithAttributesResponse == nil)
	{
		queryWithAttributesResponse = [[QueryWithAttributesResponse alloc] init];
		[queryWithAttributesResponse setDelegate:self];
	}
	
    [parser setDelegate:queryWithAttributesResponse];
	
	[parser parse];
	[parser release];
}

- (void) queryWithAttributesParseComplete {
	
	//
	// All we are going to do is fire our delegate as well
	//
	if ([self.delegate respondsToSelector:@selector(queryWithAttributesComplete:)]) 
	{		
		[self.delegate queryWithAttributesComplete:self.queryWithAttributesResponse.items];
    }	
}

- (void) queryParseComplete {

	//
	// All we are going to do is fire our delegate as well
	//
	if ([self.delegate respondsToSelector:@selector(queryComplete:)]) 
	{		
		[self.delegate queryComplete:self.queryResponse.items];
    }		
}

- (void) putAttributesParseComplete {	
	//
	// All we are going to do is fire our delegate as well
	//
	if ([self.delegate respondsToSelector:@selector(putAttributesComplete)]) 
	{		
		[self.delegate putAttributesComplete];
    }	
}

- (void) createDomainParseComplete {
	//
	// All we are going to do is fire our delegate as well
	//
	if ([self.delegate respondsToSelector:@selector(createDomainComplete)]) 
	{		
		[self.delegate createDomainComplete];
    }		
}

- (void) listDomainsParseComplete {
	
	//
	// All we are going to do is fire our delegate as well
	//
	if ([self.delegate respondsToSelector:@selector(listDomainsComplete:)]) 
	{		
		[self.delegate listDomainsComplete:self.listDomainsResponse.domains];
    }		
}

- (NSXMLParser*) invoke:(NSString*)methodName invokeParameters:(NSMutableDictionary*) invokeParameters {

	//
	// First thing we need is a timestamp
	//
	NSString* timeStamp = [self getTimestamp];
	
	//
	// Build up an array of parameters in our request
	//
	NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
	
	[parameters setValue:self.key forKey:@"AWSAccessKeyId"];
	[parameters setValue:methodName forKey:@"Action"];
	[parameters setValue:@"2007-11-07" forKey:@"Version"];
	[parameters setValue:@"1" forKey:@"SignatureVersion"];
	[parameters setValue:timeStamp forKey:@"Timestamp"];	
	
	//
	// Add any additional parameters
	//
	NSEnumerator *e = [[invokeParameters allKeys] objectEnumerator];
	NSString *invokeParamName;
	
	while (invokeParamName = [e nextObject]) 
	{
		[parameters setValue:[invokeParameters valueForKey:invokeParamName] forKey:invokeParamName];
	} 
		
	//
	// This string should sort values, but not do any URL escaping; this is probably correct
	//
	NSString *stringForSignature = [self getStringForSignature:parameters];
	
	NSString *signature = [self makeSignature:secret data:[stringForSignature dataUsingEncoding:NSASCIIStringEncoding]];
	
	//
	// Now that we have our authorization signature, make our actual request and parse the return value
	//	
	NSMutableString *queryParams = [self getQueryString:parameters];
	
	//
	// Add in our signature value
	//
	[queryParams appendFormat:@"Signature=%@", [signature stringByEscapingHTTPReserved]];
	
	//
	// Construct our entire URL
	//
	NSString *urlAsString = [NSString stringWithFormat:@"http://sdb.amazonaws.com?%@", queryParams];

	NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL: [NSURL URLWithString:urlAsString]];	

	[parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];

    return parser;
}

- (NSString *)makeSignature:(NSString *)salt data:(NSData*) data {

	//
	// This will hold our signature
	//
	unsigned char digest[CC_SHA1_DIGEST_LENGTH];	
	
	//
	// Get our secret as a raw string
	//
	const char *saltCString = [salt cStringUsingEncoding:NSASCIIStringEncoding];
	
	//
	// Initialize our HMAC context
	//
	CCHmacContext hctx;
	CCHmacInit(&hctx, kCCHmacAlgSHA1, saltCString, strlen(saltCString));
		
	//
	// Add in our data
	//
	CCHmacUpdate(&hctx, [data bytes], [data length]);
	
	//
	// Create our signature
	//
	CCHmacFinal(&hctx, digest);

	//
	// Return a base64 encoded version
	//
	NSData *digestAsString = [NSData dataWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
	NSString *encodedString = [digestAsString base64Encoding];

	return encodedString;
}

- (NSMutableString*) getQueryString:(NSMutableDictionary*) parameters {

	NSMutableString *queryString = [NSMutableString string];
	
	NSEnumerator *sortedKeys = [[[parameters allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] objectEnumerator];
	NSString *sortedKey;
	
	while (sortedKey = [sortedKeys nextObject]) 
	{
		[queryString appendFormat:@"%@=%@&", sortedKey, [[parameters valueForKey:sortedKey] stringByEscapingHTTPReserved]];
	}

	return queryString;
}

- (NSString*) getStringForSignature:(NSMutableDictionary*) parameters {

	//
	// Sort alphabetically and then concat
	//
	NSMutableString *stringForSignature = [NSMutableString string];
	
	NSEnumerator *sortedKeys = [[[parameters allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] objectEnumerator];
	NSString *sortedKey;
	
	while (sortedKey = [sortedKeys nextObject]) 
	{
		[stringForSignature appendFormat:@"%@%@", sortedKey, [parameters valueForKey:sortedKey]];
	}
	
	return stringForSignature;
}

- (NSString*) getTimestamp {

	return [self dateInFormat:@"%Y-%m-%dT%H:%M:%S.000Z"]; 
}

-(NSString *) dateInFormat:(NSString*) stringFormat {
	char buffer[80];
	const char *format = [stringFormat UTF8String];
	time_t rawtime;
	struct tm * timeinfo;
	time(&rawtime);
	timeinfo = localtime(&rawtime);
	strftime(buffer, 80, format, timeinfo);
	return [NSString  stringWithCString:buffer encoding:NSUTF8StringEncoding];
}

@end

