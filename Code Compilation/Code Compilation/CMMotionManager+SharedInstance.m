//
//  CMMotionManager+SharedInstance.m
//  KitchenSink
//
//  Created by Ahryun Moon on 11/14/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "CMMotionManager+SharedInstance.h"

@implementation CMMotionManager (SharedInstance)

+ (CMMotionManager *)shareMotionManager
{
    static CMMotionManager *sharedManager = nil;
    if (!sharedManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedManager = [[CMMotionManager alloc] init];
        });
    }
    return sharedManager;
}



@end
