//
//  Photo+MKAnnotation.m
//  FlickrCD
//
//  Created by Ahryun Moon on 11/11/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "Photo+MKAnnotation.h"
#import "SharedManagedDocument.h"
#import "Photo+Flickr.h"

@implementation Photo (MKAnnotation)

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [self.latitude doubleValue];
    coordinate.longitude = [self.longitude doubleValue];
    return coordinate;
}

- (UIImage *)thumbnail
{
    dispatch_queue_t fetchQ = dispatch_queue_create("Thumbnail Fetch", nil);
    dispatch_async(fetchQ, ^{
        if (!self.thumbnailData) {
            if (self.thumbnailURL) {
                NSURL *thumbnailURL = [NSURL URLWithString:self.thumbnailURL];
                NSData *thumbnailData = [NSData dataWithContentsOfURL:thumbnailURL];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[SharedManagedDocument sharedInstance] performWithDocument:^(UIManagedDocument *document) {
                        [[self class] loadThumbnailDataForPhoto:self withPhotoData:thumbnailData inManagedObjectContext:document.managedObjectContext];
                    }];
                });
            }
        }
    });
    return [UIImage imageWithData:self.thumbnailData];
}

@end
