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

@interface SetGameViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *setCardViews;
@property (weak, nonatomic) IBOutlet UILabel *setActivityLabel;
@property (weak, nonatomic) IBOutlet UILabel *setScoreLabel;
@property (strong, nonatomic) SetGameLogic *game;
@property (nonatomic) BOOL flippedFirstCard;
@property (nonatomic) BOOL gameOver;
@property (strong, nonatomic) UIAlertView *alertView;

@end

@implementation SetGameViewController

- (void)viewDidLoad
{
    [self.game setGameMode:2];
    [self updateUI];
}

- (SetGameLogic *)game
{
    if (!_game) {
        _game = [[SetGameLogic alloc] initWithCardCount:[self.setCardViews count] withDeck:[[SetDeck alloc] init]];
    }
    return _game;
}

- (void)setsetCardViews:(NSArray *)setCardView
{
    _setCardViews = setCardView;
}

- (void)restartGameManually
{
    self.game = nil;
    self.game.gameMode = 2;
    [self.game startNewGame];
    self.flippedFirstCard = NO;
    [self updateUI];
}

- (IBAction)restartGame:(UIButton *)sender {
    [self restartGameManually];
}

- (void)updateUI
{
    for (UIButton *setCardView in self.setCardViews) {
        SetCard *card           = [self.game cardAtIndex:[self.setCardViews indexOfObject:setCardView]];
        setCardView.selected    = card.isFaceUp;
        setCardView.enabled     = !card.isUnplayable;
        setCardView.alpha       = card.isUnplayable ? 0.3 : 1.0;
        [setCardView setAttributedTitle:[card.shapes copy] forState:UIControlStateNormal];
        card.isFaceUp ? [setCardView setBackgroundColor:[UIColor grayColor]] : [setCardView setBackgroundColor:[UIColor whiteColor]];
    }
    self.setActivityLabel.attributedText  = self.game.flipAttrContents;
    self.setScoreLabel.text     = [NSString stringWithFormat:@"Score: %i", self.game.score];
}


- (IBAction)flip:(UIButton *)sender {
    self.setActivityLabel.text = @"";
    [self.game flipCardAtIndex:[self.setCardViews indexOfObject:sender]];
    self.flippedFirstCard = YES;
    [self updateUI];
    
    if (self.game.gameOver) {
        self.alertView = [[UIAlertView alloc] initWithTitle:@"Game Over" message:@"There are no more matches possible" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [self.alertView show];
        [self restartGameManually];
    }
}


@end
