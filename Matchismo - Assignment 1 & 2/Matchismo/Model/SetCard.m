//
//  SetCard.m
//  Matchismo
//
//  Created by Ahryun Moon on 10/11/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "SetCard.h"

@interface SetCard()

@property (readwrite, nonatomic) int gameMode;
@property (readwrite, nonatomic) NSMutableAttributedString *shapes;

@end

@implementation SetCard

- (NSMutableAttributedString *)shapes
{
    if (!_shapes) {
        NSString *symbolText = @"";
        for (int i = 0; i < self.count; i++) {
            symbolText = [symbolText stringByAppendingString:[SetCard validSymbols][self.symbol]];
        }
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:symbolText];
        NSRange range = [[attributedString string] rangeOfString:symbolText];
        [attributedString addAttributes:[self validShadingValues][self.shading] range:range];
        _shapes = attributedString;
    }
    
    return _shapes;
}

@synthesize color = _color;
- (NSString *)color
{
    return _color ? _color : @"?";
}

- (void)setColor:(NSString *)color
{
    if ([[SetCard validColors] containsObject:color]) {
        _color = color;
    }
}

@synthesize shading = _shading;
- (NSString *)shading
{
    return _shading ? _shading : @"?";
}

- (void)setShading:(NSString *)shading
{
    if ([[SetCard validShading] containsObject:shading]) {
        _shading = shading;
    }
}

@synthesize count = _count;
- (int)count
{
    return _count <= [[SetCard validCount] count] ? _count : 3;
}

- (void)setCount:(int)count
{
    if ([[SetCard validCount] containsObject:[NSNumber numberWithInt:count]]) {
        _count = count;
    }
}

- (int)symbol
{
    return _symbol < [[SetCard validSymbols] count] ? _symbol : 0;
}


+ (NSArray *)validSymbols
{
    return @[@"★", @"✤", @"■"];
}

+ (NSArray *)validCount
{
    return @[@1, @2, @3];
}

+ (NSArray *)validColors
{
    return @[@"red", @"green", @"blue"];
}

+ (NSArray *)validShading
{
    return @[@"solid", @"opaque", @"transparent"];
}

- (NSDictionary *)validColorValues
{
    return @{@"red":[UIColor redColor], @"green":[UIColor greenColor], @"blue":[UIColor blueColor]};
}

- (NSDictionary *)validShadingValues
{
    return @{@"solid": @{NSForegroundColorAttributeName: [self validColorValues][self.color]},
             @"opaque": @{NSForegroundColorAttributeName: [[self validColorValues][self.color] colorWithAlphaComponent:.5]},
             @"transparent": @{NSForegroundColorAttributeName: [UIColor clearColor],
                               NSStrokeColorAttributeName: [self validColorValues][self.color],
                               NSStrokeWidthAttributeName: @-5}};
}

- (int)match:(NSArray *)otherCards
{
    // Write this function
    int match = 0;
    for (SetCard *card in otherCards) {
        int match = 0;
        if ([card.color isEqualToString:self.color]) match++;
        if (card.symbol == self.symbol) match++;
        if (card.count == self.count) match++;
        if ([card.shading isEqualToString:self.shading]) match++;
        NSLog(@"%i", match);
        if (match != 3) {
            return 0;
        }
    }
    return match != 3 ? 1 : 0;
}


@end
