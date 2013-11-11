//
//  Game.h
//  Matchismo
//
//  Created by Ahryun Moon on 10/12/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "Deck.h"

@interface Game : NSObject

@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic, strong) NSMutableArray *flippedCards;
@property (nonatomic) NSString *flipContents;
@property (nonatomic) NSUInteger score;
@property (nonatomic) BOOL gameOver;
@property (nonatomic) int gameMode;
@property (nonatomic) NSUInteger cardsInPlay;

- (NSArray *)currentCardsPlayable;
- (Card *)cardAtIndex:(NSUInteger)index;
- (void)startNewGame;
- (id)initWithCardCount:(NSUInteger)count withDeck:(Deck *)deck;
- (void)flipCardAtIndex:(int)index; //abstract
- (void)deleteCardAtIndex:(NSUInteger)index;
- (Card *)drawAdditionalCardwithDeck:(Deck *)deck;

@end
