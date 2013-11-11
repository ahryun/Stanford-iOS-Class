//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Ahryun Moon on 10/16/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "Game.h"

@interface CardGameViewController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
- (Deck *)createDeck; // abstract
- (NSUInteger)numberMatch; // abstract
- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card; //abstract
- (void)flipCardItem:(int)indexItem; // abstract
- (void)drawAdditionalCards:(NSUInteger)noAdditionalCards; // abstract

- (void)restartGameManually;
- (void)updateUI;

@end
