//
//  PlayingCard.m
//  Matchismo
//
//  Created by Ahryun Moon on 10/9/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "PlayingCard.h"

@interface PlayingCard()

@property (nonatomic) NSUInteger maxRank;
@property (nonatomic) int gameMode;

@end

@implementation PlayingCard

- (NSString *)contents
{
    
    return [[PlayingCard rankStrings][self.rank] stringByAppendingString:self.suit];
}

+ (NSArray *)validSuits
{
    return @[@"♥", @"♦", @"♠", @"♣"];
}

+ (NSUInteger)maxRank
{
    return [[PlayingCard rankStrings] count] - 1;
}

+ (NSArray *)rankStrings
{
    return @[@"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

@synthesize suit = _suit;
- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) _rank = rank;
}

- (BOOL)enoughMatchingRanks:(NSArray *)filteredArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (PlayingCard *card in filteredArray) {
        if (![array containsObject:[NSNumber numberWithInt:card.rank]]) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"rank == %i", card.rank];
            int count = [[filteredArray filteredArrayUsingPredicate:predicate] count];
            if (count > self.gameMode) {
                return YES;
            } else {
                [array addObject:[NSNumber numberWithInt:card.rank]];
            }
        }
    }
    return NO;
}

- (BOOL)enoughMatchingSuits:(NSArray *)filteredArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (PlayingCard *card in filteredArray) {
        if (![array containsObject:card.suit]) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"suit == %@", card.suit];
            int count = [[filteredArray filteredArrayUsingPredicate:predicate] count];
            if (count > self.gameMode) {
                return YES;
            } else {
                [array addObject:@(card.rank)];
            }
        }
    }
    
    return NO;
}

- (BOOL)areMoreMatchesAvailable:(NSMutableArray *)cards withGameMode:(int)gameMode
{
    self.gameMode = gameMode;
    if ([self enoughMatchingRanks:cards] || [self enoughMatchingSuits:cards]) {
        return YES;
    }
    return NO;
}

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    int cardIndex = 0;
    BOOL shouldMatchSuit;
    for (PlayingCard *card in otherCards) {
        if (cardIndex == 0) {
            if (card.suit == self.suit) {
                score += 1;
                shouldMatchSuit = YES;
            }
            else if (card.rank == self.rank) {
                score += 2;
                shouldMatchSuit = NO;
            }
            cardIndex ++;
        } else {
            if (shouldMatchSuit) {
                if (card.suit == self.suit) {
                    score = score * 4;
                } else {
                    score = 0;
                    break;
                }
            } else {
                if (card.rank == self.rank) {
                    score = score * 8;
                } else {
                    score = 0;
                    break;
                }
            }
        }
    }
    return score;
}


@end
