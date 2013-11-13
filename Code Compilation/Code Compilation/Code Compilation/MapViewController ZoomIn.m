//
//  MapViewController ZoomIn.m
//  Code Compilation
//
//  Created by Ahryun Moon on 11/12/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "MapViewController ZoomIn.h"

@interface MapViewController_ZoomIn ()

@property (nonatomic) BOOL needUpdateRegion;

@end

@implementation MapViewController_ZoomIn

// needUpdateRegion is a BOOL property
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.needUpdateRegion) [self updateRegion];
}

- (void)updateRegion
{
    self.needUpdateRegion = NO;
    CGRect boundingRect;
    BOOL started = NO;
    // all objects that implement MKAnnotation protocol
    for (id <MKAnnotation> annotation in self.mapView.annotations) {
        CGRect annotationRect = CGRectMake(annotation.coordinate.latitude, annotation.coordinate.longitude, 0, 0);
        if (!started) {
            started = YES;
            boundingRect = annotationRect;
        } else {
            boundingRect = CGRectUnion(boundingRect, annotationRect);
        }
    }
    if (started) {
        boundingRect = CGRectInset(boundingRect, -0.2, -0.2);
        if (boundingRect.size.width < 20 && boundingRect.size.height < 20) {
            MKCoordinateRegion region;
            region.center.latitude = boundingRect.origin.x + (boundingRect.size.width / 2);
            region.center.longitude = boundingRect.origin.y + (boundingRect.size.height / 2);
            region.span.latitudeDelta = boundingRect.size.width;
            region.span.longitudeDelta = boundingRect.size.height;
            [self.mapView setRegion:region animated:YES];
        }
    }
}

@end
