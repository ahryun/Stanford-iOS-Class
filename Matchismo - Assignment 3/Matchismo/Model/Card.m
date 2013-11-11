//
//  Card.m
//  Matchismo
//
//  Created by Ahryun Moon on 10/9/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "Card.h"

@implementation Card

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    for (Card *card in otherCards) {
        if ([card.contents isEqualToString:self.contents]) {
            score = 1;
        }
    }
    return score;
}

- (BOOL)areMoreMatchesAvailable:(NSMutableArray *)cards withGameMode:(int)gameMode
{
    return NO;
}

@end
