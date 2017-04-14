//
//  DrawScreenView.m
//  IExchangeNew
//
//  Created by Hind on 16/7/20.
//  Copyright © 2016年 Hind. All rights reserved.
//

#import "DrawScreenView.h"

@interface DrawScreenView()
{
    CGPoint previousPoint;
    CGPoint currentPoint;
}


@property (nonatomic, strong) UIImage * viewImage;

@end

@implementation DrawScreenView

- (void)awakeFromNib
{
    [self initialize];
    [super awakeFromNib];
}

- (void)drawRect:(CGRect)rect
{
    [self.viewImage drawInRect:self.bounds];
}

#pragma mark - setter methods
- (void)setDrawingMode:(DrawingMode)drawingMode
{
    _drawingMode = drawingMode;
}

#pragma mark - Private methods
- (void)initialize
{
    currentPoint = CGPointMake(0, 0);
    previousPoint = currentPoint;
    
    _drawingMode = DrawingModeNone;
    
    _selectedColor = [UIColor blackColor];
    
    
    UITapGestureRecognizer *doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleClick:)];
    doubleRecognizer.numberOfTapsRequired = 2; // 双击
    [self addGestureRecognizer:doubleRecognizer];
    
}



- (void)drawLineNew
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.viewImage drawInRect:self.bounds];
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), [UIColor blueColor].CGColor);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 15);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), previousPoint.x, previousPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    previousPoint = currentPoint;
    
    [self setNeedsDisplay];
}


#pragma mark - Touches methods
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint p = [[touches anyObject] locationInView:self];
    previousPoint = p;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    currentPoint = [[touches anyObject] locationInView:self];
    
    [self drawLineNew];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    currentPoint = [[touches anyObject] locationInView:self];
    
    [self drawLineNew];
}

- (void)clearView {
    
    //还原颜色，变白
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
//    CGContextFillRect(context, self.bounds);
//    CGContextClearRect(context, self.bounds);
    
}

- (void)doubleClick:(UITapGestureRecognizer *)tapGesture {
    self.superview.hidden = YES;
    
    [self clearView];
}

@end
