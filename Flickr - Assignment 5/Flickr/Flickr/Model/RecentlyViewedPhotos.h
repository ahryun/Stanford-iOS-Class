//
//  RecentlyViewedPhotos.h
//  Flickr
//
//  Created by Ahryun Moon on 10/27/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecentlyViewedPhotos : NSObject <NSCoding>

@property (strong, nonatomic) NSURL *photoURL;
@property (strong, nonatomic) NSDate *lastViewed;
@property (strong, nonatomic) NSString *photoTitle;
@property (strong, nonatomic) NSString *photoDescription;

#define VIEWED_PHOTOS @"recentPhotos"

@end
