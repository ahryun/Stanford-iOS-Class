//
//  Accelerometer.m
//  Code Compilation
//
//  Created by Ahryun Moon on 11/14/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "Accelerometer.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "CMMotionManager+SharedInstance.h"

@interface Accelerometer ()

@end

@implementation Accelerometer

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startDrift];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopDrift];
}

#pragma mark - Drift

#define DRIFT_HERTZ 10
#define DRIFT_RATE 10
- (void)startDrift
{
    CMMotionManager *sharedManager = [CMMotionManager shareMotionManager];
    if ([sharedManager isAccelerometerAvailable]) {
        [sharedManager setAccelerometerUpdateInterval:DRIFT_HERTZ];
        [sharedManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *data, NSError *error) {
            for (UIView *view in self.<#Surrounding View#>.subviews) {
                CGPoint center = view.center;
                center.x += data.acceleration.x * DRIFT_RATE;
                center.y -= data.acceleration.y * DRIFT_RATE;
                view.center = center;
                if (!CGRectContainsRect(self.<#Surrounding View#>.bounds, view.frame) && !CGRectIntersectsRect(self.<#Surrounding View#>.bounds, view.frame)) {
                    [view removeFromSuperview];
                }
            }
        }];
    }
}

- (void)stopDrift
{
    [[CMMotionManager shareMotionManager] stopAccelerometerUpdates];
}
@end
