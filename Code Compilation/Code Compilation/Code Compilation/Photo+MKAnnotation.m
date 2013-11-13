//
//  Photo+MKAnnotation.m
//  Code Compilation
//
//  Created by Ahryun Moon on 11/12/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "Photo+MKAnnotation.h"

@implementation Photo (MKAnnotation) 

// <MKAnnotation> protocol must implement three getter methods for "title", "subtitle", and "coordinate"

- (NSString *)title
{
    return <#title#>
}

- (NSString *)subtitle
{
    return <#subtitle#>
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = <#latitude in doubleValue#>
    coordinate.longitude = <#longitude in doubleValue#>
    return coordinate;
}


@end
