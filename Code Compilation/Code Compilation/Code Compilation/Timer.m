//
//  Timer.m
//  Code Compilation
//
//  Created by Ahryun Moon on 11/13/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "Timer.h"

@interface Timer ()

@property (weak, nonatomic) NSTimer *timer;

@end

@implementation Timer

#define DRAIN_DURATION 3.0

- (void)startTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:DRAIN_DURATION/3
                                                  target:self
                                                selector:@selector(<#Method#>)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startTimer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopTimer];
}

@end
