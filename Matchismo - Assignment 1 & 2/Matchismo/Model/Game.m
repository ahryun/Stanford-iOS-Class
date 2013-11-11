//
//  Game.m
//  Matchismo
//
//  Created by Ahryun Moon on 10/12/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "Game.h"

@implementation Game

- (NSArray *)currentCardsPlayable
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"unplayable == %i", 0];
    NSArray *filteredArray = [self.cards filteredArrayUsingPredicate:predicate];
    return filteredArray;
}


// Designated initializer
- (id)initWithCardCount:(NSUInteger)count withDeck:(Deck *)deck
{
    self = [super init];
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
    }
    return self;
}

- (NSMutableArray *)cards
{
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}

- (NSMutableArray *)flippedCards
{
    if (!_flippedCards) {
        _flippedCards = [[NSMutableArray alloc] init];
    }
    return _flippedCards;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? [self.cards objectAtIndex:index] : nil;
}

- (void)startNewGame
{
    self.score = 0;
    self.flipContents = @"";
    self.gameOver = NO;
    [self.flippedCards removeAllObjects];
    for (Card *card in self.cards) {
        if (card.faceUp) {
            card.faceUp = !card.isFaceUp;
        }
        if (card.unplayable) {
            card.unplayable = !card.isUnplayable;
        }
    }
}

- (void)flipCardAtIndex:(NSUInteger)index
{
    //abstract
}

@end
