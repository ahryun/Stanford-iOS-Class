//
//  SetCard.h
//  Matchismo
//
//  Created by Ahryun Moon on 10/11/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "Card.h"


@interface SetCard : Card

@property (readonly, nonatomic) NSMutableAttributedString *shapes;
@property (nonatomic) int symbol; // 0, 1, 2
@property (nonatomic) int count; // 1, 2, 3
@property (nonatomic) NSString *color;
@property (nonatomic) NSString *shading;
@property (readonly, nonatomic) int gameMode;

- (NSAttributedString *)shapes;
- (NSDictionary *)validColorValues;
- (NSDictionary *)validShadingValues;
+ (NSArray *)validSymbols;
+ (NSArray *)validCount;
+ (NSArray *)validColors;
+ (NSArray *)validShading;

@end
