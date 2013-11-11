//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Ahryun Moon on 10/16/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardCollectionViewCell.h"
#import "Card.h"

@interface CardGameViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) NSUInteger startingCardCount; // abstract
@property (nonatomic) BOOL flippedFirstCard;
@property (strong, nonatomic) UIAlertView *alertView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) Game *game;
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;

@end

@implementation CardGameViewController

- (void)setCardCollectionView:(UICollectionView *)cardCollectionView
{
    _cardCollectionView = cardCollectionView;
    for (CardCollectionViewCell *cell in cardCollectionView.visibleCells) {
        [cell.cardViewCell addGestureRecognizer:[[UIGestureRecognizer alloc] initWithTarget:cell.cardViewCell action:@selector(pinch:)]];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.game.cards count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.cardCollectionView
                                  dequeueReusableCellWithReuseIdentifier:@"Card"
                                  forIndexPath:indexPath];
    
    Card *card = [self.game cardAtIndex:indexPath.item];
    [self updateCell:cell usingCard:card];
    return cell;
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card // abstract
{
    nil;
}

- (NSUInteger)numberMatch
{
    return 1;
}

- (void)viewDidLoad
{
    [self.game setGameMode:[self numberMatch]];
    [self updateUI];
}

- (Deck *)createDeck // abstract
{
    return nil;
}

- (void)updateUI
{
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        [self updateCell:cell usingCard:card];
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %i", self.game.score];
    self.activityLabel.text = self.game.flipContents;
}

- (IBAction)flip:(UITapGestureRecognizer *)gesture
{
    CGPoint tabLocation = [gesture locationInView:self.cardCollectionView];
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tabLocation];
    if (indexPath) {
        [self flipCardItem:indexPath.item];
        CardCollectionViewCell *cell = (CardCollectionViewCell *)[self.cardCollectionView cellForItemAtIndexPath:indexPath];
        Card *card = [self.game cardAtIndex:indexPath.item];
        if (!card.unplayable) {
            [UIView transitionWithView:cell.cardViewCell
                              duration:0.5
                               options:UIViewAnimationOptionTransitionFlipFromLeft
                            animations:^{cell.cardViewCell.faceUp = !cell.cardViewCell.faceUp;}
                            completion:0];
        }
        self.flippedFirstCard = YES;
        [self updateUI];
    }
}

- (void)flipCardItem:(int)indexItem // abstract
{
    nil;
}

- (void)restartGameManually
{
    self.game = nil;
    [self.game startNewGame];
    [self.cardCollectionView reloadData];
    self.flippedFirstCard = NO;
}

- (IBAction)restartGame:(UIButton *)sender {
    [self restartGameManually];
}

- (void)drawAdditionalCards:(NSUInteger)noAdditionalCards // abstract
{
    nil;
}


- (IBAction)drawThreeCards:(UIButton *)sender {
    NSUInteger noAdditionalCards = 3;
    [self drawAdditionalCards:noAdditionalCards];
    CGPoint bottomOffset = CGPointMake(0, self.cardCollectionView.contentSize.height - self.cardCollectionView.bounds.size.height);
    [self.cardCollectionView setContentOffset:bottomOffset animated:YES];
}


@end
