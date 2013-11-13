//
//  MapViewController.m
//  Code Compilation
//
//  Created by Ahryun Moon on 11/12/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

// Set up IBOutlet MKMapView *mapView
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *reuseID = @"MapViewAnnotation";
    MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseID];
    if (!view) {
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseID];
        view.canShowCallout = YES;
        if ([mapView.delegate respondsToSelector:@selector(mapView:annotationView:calloutAccessoryControlTapped:)]) {
            view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        }
        view.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,30,30)];
        if ([view.leftCalloutAccessoryView isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView *)view.leftCalloutAccessoryView;
            imageView.image = nil;
        }
    }
    return view;
}

// When the user taps a pin
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view.leftCalloutAccessoryView isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView *)view.leftCalloutAccessoryView;
        if ([view.annotation respondsToSelector:@selector(<#method to set an image in leftcalloutview#>)]) {
            imageView.image = [view.annotation performSelector:@selector(<#method to set an image in leftcalloutview#>)];
        }
    }
}

@end
