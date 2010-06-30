//
//  SimpleDb.h
//  GetSomeSnow
//
//  Created by Eric Lee on 12/11/08.
//  Copyright LearnAws.com 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>

#import "ListDomainsResponse.h"
#import "CreateDomainResponse.h"
#import "PutAttributesResponse.h"
#import "DeleteAttributesResponse.h"
#import "SimpleDbAttribute.h"
#import "QueryResponse.h"
#import "QueryWithAttributesResponse.h"

@interface NSObject (SimpleDbDelegate)

- (NSString*) getUniqueId;

- (void) listDomainsComplete:(NSMutableArray*) domains;
- (void) createDomainComplete;
- (void) putAttributesComplete;
- (void) deleteAttributesComplete;
- (void) queryComplete:(NSMutableArray*) items;
- (void) queryWithAttributesComplete:(NSMutableArray*) items;

@end

@interface SimpleDb : NSObject {

	NSString *key;
	NSString *secret;
	id delegate;
	
	ListDomainsResponse *listDomainsResponse;
	CreateDomainResponse *createDomainResponse;
	PutAttributesResponse *putAttributesResponse;
	DeleteAttributesResponse *deleteAttributesResponse;
	QueryResponse *queryResponse;
	QueryWithAttributesResponse *queryWithAttributesResponse;
}

@property (nonatomic, retain) NSString* key;
@property (nonatomic, retain) NSString* secret;
@property (nonatomic, retain) id delegate;
@property (nonatomic, retain) ListDomainsResponse* listDomainsResponse;
@property (nonatomic, retain) CreateDomainResponse* createDomainResponse;
@property (nonatomic, retain) PutAttributesResponse* putAttributesResponse;
@property (nonatomic, retain) DeleteAttributesResponse* deleteAttributesResponse;
@property (nonatomic, retain) QueryResponse* queryResponse;
@property (nonatomic, retain) QueryWithAttributesResponse *queryWithAttributesResponse;

//
// Need to call this first
//
- (void) setAWSAccount:(NSString*) key secret:(NSString*) secret; 

//
// SimpleDB API methods
//
- (void) listDomains;
- (void) createDomain:(NSString*)name;

//
// attributes must be a NSMutableArray of SimpleDbAttribute
//
- (void) deleteAttributes: (NSString*) domainName itemName:(NSString*) itemName attributes:(NSMutableArray*) attributes;
- (void) putAttributes:(NSString*)domainName itemName:(NSString*)itemName attributes:(NSMutableArray*)attributes;

//
// TODO should put in max items and token for these two, but we'll do that if and when we need to
//
- (void) query:(NSString*)domainName expression:(NSString*)expression;

//
// TODO at some point add in the attributes that we want, but I think for now we are just going to always get 
// back all of the attributes anyways
//
- (void) queryWithAttributes:(NSString*)domainName expression:(NSString*)expression;

//
// Delegates to let us know when parsing is complete
//
- (void) listDomainsParseComplete;
- (void) createDomainParseComplete;
- (void) putAttributesParseComplete;
- (void) queryParseComplete;
- (void) queryWithAttributesParseComplete;
- (void) deleteAttributesParseComplete;

//
// Helper methods for making SimpleDb API calls
//
- (NSXMLParser*) invoke:(NSString*)methodName invokeParameters:(NSMutableDictionary*) invokeParameters;

//
// Methods to generate our authorization signature
//
- (NSString*) getTimestamp;
- (NSMutableString*) getQueryString:(NSMutableDictionary*) parameters;
- (NSString*) getStringForSignature:(NSMutableDictionary*) parameters;
- (NSString *)makeSignature:(NSString *)salt data:(NSData*) data;
-(NSString *) dateInFormat:(NSString*) stringFormat;
@end
