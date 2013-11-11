//
//  CardView.h
//  Matchismo
//
//  Created by Ahryun Moon on 10/16/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardView : UIView

@property (nonatomic) BOOL faceUp;
@property (nonatomic) CGFloat scaleFactor;
- (void)drawInside; // abstract
- (void)pinch:(UIPinchGestureRecognizer *)gesture;

@end
