//
//  SetCardView.h
//  Matchismo
//
//  Created by Ahryun Moon on 10/16/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardView.h"

@interface SetCardView : CardView

@property (nonatomic) int symbol; // 0, 1, 2
@property (nonatomic) int count; // 1, 2, 3
@property (nonatomic) NSString *color;
@property (nonatomic) NSString *shading;

@end
