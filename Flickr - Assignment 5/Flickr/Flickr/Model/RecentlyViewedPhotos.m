//
//  RecentlyViewedPhotos.m
//  Flickr
//
//  Created by Ahryun Moon on 10/27/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "RecentlyViewedPhotos.h"

@implementation RecentlyViewedPhotos

- (NSURL *)photoURL
{
    if (!_photoURL) {
        _photoURL = [[NSURL alloc] init];
    }
    return _photoURL;
}

- (NSDate *)lastViewed
{
    if (!_lastViewed) {
        _lastViewed = [[NSDate alloc] init];
    }
    return _lastViewed;
}

#define VIEWED_PHOTO_VIEWED @"photos"
#define VIEWED_PHOTO_VIEWED_TIME @"time"
#define VIEWED_PHOTO_TITLE @"photoTitle"
#define VIEWED_PHOTO_DESCRIPTION @"photoDescription"

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.photoURL forKey:VIEWED_PHOTO_VIEWED];
    [aCoder encodeObject:self.lastViewed forKey:VIEWED_PHOTO_VIEWED_TIME];
    [aCoder encodeObject:self.photoTitle forKey:VIEWED_PHOTO_TITLE];
    [aCoder encodeObject:self.photoDescription forKey:VIEWED_PHOTO_DESCRIPTION];
    NSLog(@"I'm getting encoded");
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _photoURL = [aDecoder decodeObjectForKey:VIEWED_PHOTO_VIEWED];
        _lastViewed = [aDecoder decodeObjectForKey:VIEWED_PHOTO_VIEWED_TIME];
        _photoTitle = [aDecoder decodeObjectForKey:VIEWED_PHOTO_TITLE];
        _photoDescription = [aDecoder decodeObjectForKey:VIEWED_PHOTO_DESCRIPTION];
    }
    NSLog(@"I'm getting decoded");
    return self;
}

@end
