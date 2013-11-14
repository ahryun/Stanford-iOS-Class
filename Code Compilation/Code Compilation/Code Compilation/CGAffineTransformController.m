//
//  CGAffineTransformController.m
//  Code Compilation
//
//  Created by Ahryun Moon on 11/13/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "CGAffineTransformController.h"

@interface CGAffineTransformController ()

@property (weak, nonatomic) IBOutlet UIView *surroundingView;

@end

@implementation CGAffineTransformController

#define MOVE_DURATION 3.0
#define MOVE_DELAY 1.0
#define DEGREE_TO_RADIANCE(x) M_PI * x / 180.0

- (void)rotateAndDisappear
{
    for (UIView *view in self.surroundingView.subviews) {
        CGAffineTransform transform = view.transform;
        if (CGAffineTransformIsIdentity(transform)) {
            [UIView animateWithDuration:MOVE_DURATION delay:MOVE_DELAY options:UIViewAnimationOptionCurveLinear animations:^{view.transform = CGAffineTransformRotate(CGAffineTransformScale(transform, 0.7, 0.7), DEGREE_TO_RADIANCE(120.0));} completion:^(BOOL finished){
                if (finished) [UIView animateWithDuration:MOVE_DURATION delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{view.transform = CGAffineTransformRotate(CGAffineTransformScale(transform, 0.4, 0.4), DEGREE_TO_RADIANCE(240.0));} completion:^(BOOL finished){
                    if (finished) [UIView animateWithDuration:MOVE_DURATION delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{view.transform = CGAffineTransformRotate(CGAffineTransformScale(transform, 0.1, 0.1), DEGREE_TO_RADIANCE(360.0));} completion:^(BOOL finished){
                        if (finished) [view removeFromSuperview];
                    }];
                }];
            }];
        }
    }
}

@end
