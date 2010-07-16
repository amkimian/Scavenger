//
//  PairedDevice+Extensions.m
//  CamFlow
//
//  Created by Alan Moore on 7/13/10.
//  Copyright 2010 Mount Diablo Software. All rights reserved.
//

#import "PairedDevice+Extensions.h"
#import "ASIS3BucketRequest.h"
#import "CamFolderObject.h"

@implementation PairedDeviceObject(Extensions)

-(void) ensureFoldersCorrect
{
	// If this is not ME, go onto Amazon S3 to find out the folders for this
	// DEVICE ID
	//if ([self.isMe boolValue] == YES)
	//{
	//	return;
	//}
	
	ASIS3BucketRequest *bRequest = [ASIS3BucketRequest requestWithBucket:@"camflow-images"];
	bRequest.prefix = [NSString stringWithFormat: @"%@/", self.deviceId];
	bRequest.delimiter = @"/";
	
	[bRequest startSynchronous];
	
	NSDictionary *rh = bRequest.requestHeaders;
	for(NSString *key in [rh keyEnumerator])
	{
		NSLog(@"Key = %@, Value = %@", key, [rh objectForKey:key]);
	}
	
	self.folders = nil;
	
	NSEntityDescription *edesc = [NSEntityDescription entityForName:@"CamFolder" inManagedObjectContext:[self managedObjectContext]];
	
	for(NSString *folder in bRequest.commonPrefixes)
	{
		NSArray *folderParts = [folder pathComponents];
		NSString *realFolder = [folderParts objectAtIndex:1];
		CamFolderObject *cf = [[CamFolderObject alloc] initWithEntity:edesc insertIntoManagedObjectContext:[self managedObjectContext]];
		cf.folderName = realFolder;
		[self addFoldersObject:cf];
	}
}

@end
