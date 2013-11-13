//
//  MapViewController.h
//  Code Compilation
//
//  Created by Ahryun Moon on 11/12/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, strong) MKMapView *mapView;

@end
