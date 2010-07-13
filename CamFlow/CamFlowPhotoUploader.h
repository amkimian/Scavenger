//
//  CamFlowPhotoUploader.h
//  CamFlow
//
//  Created by Alan Moore on 7/12/10.
//  Copyright 2010 Mount Diablo Software. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * This is used to handle the general case of:
 * 1. Taking an image
 * 2. Adding a timestamp or other watermark
 * 3. Uploading that image to S3
 * 4. Creating an info file about that image
 * 5. And uploading that image file as well
 */

@interface CamFlowPhotoUploader : NSObject {

}

-(void) uploadImage: (UIImage *) image toFolder: (NSString *) folder;

@end
