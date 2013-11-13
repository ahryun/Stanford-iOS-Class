//
//  Photo+MKAnnotation.h
//  FlickrCD
//
//  Created by Ahryun Moon on 11/11/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "Photo.h"
#import <MapKit/MapKit.h>

@interface Photo (MKAnnotation) <MKAnnotation>

- (UIImage *)thumbnail;

@end
