//
//  MatchismoCardView.m
//  Matchismo
//
//  Created by Ahryun Moon on 10/16/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "MatchismoCardView.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation MatchismoCardView

#define DEFAULT_SCALE_FACTOR 0.80

@synthesize scaleFactor = _scaleFactor;
- (void)setScaleFactor:(CGFloat)scaleFactor
{
    _scaleFactor = scaleFactor;
    [self setNeedsDisplay];
    
}

- (CGFloat)scaleFactor
{
    if (!_scaleFactor) {
        _scaleFactor = DEFAULT_SCALE_FACTOR;
        return _scaleFactor;
    }
    return _scaleFactor;
}

- (void)drawInside
{
    if (self.faceUp) {
        [self drawCorners];
        
        UIImage *faceImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@.jpg", [self rankStrings][self.rank], self.suit]];
        if (faceImage) {
            CGRect faceImageRect = CGRectInset(self.bounds,
                                               self.bounds.size.width * (1.0 - self.scaleFactor),
                                               self.bounds.size.height * (1.0 - self.scaleFactor));
            [faceImage drawInRect:faceImageRect];
        } else {
            [self drawPips];
        }
    } else {
        [[UIImage imageNamed:@"card_background.jpg"] drawInRect:self.bounds];
    }
}

- (void)drawPips
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    UIFont *font = [UIFont systemFontOfSize:self.bounds.size.width * 0.15];
    
    NSMutableString *topString = [[NSMutableString alloc] initWithString:@""];
    NSMutableString *bottomString = [[NSMutableString alloc] initWithString:@""];
    if (self.rank == 0 || self.rank == 1) {
        topString = [self createPips:1];
    } else if (self.rank == 2 || self.rank == 3) {
        topString = [self createPips:2];
    } else if (self.rank == 4) {
        topString = [self createPips:3];
    } else if (self.rank == 5) {
        topString = [self createPips:4];
    } else if (self.rank == 6 || self.rank == 7 || self.rank == 8 || self.rank == 9) {
        topString = [self createPips:5];
    }
    
    if (self.rank == 1 || self.rank == 2) {
        bottomString = [self createPips:1];
    } else if (self.rank == 3 || self.rank == 4 || self.rank == 5 || self.rank == 6) {
        bottomString = [self createPips:2];
    } else if (self.rank == 7) {
        bottomString = [self createPips:3];
    } else if (self.rank == 8) {
        bottomString = [self createPips:4];
    } else if (self.rank == 9) {
        bottomString = [self createPips:5];
    }
    NSMutableAttributedString *topAttrString = [[NSMutableAttributedString alloc] initWithString:topString attributes:@{ NSParagraphStyleAttributeName:paragraphStyle, NSFontAttributeName:font }];
    NSMutableAttributedString *bottomAttrString = [[NSMutableAttributedString alloc] initWithString:bottomString attributes:@{ NSParagraphStyleAttributeName:paragraphStyle, NSFontAttributeName:font }];
    
    CGRect pipRect = CGRectMake(self.bounds.size.width * 0.10, self.bounds.size.height * 0.10, self.bounds.size.width * 0.80, self.bounds.size.width * 0.60);
    [topAttrString drawInRect:pipRect];
    [self pushContextAndRorate];
    [bottomAttrString drawInRect:pipRect];
    [self popContext];
}

- (NSMutableString *)createPips:(int)numberOfPips
{
    NSMutableString *mutableString = [[NSMutableString alloc] initWithString:@""];
    if (numberOfPips < 6 && numberOfPips > 0) {
        switch (numberOfPips) {
            case 1:
                mutableString = [[NSMutableString alloc] initWithFormat:@"%@", self.suit];
                break;
            case 2:
                mutableString = [[NSMutableString alloc] initWithFormat:@"%@ %@", self.suit, self.suit];
                break;
            case 3:
                mutableString = [[NSMutableString alloc] initWithFormat:@"%@ %@\n%@", self.suit, self.suit, self.suit];
                break;
            case 4:
                mutableString = [[NSMutableString alloc] initWithFormat:@"%@ %@\n%@ %@", self.suit, self.suit, self.suit, self.suit];
                break;
            default:
                mutableString = [[NSMutableString alloc] initWithFormat:@"%@ %@\n%@\n%@ %@", self.suit, self.suit, self.suit, self.suit, self.suit];
                break;
        }
    }
    return mutableString;
}

- (void)drawCorners
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *font = [UIFont systemFontOfSize:self.bounds.size.width * 0.10];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", self.suit, [self rankStrings][self.rank]] attributes:@{ NSParagraphStyleAttributeName: paragraphStyle, NSFontAttributeName: font }];
    
    CGRect textRect;
    
    textRect.origin = CGPointMake(2.0, 2.0);
    textRect.size = [text size];
    
    [text drawInRect:textRect];
    [self pushContextAndRorate];
    [text drawInRect:textRect];
    [self popContext];
}

- (void)pushContextAndRorate
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
    CGContextRotateCTM(context, M_PI);
}

- (void)setSuit:(NSString *)suit
{
    _suit = suit;
    [self setNeedsDisplay];
}

- (void)setRank:(NSUInteger)rank
{
    _rank = rank;
    [self setNeedsDisplay];
}

- (void)popContext
{
    UIGraphicsPopContext();
}

- (NSArray *)rankStrings
{
    return @[@"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

@end
