//
//  Photo+Flickr.m
//  FlickrCD
//
//  Created by Ahryun Moon on 11/4/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "Photo+Flickr.h"
#import "FlickrFetcher.h"
#import "Tag+Create.h"

@implementation Photo (Flickr)

+ (void)loadThumbnailDataForPhoto:(Photo *)photo withPhotoData:(NSData *)photoData inManagedObjectContext:(NSManagedObjectContext *)context
{
    [photo setThumbnailData:photoData];
}

+ (Photo *)photoWithFlickrInfo:(NSDictionary *)photoDictionary inManagedObjectContext:(NSManagedObjectContext *)context
{
    Photo *photo = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"uniqueID = %@", [photoDictionary[FLICKR_PHOTO_ID] description]];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || [matches count] > 1) {
        // Handle error
    } else if (![matches count]) {
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
        [photo setTitle:[photoDictionary[FLICKR_PHOTO_TITLE] description]];
        [photo setSubtitle:[[photoDictionary valueForKeyPath:FLICKR_PHOTO_DESCRIPTION] description]];
        [photo setPhotoURL:[[FlickrFetcher urlForPhoto:photoDictionary format:FlickrPhotoFormatLarge] absoluteString]];
        [photo setThumbnailURL:[[FlickrFetcher urlForPhoto:photoDictionary format:FlickrPhotoFormatSquare] absoluteString]];
        [photo setUniqueID:[photoDictionary[FLICKR_PHOTO_ID] description]];
        NSArray *tags = [photoDictionary[FLICKR_TAGS] componentsSeparatedByString:@" "];
        for (NSString *tagName in tags) {
            Tag *tag = [Tag tagWithName:[tagName description] withManagedObjectContext:context];
            [photo addTagsObject:tag];
        }
    } else {
        photo = [matches lastObject];
    }
    
    return photo;
}

+ (void)logLastViewed:(Photo *)photo inManagedObjectContext:(NSManagedObjectContext *)context
{
    [photo setLastViewed:[NSDate date]];
}

@end
