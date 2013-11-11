//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Ahryun Moon on 10/11/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetGameLogic.h"
#import "SetDeck.h"
#import "CardCollectionViewCell.h"
#import "SetCardView.h"

@interface SetGameViewController ()

@property (nonatomic) SetGameLogic *game;
@property (nonatomic) NSUInteger startingCardCount;
@property (nonatomic) SetDeck *deck;
@property (weak, nonatomic) IBOutlet UILabel *attrActivityLabel;

@end

@implementation SetGameViewController

- (void)restartGameManually
{
    [super restartGameManually];
    self.game.gameMode = 2;
    [self updateUI];
}

- (NSUInteger) startingCardCount // abstract
{
    _startingCardCount = 12;
    return _startingCardCount;
}

- (Deck *)createDeck // abstract
{
    self.deck = [[SetDeck alloc] init];
    return self.deck;
}

- (NSUInteger)numberMatch // abstract
{
    NSUInteger numberMatch = 2;
    return numberMatch;
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card //abstract
{
    if ([cell isKindOfClass:[CardCollectionViewCell class]]) {
        SetCardView *cardView = (SetCardView *)(((CardCollectionViewCell *)cell).cardViewCell);
        if ([card isKindOfClass:[SetCard class]]) {
            SetCard *setCard = (SetCard *)card;
            cardView.symbol = setCard.symbol;
            cardView.count = setCard.count;
            cardView.color = setCard.color;
            cardView.shading = setCard.shading;
            cardView.faceUp = setCard.isFaceUp;
            if (setCard.isUnplayable) {
                NSIndexPath *index = [self.cardCollectionView indexPathForCell:cell];
                [self.cardCollectionView performBatchUpdates:^{
                    [self.game deleteCardAtIndex:index.item];
                    [self.cardCollectionView deleteItemsAtIndexPaths:@[index]];
                } completion:nil];
            }
            //cardView.alpha = setCard.isUnplayable ? 0.3 : 1.0;
        }
    }
}

- (void)updateUI
{
    [super updateUI];
    self.attrActivityLabel.attributedText = self.game.flipAttrContents;
}

- (void)flipCardItem:(int)indexItem // abstract
{
    [self.game flipCardAtIndex:indexItem];
}

- (SetGameLogic *)game
{
    if (!_game) {
        _game = [[SetGameLogic alloc] initWithCardCount:self.startingCardCount withDeck:[self createDeck]];
    }
    return _game;
}

- (void)drawAdditionalCards:(NSUInteger)noAdditionalCards
{
    for (int i = 0; i < noAdditionalCards; i++) {
        SetCard *card;
        if ([self.deck.cards count]) {
            card = (SetCard *)[self.game drawAdditionalCardwithDeck:self.deck];
        } else {
            card = (SetCard *)[self.game drawAdditionalCardwithDeck:[self createDeck]];
        }
        [self.cardCollectionView performBatchUpdates:^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self.game.cards indexOfObject:card] inSection:0];
            [self.cardCollectionView insertItemsAtIndexPaths:@[indexPath]];
        } completion:nil];
    }
}

@end
