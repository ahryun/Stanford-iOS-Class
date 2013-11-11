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

@interface MatchismoViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardViews;
@property (strong, nonatomic) GameLogic *game;
@property (strong, nonatomic) UIImage *backgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (nonatomic) BOOL flippedFirstCard;
@property (strong, nonatomic) UIAlertView *alertView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *matchMode;

@end

@implementation MatchismoViewController

- (void)viewDidLoad
{
    self.backgroundImage = [UIImage imageNamed:@"card_background.jpg"];
    [self.game setGameMode:1];
    [self updateUI];
    // Some more code here
}

- (GameLogic *)game
{
    if (!_game) {
        _game = [[GameLogic alloc] initWithCardCount:[self.cardViews count] withDeck:[[PlayingDeck alloc] init]];
        // Some more code here
    }
    return _game;
}

- (void)setCardViews:(NSArray *)cardViews
{
    _cardViews = cardViews;
}

- (void)updateUI
{
    for (UIButton *cardView in self.cardViews) {
        Card *card = [self.game cardAtIndex:[self.cardViews indexOfObject:cardView]];
        [cardView setTitle:card.contents forState:UIControlStateSelected];
        [cardView setTitle:card.contents forState:UIControlStateSelected | UIControlStateDisabled];
        cardView.selected = card.isFaceUp;
        cardView.enabled = !card.isUnplayable;
        cardView.alpha = card.isUnplayable ? 0.3 : 1.0;
        UIImage *backgroundImage = (!cardView.selected) ? self.backgroundImage : nil;
        [cardView setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    }
    self.activityLabel.text = self.game.flipContents;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %i", self.game.score];
    if (self.flippedFirstCard) {
        self.matchMode.enabled = NO;
    } else {
        self.matchMode.enabled = YES;
    }
}

- (void)restartGameManually
{
    self.game = nil;
    self.game.gameMode = self.matchMode.selectedSegmentIndex + 1;
    [self.game startNewGame];
    self.flippedFirstCard = NO;
    [self updateUI];
}

- (IBAction)restartGame:(UIButton *)sender {
    [self restartGameManually];
}

- (IBAction)changedMatchMode:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.game.gameMode = 1;
    } else if (sender.selectedSegmentIndex == 1) {
        self.game.gameMode = 2;
    }
}


- (IBAction)flip:(UIButton *)sender
{
    self.activityLabel.text = @"";
    [self.game flipCardAtIndex:[self.cardViews indexOfObject:sender]];
    self.flippedFirstCard = YES;
    [self updateUI];

    if (self.game.gameOver) {
        self.alertView = [[UIAlertView alloc] initWithTitle:@"Game Over" message:@"There are no more matches possible" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [self.alertView show];
        [self restartGameManually];
    }
}


@end
