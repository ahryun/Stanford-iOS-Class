//
//  Orientation Change.m
//  Code Compilation
//
//  Created by Ahryun Moon on 11/8/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "Orientation Change.h"

@interface Orientation_Change ()

@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingSpinner;

@end

@implementation Orientation_Change

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
}

- (void)orientationChanged:(NSNotification *)note
{
    UIDevice *device = note.object;
    switch (device.orientation) {
        case UIDeviceOrientationPortrait:
            // Do something to reset the image
            break;
        default:
            // Do something to reset the image
            break;
    }
}

@end
