//
//  TagViewController.m
//  FlickrCD
//
//  Created by Ahryun Moon on 11/11/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "TagViewController.h"
#import <CoreData/CoreData.h>
#import "Tag+MKAnnotation.h"

@interface TagViewController ()

@end

@implementation TagViewController

- (void)setContext:(NSManagedObjectContext *)context
{
    _context = context;
    if (self.view.window) [self reload];
}

- (void)reload
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    request.predicate = [NSPredicate predicateWithFormat:@"photos.@count > 2"];
    NSArray *tags = [self.context executeFetchRequest:request error:nil];
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:tags];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"setTag:" sender:view];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"setTag:"]) {
        if ([sender isKindOfClass:[MKAnnotationView class]]) {
            MKAnnotationView *aView = sender;
            if ([aView.annotation isKindOfClass:[Tag class]]) {
                Tag *tag = aView.annotation;
                if ([segue.destinationViewController respondsToSelector:@selector(setTag:)]) {
                    [segue.destinationViewController performSelector:@selector(setTag:) withObject:tag];
                }
            }
        }
    }
}

@end
