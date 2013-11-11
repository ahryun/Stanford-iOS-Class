//
//  Photo+Flickr.h
//  FlickrCD
//
//  Created by Ahryun Moon on 11/4/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "Photo.h"

@interface Photo (Flickr)

+ (Photo *)photoWithFlickrInfo:(NSDictionary *)photoDictionary inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

+ (void)loadThumbnailDataForPhoto:(Photo *)photo withPhotoData:(NSData *)photoData inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)logLastViewed:(Photo *)photo inManagedObjectContext:(NSManagedObjectContext *)context;

@end
