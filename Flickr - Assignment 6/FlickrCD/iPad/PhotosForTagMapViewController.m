//
//  PhotosForTagMapViewController.m
//  FlickrCD
//
//  Created by Ahryun Moon on 11/11/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "PhotosForTagMapViewController.h"

@interface PhotosForTagMapViewController ()

@end

@implementation PhotosForTagMapViewController

- (void)setTag:(Tag *)tag
{
    self.title = tag.name;
    if (self.view.window) [self reload];
}

- (void)reload
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"ANY tags = %@", self.tag];
    NSArray *tags = [self.context executeFetchRequest:request error:nil];
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:tags];
}

@end
