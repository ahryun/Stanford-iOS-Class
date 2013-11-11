//
//  SetGameLogic.m
//  Matchismo
//
//  Created by Ahryun Moon on 10/11/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "SetGameLogic.h"

@implementation SetGameLogic

- (SetCard *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? [self.cards objectAtIndex:index] : nil;
}


#define MATCH_BONUS 6
#define MISMATCH_PENALTY 2
#define FLIP_PENALTY 1

- (void)flipCardAtIndex:(int)index
{
    self.flipAttrContents = [[NSMutableAttributedString alloc] init];
    int matchScore = 0;
    SetCard *chosenCard = [self cardAtIndex:index];
    if (chosenCard && !chosenCard.isUnplayable) {
        if (!chosenCard.isFaceUp) {
            // 1. Flip over the chosen card
            chosenCard.faceUp = !chosenCard.isFaceUp;
            if ([self.flippedCards count] == self.gameMode) {
                matchScore = [chosenCard match:self.flippedCards];
                if (matchScore) {
                    // 1. Make the most recent card unplayable
                    chosenCard.unplayable = !chosenCard.isUnplayable;
                    // 2. Make all flippedCards unplayable
                    NSMutableAttributedString *otherCardContents = [[NSMutableAttributedString alloc] init];
                    for (SetCard *card in self.flippedCards) {
                        card.unplayable = !card.isUnplayable;
                        NSMutableAttributedString *tempString = [card.shapes mutableCopy];
                        [tempString insertAttributedString:[[NSMutableAttributedString alloc] initWithString:@" & "] atIndex:0];
                        [otherCardContents appendAttributedString:tempString];
                        //[self deleteCard:card];
                    }
                    // 3. Calculate score
                    matchScore += matchScore * MATCH_BONUS;
                    self.score += matchScore;
                    // 4. Put wording in flipAttrContents
                    NSMutableAttributedString *attrFlipContents = [chosenCard.shapes mutableCopy];
                    [attrFlipContents appendAttributedString:otherCardContents];
                    NSMutableAttributedString *bonusScore = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" are a set! Bonus score %i points", matchScore]];
                    [attrFlipContents appendAttributedString:bonusScore];
                    self.flipAttrContents = attrFlipContents;
                    //[self deleteCard:chosenCard];
                } else {
                    // 1. Flip the chosen card over and make it face down
                    chosenCard.faceUp = !chosenCard.isFaceUp;
                    // 2. Make all flippedCards face down
                    NSMutableAttributedString *otherCardContents = [[NSMutableAttributedString alloc] init];
                    for (SetCard *card in self.flippedCards) {
                        card.faceUp = !card.isFaceUp;
                        NSMutableAttributedString *tempString = [card.shapes mutableCopy];
                        [tempString insertAttributedString:[[NSMutableAttributedString alloc] initWithString:@" & "] atIndex:0];
                        [otherCardContents appendAttributedString:tempString];
                    }
                    // 2. Give them mismatch penalty
                    self.score -= MISMATCH_PENALTY;
                    // 3. Put wording in flipAttrContents
                    NSMutableAttributedString *attrFlipContents = [chosenCard.shapes mutableCopy];
                    [attrFlipContents appendAttributedString:otherCardContents];
                    NSMutableAttributedString *bonusScore = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" are not a set! Penalty of %i points", MISMATCH_PENALTY]];
                    [attrFlipContents appendAttributedString:bonusScore];
                    self.flipAttrContents = attrFlipContents;
                }
                // 1. Clear flippedCards array
                [self.flippedCards removeAllObjects];
            } else {
                // 1. Add to flippedCards array
                [self.flippedCards addObject:chosenCard];
                // 2. Give it a flipe penalty
                self.score -= FLIP_PENALTY;
                self.flipAttrContents = [[NSMutableAttributedString alloc] initWithString:@"Flipped "];
                [self.flipAttrContents appendAttributedString:chosenCard.shapes];
            }
        } else {
            // 1. Make it face down
            chosenCard.faceUp = !chosenCard.isFaceUp;
            // 2. Remove from flippedCards array
            [self.flippedCards removeObject:chosenCard];
        }
    }
}

@end
