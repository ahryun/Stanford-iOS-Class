//
//  Tag+MKAnnotation.m
//  FlickrCD
//
//  Created by Ahryun Moon on 11/11/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "Tag+MKAnnotation.h"
#import "Photo+MKAnnotation.h"

@implementation Tag (MKAnnotation)

// <MKAnnotation> protocol must implement three getter methods for "title", "subtitle", and "coordinate"

- (NSString *)title
{
    return self.name;
}

- (NSString *)subtitle
{
    return [NSString stringWithFormat:@"%d Photos", [self.photos count]];
}

- (CLLocationCoordinate2D)coordinate
{
    return [[self.photos anyObject] coordinate];
}

- (UIImage *)thumbnail
{
    return [[self.photos anyObject] thumbnail];
}

@end
