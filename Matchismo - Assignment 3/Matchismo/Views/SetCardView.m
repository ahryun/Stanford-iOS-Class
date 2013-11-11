//
//  SetCardView.m
//  Matchismo
//
//  Created by Ahryun Moon on 10/16/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "SetCardView.h"

@interface SetCardView()

@property (nonatomic) CGFloat cardWidth;
@property (nonatomic) CGFloat cardHeight;
@property (nonatomic) CGPoint middle;

@end

@implementation SetCardView

- (CGFloat)cardWidth
{
    if (!_cardWidth) {
        _cardWidth = self.bounds.size.width;
    }
    return _cardWidth;
}

- (CGFloat)cardHeight
{
    if (!_cardHeight) {
        _cardHeight = self.bounds.size.height;
    }
    return _cardHeight;
}

- (CGPoint)middle
{
    return CGPointMake(self.cardWidth / 2, self.cardHeight / 2);
}

- (void)drawInside
{
    if (self.faceUp) {
        [[UIColor grayColor] setFill];
        UIRectFill(self.bounds);
    }
    [self drawShapes];
}

#define SHAPE_STARTS_AT 0.40
#define SHAPE_INCREMENT 0.15
#define SHAPE_DISTANCE 0.30
#define VERTICAL_DISTANCE 0.30

- (void)drawShapes
{
    CGPoint startPoint = CGPointMake(self.cardWidth * (SHAPE_STARTS_AT - ((self.count - 1) * SHAPE_INCREMENT)), self.cardHeight * VERTICAL_DISTANCE);
    for (int i = 0; i < self.count;  i++) {
        CGPoint point = CGPointMake(startPoint.x + (self.cardWidth * (i * SHAPE_DISTANCE)), startPoint.y);
        UIBezierPath *shape;
        if (self.symbol == 0) {
            shape = [self drawDiamondFromPoint:point];
        } else if (self.symbol == 1) {
            shape = [self drawSquiggleFromPoint:point];
        } else if (self.symbol == 2) {
            shape = [self drawOvalFromPoint:point];
        } else {
            break;
        }
        if ([[self validShading] containsObject:self.shading]) {
            BOOL fill;
            BOOL pattern;
            if ([self.shading isEqualToString:@"solid"]) {
                fill = YES;
                pattern = NO;
            } else if ([self.shading isEqualToString:@"opaque"]) {
                fill = NO;
                pattern = YES;
            } else if ([self.shading isEqualToString:@"transparent"]) {
                fill = NO;
                pattern = NO;
            } else {
                break;
            }
            [self drawAShape:shape withColor:[self validColorValues][self.color] withFill:fill withPattern:pattern];
        }
    }
}

- (void)drawAShape:(UIBezierPath *)shape withColor:(UIColor *)color withFill:(BOOL)fill withPattern:(BOOL)pattern
{
    
    [color setStroke];
    [shape stroke];
    [color setFill];
    if (fill) {
        [shape fill];
    } else if (pattern) {
        [shape fillWithBlendMode:kCGBlendModeMultiply alpha:0.5];
    }
    
}

- (UIBezierPath *)drawDiamondFromPoint:(CGPoint)point
{
    UIBezierPath *shape = [[UIBezierPath alloc] init];
    CGPoint startPoint = CGPointMake(point.x, self.middle.y);
    [shape moveToPoint:startPoint];
    [shape addLineToPoint:CGPointMake(startPoint.x + (self.cardWidth * 0.1), startPoint.y - (self.cardHeight * 0.2))];
    [shape addLineToPoint:CGPointMake(startPoint.x + 2 * (self.cardWidth * 0.1), startPoint.y)];
    [shape addLineToPoint:CGPointMake(startPoint.x + (self.cardWidth * 0.1), startPoint.y + (self.cardHeight * 0.2))];
    [shape closePath];
    
    return shape;
}

- (UIBezierPath *)drawSquiggleFromPoint:(CGPoint)point
{
    UIBezierPath *shape = [[UIBezierPath alloc] init];
    point = CGPointMake(point.x, point.y + self.bounds.size.height * 0.1);
    [shape moveToPoint:point];
    [shape addCurveToPoint:CGPointMake(point.x + self.cardWidth * 0.20, point.y)
             controlPoint1:CGPointMake(point.x + self.cardWidth * 0.1, point.y - self.cardHeight * 0.1)
             controlPoint2:CGPointMake(point.x + self.cardWidth * 0.1, point.y + self.cardHeight * 0.1)];
    [shape addLineToPoint:CGPointMake(shape.currentPoint.x, shape.currentPoint.y + self.cardHeight * 0.2)];
    [shape addCurveToPoint:CGPointMake(point.x, point.y + (self.cardHeight * 0.2))
             controlPoint1:CGPointMake(point.x + self.cardWidth * 0.1, point.y + self.cardHeight * 0.3)
             controlPoint2:CGPointMake(point.x + self.cardWidth * 0.1, point.y + self.cardHeight * 0.1)];
    [shape addLineToPoint:CGPointMake(point.x, point.y)];
    return shape;
    
}


- (UIBezierPath *)drawOvalFromPoint:(CGPoint)point
{
    UIBezierPath *shape = [[UIBezierPath alloc] init];
    point = CGPointMake(point.x + self.bounds.size.width * 0.02, point.y + self.bounds.size.height * 0.1);
    [shape moveToPoint:point];
    [shape addLineToPoint:CGPointMake(point.x + self.bounds.size.width * 0.16, point.y)];
    [shape addQuadCurveToPoint:CGPointMake(point.x + self.bounds.size.width * 0.16, point.y + self.bounds.size.height * 0.20) controlPoint:CGPointMake(shape.currentPoint.x + self.bounds.size.width * 0.1, self.middle.y)];
    [shape addLineToPoint:CGPointMake(point.x, point.y + self.bounds.size.height * 0.20)];
    [shape addQuadCurveToPoint:CGPointMake(point.x, point.y) controlPoint:CGPointMake(shape.currentPoint.x - self.bounds.size.width * 0.1, self.middle.y)];
    return shape;
}

- (NSArray *)validShading
{
    return @[@"solid", @"opaque", @"transparent"];
}

- (NSDictionary *)validColorValues
{
    return @{@"red":[UIColor redColor], @"green":[UIColor greenColor], @"blue":[UIColor blueColor]};
}
     
@end
