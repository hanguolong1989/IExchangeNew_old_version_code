//
//  CTEmojiView.m
//  GZCT
//
//  Created by NewMBP1 on 15/7/14.
//  Copyright (c) 2015年 PC. All rights reserved.
//

#import "CTEmojiView.h"

@interface CTEmojiView()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSArray *emojiList;

@end

@implementation CTEmojiView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self loadEmojiData];
        [self setupViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadEmojiData];
    }
    return self;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
}

- (void)setupViews {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 15, self.frame.size.width, self.frame.size.height-30)];
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    float scWidth = scrollView.frame.size.width;
    float scHeight = scrollView.frame.size.height;
    float x = 15;
    float y = 15;
    float height = 32;
    float width = 32;
    float pageWidth = 0;
    NSInteger count = self.emojiList.count;
    for (int i = 0; i < count; i++) {
        if (x + width + 15 > scWidth) {
            x = 15 + pageWidth;
            y = y + height + 15;
            if (y + height + 15 > scHeight) {
                pageWidth += scWidth;
                x = 15 + pageWidth;
                y = 15;
            }
        }
        CGRect frame = CGRectMake(x, y, width, height);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = frame;
        [self.scrollView addSubview:button];
        
        NSDictionary *emojiData = [self.emojiList objectAtIndexCT:i];
        NSString *imageName = [[emojiData allKeys] lastObject];
        
        [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        
        x = x + i*(width + 15);
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
    lineView.backgroundColor = RGBAColor(230,230,230,1);
    [self addSubview:lineView];
}

- (void)loadEmojiData {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"emoji" ofType:@"xcconfig"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
    NSArray *filterMsg = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    self.emojiList = filterMsg;
}

@end
