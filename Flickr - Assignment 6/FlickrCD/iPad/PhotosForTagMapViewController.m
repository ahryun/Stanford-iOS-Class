//
//  PhotosForTagMapViewController.m
//  FlickrCD
//
//  Created by Ahryun Moon on 11/11/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "PhotosForTagMapViewController.h"
#import "Photo+MKAnnotation.h"
#import "ImageVC.h"

@interface PhotosForTagMapViewController ()

@end

@implementation PhotosForTagMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self reload];
}

- (void)setTag:(Tag *)tag
{
    _tag = tag;
    self.title = tag.name;
    if (self.view.window) [self reload];
}

- (void)reload
{
    NSArray *photos = [self.tag.photos allObjects];
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:photos];
    Photo *photo = [photos lastObject];
    if (photo) self.mapView.centerCoordinate = photo.coordinate;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"setPhoto:" sender:view];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"setPhoto:"]) {
        if ([sender isKindOfClass:[MKAnnotationView class]]) {
            MKAnnotationView *aView = sender;
            if ([aView.annotation isKindOfClass:[Photo class]]) {
                Photo *photo = aView.annotation;
                if ([segue.destinationViewController respondsToSelector:@selector(setPhoto:)]) {
                    [segue.destinationViewController performSelector:@selector(setPhoto:) withObject:photo];
                }
            }
        }
    }
}

@end
