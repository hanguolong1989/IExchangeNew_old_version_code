//
//  CTCustomBadge.m
//  GZCT
//
//  Created by NewMBP1 on 15/7/16.
//  Copyright (c) 2015年 PC. All rights reserved.
//

#import "CTCustomBadge.h"

@implementation CTCustomBadge

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.contentScaleFactor = [[UIScreen mainScreen] scale];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// I recommend to use the allocator customBadgeWithString
- (id)initWithString:(NSString *)badgeString withScale:(CGFloat)scale withShining:(BOOL)shining
{
    self = [super initWithFrame:CGRectMake(0, 0, 25, 25)];
    if(self!=nil) {
        self.contentScaleFactor = [[UIScreen mainScreen] scale];
        self.backgroundColor = [UIColor clearColor];
        self.badgeText = badgeString;
        self.badgeTextColor = [UIColor whiteColor];
        self.badgeFrame = YES;
        self.badgeFrameColor = [UIColor whiteColor];
        self.badgeInsetColor = [UIColor redColor];
        self.badgeCornerRoundness = 0.4;
        self.badgeScaleFactor = scale;
        self.badgeShining = shining;
        self.shadow = YES;
        [self autoBadgeSizeWithString:badgeString];
    }
    return self;
}

// I recommend to use the allocator customBadgeWithString
- (id)initWithString:(NSString *)badgeString withStringColor:(UIColor*)stringColor withInsetColor:(UIColor*)insetColor withBadgeFrame:(BOOL)badgeFrameYesNo withBadgeFrameColor:(UIColor*)frameColor withScale:(CGFloat)scale withShining:(BOOL)shining
{
    self = [super initWithFrame:CGRectMake(0, 0, 25, 25)];
    if(self!=nil) {
        self.contentScaleFactor = [[UIScreen mainScreen] scale];
        self.backgroundColor = [UIColor clearColor];
        self.badgeText = badgeString;
        self.badgeTextColor = stringColor;
        self.badgeFrame = badgeFrameYesNo;
        self.badgeFrameColor = frameColor;
        self.badgeInsetColor = insetColor;
        self.badgeCornerRoundness = 0.40;
        self.badgeScaleFactor = scale;
        self.badgeShining = shining;
        self.shadow = YES;
        [self autoBadgeSizeWithString:badgeString];
    }
    return self;
}


// Use this method if you want to change the badge text after the first rendering
- (void)autoBadgeSizeWithString:(NSString *)badgeString
{
    CGSize retValue;
    CGFloat rectWidth, rectHeight;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]};
    CGSize stringSize = [badgeString boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    CGFloat flexSpace;
    if ([badgeString length]>=2) {
        flexSpace = [badgeString length];
        rectWidth = 10 + (stringSize.width + flexSpace); rectHeight = 22;
        retValue = CGSizeMake(rectWidth*_badgeScaleFactor, rectHeight*_badgeScaleFactor);
        //如果用的是autolayout布局，这里也要改变
        for (NSLayoutConstraint *constraint in self.constraints) {
            if (NSLayoutAttributeWidth == constraint.firstAttribute) {
                constraint.constant = retValue.width;
            } else if (NSLayoutAttributeHeight == constraint.firstAttribute) {
                constraint.constant = retValue.height;
            }
        }
    } else {
        retValue = CGSizeMake(22*_badgeScaleFactor, 22*_badgeScaleFactor);
    }
    CGPoint _center = self.center;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, retValue.width, retValue.height);
    self.center = _center;
    self.badgeText = badgeString;
    [self setNeedsDisplay];
}


// Creates a Badge with a given Text
+ (CTCustomBadge *)customBadgeWithString:(NSString *)badgeString
{
    return [[self alloc] initWithString:badgeString withScale:1.0 withShining:YES];
}


// Creates a Badge with a given Text, Text Color, Inset Color, Frame (YES/NO) and Frame Color
+ (CTCustomBadge *)customBadgeWithString:(NSString *)badgeString withStringColor:(UIColor*)stringColor withInsetColor:(UIColor*)insetColor withBadgeFrame:(BOOL)badgeFrameYesNo withBadgeFrameColor:(UIColor*)frameColor withScale:(CGFloat)scale withShining:(BOOL)shining
{
    return [[self alloc] initWithString:badgeString withStringColor:stringColor withInsetColor:insetColor withBadgeFrame:badgeFrameYesNo withBadgeFrameColor:frameColor withScale:scale withShining:shining];
}

// Draws the Badge with Quartz
- (void)drawRoundedRectWithContext:(CGContextRef)context withRect:(CGRect)rect
{
    CGContextSaveGState(context);
    
    CGFloat radius = CGRectGetMaxY(rect)*self.badgeCornerRoundness;
    CGFloat puffer = CGRectGetMaxY(rect)*0.10;
    CGFloat maxX = CGRectGetMaxX(rect) - puffer;
    CGFloat maxY = CGRectGetMaxY(rect) - puffer;
    CGFloat minX = CGRectGetMinX(rect) + puffer;
    CGFloat minY = CGRectGetMinY(rect) + puffer;
    
    CGContextBeginPath(context);
    CGContextSetFillColorWithColor(context, [self.badgeInsetColor CGColor]);
    CGContextAddArc(context, maxX-radius, minY+radius, radius, M_PI+(M_PI/2), 0, 0);
    CGContextAddArc(context, maxX-radius, maxY-radius, radius, 0, M_PI/2, 0);
    CGContextAddArc(context, minX+radius, maxY-radius, radius, M_PI/2, M_PI, 0);
    CGContextAddArc(context, minX+radius, minY+radius, radius, M_PI, M_PI+M_PI/2, 0);
    if (self.shadow)
    {
        CGContextSetShadowWithColor(context, CGSizeMake(1.0,1.0), 3, [[UIColor blackColor] CGColor]);
    }
    CGContextFillPath(context);
    
    CGContextRestoreGState(context);
    
}

// Draws the Badge Shine with Quartz
- (void)drawShineWithContext:(CGContextRef)context withRect:(CGRect)rect
{
    CGContextSaveGState(context);
    
    CGFloat radius = CGRectGetMaxY(rect)*self.badgeCornerRoundness;
    CGFloat puffer = CGRectGetMaxY(rect)*0.10;
    CGFloat maxX = CGRectGetMaxX(rect) - puffer;
    CGFloat maxY = CGRectGetMaxY(rect) - puffer;
    CGFloat minX = CGRectGetMinX(rect) + puffer;
    CGFloat minY = CGRectGetMinY(rect) + puffer;
    CGContextBeginPath(context);
    CGContextAddArc(context, maxX-radius, minY+radius, radius, M_PI+(M_PI/2), 0, 0);
    CGContextAddArc(context, maxX-radius, maxY-radius, radius, 0, M_PI/2, 0);
    CGContextAddArc(context, minX+radius, maxY-radius, radius, M_PI/2, M_PI, 0);
    CGContextAddArc(context, minX+radius, minY+radius, radius, M_PI, M_PI+M_PI/2, 0);
    if(!CGContextIsPathEmpty(context))
        CGContextClip(context);
    
    
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 0.4 };
    CGFloat components[8] = {  0.92, 0.92, 0.92, 1.0, 0.82, 0.82, 0.82, 0.4 };
    
    CGColorSpaceRef cspace;
    CGGradientRef gradient;
    cspace = CGColorSpaceCreateDeviceRGB();
    gradient = CGGradientCreateWithColorComponents (cspace, components, locations, num_locations);
    
    CGPoint sPoint, ePoint;
    sPoint.x = 0;
    sPoint.y = 0;
    ePoint.x = 0;
    ePoint.y = maxY;
    CGContextDrawLinearGradient (context, gradient, sPoint, ePoint, 0);
    
    CGColorSpaceRelease(cspace);
    CGGradientRelease(gradient);
    
    CGContextRestoreGState(context);
}


// Draws the Badge Frame with Quartz
- (void)drawFrameWithContext:(CGContextRef)context withRect:(CGRect)rect
{
    CGFloat radius = CGRectGetMaxY(rect)*self.badgeCornerRoundness;
    CGFloat puffer = CGRectGetMaxY(rect)*0.10;
    
    CGFloat maxX = CGRectGetMaxX(rect) - puffer;
    CGFloat maxY = CGRectGetMaxY(rect) - puffer;
    CGFloat minX = CGRectGetMinX(rect) + puffer;
    CGFloat minY = CGRectGetMinY(rect) + puffer;
    
    
    CGContextBeginPath(context);
    CGFloat lineSize = 2;
    if(self.badgeScaleFactor>1) {
        lineSize += self.badgeScaleFactor*0.25;
    }
    CGContextSetLineWidth(context, lineSize);
    CGContextSetStrokeColorWithColor(context, [self.badgeFrameColor CGColor]);
    CGContextAddArc(context, maxX-radius, minY+radius, radius, M_PI+(M_PI/2), 0, 0);
    CGContextAddArc(context, maxX-radius, maxY-radius, radius, 0, M_PI/2, 0);
    CGContextAddArc(context, minX+radius, maxY-radius, radius, M_PI/2, M_PI, 0);
    CGContextAddArc(context, minX+radius, minY+radius, radius, M_PI, M_PI+M_PI/2, 0);
    CGContextClosePath(context);
    CGContextStrokePath(context);
}


- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawRoundedRectWithContext:context withRect:rect];
    
    if(self.badgeShining) {
        [self drawShineWithContext:context withRect:rect];
    }
    
    if (self.badgeFrame)  {
        [self drawFrameWithContext:context withRect:rect];
    }
    
    if ([self.badgeText length]>0) {
        [_badgeTextColor set];
        CGFloat sizeOfFont = 14*_badgeScaleFactor;
        UIFont *textFont = [UIFont boldSystemFontOfSize:sizeOfFont];
        
        NSDictionary *attributes = @{NSFontAttributeName:textFont, NSForegroundColorAttributeName:_badgeTextColor};
        CGSize textSize = [self.badgeText boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        [self.badgeText drawAtPoint:CGPointMake((rect.size.width/2-textSize.width/2), (rect.size.height/2-textSize.height/2)) withAttributes:attributes];

    }
    
}

- (void)dealloc {
    
    self.badgeText = nil;
    self.badgeTextColor = nil;
    self.badgeInsetColor = nil;
    self.badgeFrameColor = nil;
}


@end
