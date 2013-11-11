//
//  GameLogic.m
//  Matchismo
//
//  Created by Ahryun Moon on 10/9/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "GameLogic.h"

@implementation GameLogic


#define MATCH_BONUS 6
#define MISMATCH_PENALTY 2
#define FLIP_PENALTY 1

- (void)flipCardAtIndex:(NSUInteger)index
{
    self.flipContents = @"";
    int matchScore = 0;
    Card *chosenCard = [self cardAtIndex:index];
    NSLog(@"%@ flipped", chosenCard.contents);
    if (chosenCard && !chosenCard.isUnplayable) {
        if (!chosenCard.isFaceUp) {
            NSLog(@"Flip Count is %i", [self.flippedCards count]);
            NSLog(@"Game Mode is %i", self.gameMode);
            if ([self.flippedCards count] == self.gameMode) {
                matchScore = [chosenCard match:self.flippedCards];
                NSString *otherCardsContents = @"";
                if (matchScore) {
                    self.score += matchScore * MATCH_BONUS;
                    for (Card *otherCard in self.flippedCards) {
                        otherCard.unplayable = YES;
                        otherCardsContents = [[otherCardsContents stringByAppendingString:@" &"] stringByAppendingString:otherCard.contents];
                        
                    }
                    chosenCard.unplayable = YES;
                    self.flipContents = [self.flipContents stringByAppendingString:[NSString stringWithFormat:@"You matched %@ %@ for %i scores", chosenCard.contents, otherCardsContents, matchScore]];
                    [self.flippedCards removeAllObjects];
                    self.gameOver = ![chosenCard areMoreMatchesAvailable:[[self currentCardsPlayable] mutableCopy] withGameMode:self.gameMode];
                    
                } else {
                    for (Card *otherCard in self.flippedCards) {
                        otherCard.faceUp = NO;
                        otherCardsContents = [[otherCardsContents stringByAppendingString:@" & "] stringByAppendingString:otherCard.contents];
                    }
                    [self.flippedCards removeAllObjects];
                    [self.flippedCards addObject:chosenCard];
                    self.score -= MISMATCH_PENALTY;
                    self.flipContents = [self.flipContents stringByAppendingString:[NSString stringWithFormat:@"%@ %@ don't match! - %i scores for penalty.", chosenCard.contents, otherCardsContents, MISMATCH_PENALTY]];
                    
                }
            } else {
                [self.flippedCards addObject:chosenCard];
                NSLog(@"Flipped Cards is %@", [self.flippedCards class]);
                NSLog(@"Number of flipped cards so far is %i", [self.flippedCards count]);
            }
            self.score -= FLIP_PENALTY;
            // See if there are any more matches to be made
        } else {
            [self.flippedCards removeObject:chosenCard];
            self.flipContents = [NSString stringWithFormat:@"Flipped %@", chosenCard.contents];
        }
        chosenCard.faceUp = !chosenCard.isFaceUp;
    }
}


@end
