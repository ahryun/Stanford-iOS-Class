//
//  CMMotionManager+SharedInstance.h
//  KitchenSink
//
//  Created by Ahryun Moon on 11/14/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>

@interface CMMotionManager (SharedInstance)

+ (CMMotionManager *)shareMotionManager;

@end
