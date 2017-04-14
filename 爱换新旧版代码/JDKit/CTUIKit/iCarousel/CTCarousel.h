//
//  CTCarousel.h
//  GZCT
//
//  Created by NewMBP1 on 15/5/12.
//  Copyright (c) 2015年 PC. All rights reserved.
//

#import "iCarousel.h"

@class CTCarousel;
@protocol CTCarouselDelegate <NSObject>
@required

- (void)carousel:(CTCarousel *)carousel didSelectItemAtIndex:(NSInteger)index;

@end

@interface CTCarousel : iCarousel<iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong) NSArray* focusList;

@property (nonatomic, weak_delegate) IBOutlet id<CTCarouselDelegate> ctDelegate;

- (void)enableAutoScrolling;
- (void)disableAutoScrolling;

@end
