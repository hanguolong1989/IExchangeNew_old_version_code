//
//  CTCarouselItemView.m
//  GZCT
//
//  Created by NewMBP1 on 15/5/12.
//  Copyright (c) 2015年 PC. All rights reserved.
//

#import "CTCarouselItemView.h"

@interface CTCarouselItemView()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *pubUserLabel;
@property (nonatomic, strong) UIImageView *titleBg;

@end

@implementation CTCarouselItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView = imageView;
        [self addSubview:imageView];
        
        
        UIImageView *titleBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-50, self.bounds.size.width, 50)];
        titleBg.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        titleBg.image = [UIImage imageWithKey:@"bg_newstitle.png"];
        [self addSubview:titleBg];
        self.titleBg = titleBg;
        
        UILabel *pubUserLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.bounds.size.width-20, 25)];
        self.pubUserLabel = pubUserLabel;
        pubUserLabel.font = [UIFont systemFontOfSize:17];
        pubUserLabel.textColor = [UIColor whiteColor];
        [titleBg addSubview:pubUserLabel];
        pubUserLabel.backgroundColor = [UIColor clearColor];
        pubUserLabel.hidden = YES;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, self.bounds.size.width-20, 25)];
        self.titleLabel = titleLabel;
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = [UIColor whiteColor];
        [titleBg addSubview:titleLabel];
        titleLabel.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)updateWithFocus:(NSDictionary *)focus {
    int cType = [focus intForKey:@"cType"];
    if (cType == 11 || cType == 12) {
        self.pubUserLabel.hidden = NO;
        self.titleBg.frame = CGRectMake(0, self.bounds.size.height-50, self.bounds.size.width, 50);
        NSString *atUser = [NSString stringWithFormat:@"@%@", [focus objectForKey:@"pubUser"]];
        self.pubUserLabel.text = atUser;
        
        self.pubUserLabel.frame = CGRectMake(10, 0, self.bounds.size.width-20, 25);
        self.titleLabel.frame = CGRectMake(10, 25, self.bounds.size.width-20, 25);
    } else {
        self.pubUserLabel.hidden = YES;
        self.titleBg.frame = CGRectMake(0, self.bounds.size.height-25, self.bounds.size.width, 25);
        self.pubUserLabel.text = nil;
        
        self.titleLabel.frame = CGRectMake(10, 0, self.bounds.size.width-20, 25);
    }
    
    //图片
    NSString *imagePath = [focus objectForKey:@"downLoadPath"];
    if (imagePath.length > 0) {
        [self.imageView sd_setImageWithURL:JDURL(imagePath) placeholderImage:[UIImage imageWithKey:@"pic_preload.png"]];
    }

    //标题
    NSString *title = [focus objectForKey:@"title"];
    self.titleLabel.text = title;

}

@end
