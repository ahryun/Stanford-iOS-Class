//
//  zoomInScroll.m
//  Code Compilation
//
//  Created by Ahryun Moon on 11/8/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "zoomInScroll.h"

@interface zoomInScroll ()

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation zoomInScroll


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView // makes zooming possible
{
    return self.imageView;
}

@end
