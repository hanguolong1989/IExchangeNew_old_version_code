//
//  CTCarousel.m
//  GZCT
//
//  Created by NewMBP1 on 15/5/12.
//  Copyright (c) 2015年 PC. All rights reserved.
//

#import "CTCarousel.h"
#import "DDPageControl.h"
#import "CTCarouselItemView.h"


typedef enum
{
    CTCarouselRollingLeft = 0,   // 4.1版本开始，这个值没用了
    CTCarouselRollingRight,
    CTCarouselRollingManual     // 手指滑动，未松开时
} CTCarouselRollingDirection;

@interface CTCarousel()

@property (strong, nonatomic) DDPageControl *focusPageControl;
@property (strong, nonatomic) NSTimer *autoRollingTimer;

@property (strong, nonatomic) UILabel *titleLabel;


@property (nonatomic) CTCarouselRollingDirection rollingDirection;


@end

@implementation CTCarousel

- (void)dealloc
{
    [self.autoRollingTimer invalidate];
    self.autoRollingTimer = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupCTCarousel];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self setupCTCarousel];
    }
    return self;
}

- (void)setupCTCarousel {
    
    self.delegate = self;
    self.dataSource = self;
    [self setViews];
    
    [self didMoveToSuperview];
    self.rollingDirection = CTCarouselRollingRight;
    
    // page enabled
    self.decelerationRate = 0.2;
}

- (void)setViews {
    DDPageControl *focusPageControl = [[DDPageControl alloc] initWithType:DDPageControlTypeOnFullOffFull];
    focusPageControl.indicatorDiameter = 5;
    focusPageControl.indicatorSpace = 10;
    focusPageControl.userInteractionEnabled = NO;
    
    focusPageControl.frame = CGRectMake(SCREEN_WIDTH-35, self.frame.size.height  - 35, 20, 10);
    focusPageControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:focusPageControl];
    self.focusPageControl = focusPageControl;
    [focusPageControl updateCurrentPageDisplay];

}

#pragma mark - iCarouselDataSource & iCarouselDelegate
- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    self.focusPageControl.numberOfPages = self.focusList.count;
    self.focusPageControl.center = CGPointMake(self.frame.size.width*0.5, self.focusPageControl.center.y);
    return self.focusList.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view {
    CTCarouselItemView *imageView = (CTCarouselItemView *)view;
    if (nil == imageView) {
        imageView = [[CTCarouselItemView alloc] initWithFrame:carousel.bounds];
    }
    
    NSDictionary *focus = [self.focusList objectAtIndexCT:index];
    
    [imageView updateWithFocus:focus];
    
    return imageView;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    if ([self.ctDelegate respondsToSelector:@selector(carousel:didSelectItemAtIndex:)]) {
        [self.ctDelegate carousel:self didSelectItemAtIndex:index];
    }
}

#pragma mark - 自动滚动
// 根据方向自动滚动到下一张焦点图
- (void)scrollToNextByDirection {

    if (CTCarouselRollingRight == self.rollingDirection) {
        [self scrollToItemAtIndex:self.currentItemIndex+1 animated:YES];
    } else {
        [self scrollToItemAtIndex:self.currentItemIndex-1 animated:YES];
    }
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    return (option == iCarouselOptionWrap ? 1 : value);
}


- (void)carouselWillBeginDragging:(iCarousel *)carousel {
    CTCarousel *focus = (CTCarousel *)carousel;
    self.rollingDirection = CTCarouselRollingManual;
    [focus disableAutoScrolling];
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel {
    self.focusPageControl.currentPage = carousel.currentItemIndex;
    CTCarousel *focus = (CTCarousel *)carousel;
    if (CTCarouselRollingManual == self.rollingDirection) {
        focus.rollingDirection = CTCarouselRollingRight;
        [focus enableAutoScrolling];
    }
    
    [focus.focusPageControl setCurrentPage:focus.currentItemIndex];
}

- (void)enableAutoScrolling {
    if (!self.autoRollingTimer && ![self.autoRollingTimer isValid]) {
        self.autoRollingTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(scrollToNextByDirection) userInfo:nil repeats:YES];
    }
}

- (void)disableAutoScrolling {
    [self.autoRollingTimer invalidate];
    self.autoRollingTimer = nil;
}



@end
