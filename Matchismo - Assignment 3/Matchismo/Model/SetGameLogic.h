//
//  SetGameLogic.h
//  Matchismo
//
//  Created by Ahryun Moon on 10/11/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Game.h"
#import "SetCard.h"

@interface SetGameLogic : Game

@property (nonatomic) NSMutableAttributedString *flipAttrContents;
- (SetCard *)cardAtIndex:(NSUInteger)index;


@end
