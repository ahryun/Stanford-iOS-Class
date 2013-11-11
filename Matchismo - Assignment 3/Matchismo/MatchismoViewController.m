//
//  MatchismoViewController.m
//  Matchismo
//
//  Created by Ahryun Moon on 10/9/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "MatchismoViewController.h"
#import "PlayingCard.h"
#import "PlayingDeck.h"
#import "GameLogic.h"
#import "CardCollectionViewCell.h"
#import "MatchismoCardView.h"

@interface MatchismoViewController ()

@property (strong, nonatomic) PlayingDeck *deck;
@property (strong, nonatomic) Game *game;
@property (nonatomic) NSUInteger startingCardCount;

@end

@implementation MatchismoViewController

- (NSUInteger) startingCardCount // abstract
{
    _startingCardCount = 20;
    return _startingCardCount;
}

- (Deck *)createDeck; // abstract
{
    self.deck = [[PlayingDeck alloc] init];
    return self.deck;
}

- (Game *)game
{
    if (!_game) {
        _game = [[GameLogic alloc] initWithCardCount:self.startingCardCount withDeck:[self createDeck]];
    }
    return _game;
}

- (void)flipCardItem:(int)indexItem // abstract
{
    [self.game flipCardAtIndex:indexItem];
}

- (NSUInteger)numberMatch; //abstract
{
    return 1;
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card; //abstract
{
    if ([cell isKindOfClass:[CardCollectionViewCell class]]) {
        MatchismoCardView *cardView = (MatchismoCardView *)(((CardCollectionViewCell *)cell).cardViewCell);
        if ([card isKindOfClass:[PlayingCard class]]) {
            PlayingCard *playingCard = (PlayingCard *)card;
            cardView.rank = playingCard.rank;
            cardView.suit = playingCard.suit;
            cardView.faceUp = playingCard.isFaceUp;
            if (playingCard.isUnplayable) {
                NSIndexPath *index = [self.cardCollectionView indexPathForCell:cell];
                [self.cardCollectionView performBatchUpdates:^{
                    [self.game deleteCardAtIndex:index.item];
                    [self.cardCollectionView deleteItemsAtIndexPaths:@[index]];
                } completion:nil];
            }
            //cardView.alpha = playingCard.isUnplayable ? 0.3 : 1.0;
        }
    }
}

- (void)restartGameManually
{
    [super restartGameManually];
    self.game.gameMode = 2;
    [self updateUI];
}

- (void)drawAdditionalCards:(NSUInteger)noAdditionalCards
{
    for (int i = 0; i < noAdditionalCards; i++) {
        PlayingCard *card;
        if ([self.deck.cards count]) {
            card = (PlayingCard *)[self.game drawAdditionalCardwithDeck:self.deck];
        } else {
            card = (PlayingCard *)[self.game drawAdditionalCardwithDeck:[self createDeck]];
        }
        [self.cardCollectionView performBatchUpdates:^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self.game.cards indexOfObject:card] inSection:0];
            [self.cardCollectionView insertItemsAtIndexPaths:@[indexPath]];
        } completion:nil];
    }
}

@end
