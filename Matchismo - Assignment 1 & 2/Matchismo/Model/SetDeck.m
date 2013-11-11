//
//  SetDeck.m
//  Matchismo
//
//  Created by Ahryun Moon on 10/11/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "SetDeck.h"
#import "SetCard.h"

@implementation SetDeck

- (id)init
{
    self = [super init];
    if (self) {
        for (NSString *shapeColor in [SetCard validColors]) {
            for (int i = 0; i < [[SetCard validSymbols] count]; i++) {
                for (NSString *shapeShading in [SetCard validShading]) {
                    for (NSNumber *shapeCount in [SetCard validCount]) {
                        SetCard *card   = [[SetCard alloc] init];
                        card.color      = shapeColor;
                        card.symbol     = i;
                        card.shading    = shapeShading;
                        card.count      = [shapeCount integerValue];
                        [self addCard:card atTop:YES];
                    }
                }
            }
        }
    }
    return self;
}

@end
