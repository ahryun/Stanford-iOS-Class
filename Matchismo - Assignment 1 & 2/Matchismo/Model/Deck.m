//
//  Deck.m
//  Matchismo
//
//  Created by Ahryun Moon on 10/9/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "Deck.h"

@interface Deck()

@property (nonatomic) NSMutableArray *cards;

@end


@implementation Deck

@synthesize cards = _cards;

- (NSMutableArray *)cards
{
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    
    return _cards;
}

- (void)addCard:(Card *)card atTop:(BOOL)atTop
{
    if (atTop) {
        [self.cards insertObject:card atIndex:0];
    } else {
        [self.cards addObject:card];
    }
}

- (Card *)drawRandomCard
{
    Card *randomCard = nil;
    if ([self.cards count]) {
        int index = arc4random() % [self.cards count];
        randomCard = [self cards][index];
        [self.cards removeObjectAtIndex:index];
    }
    return randomCard;
}

@end
