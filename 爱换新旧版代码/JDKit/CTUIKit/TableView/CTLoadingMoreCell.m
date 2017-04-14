//
//  CTLoadingMoreCell.m
//  GZCT
//
//  Created by NewMBP1 on 15/7/11.
//  Copyright (c) 2015年 PC. All rights reserved.
//

#import "CTLoadingMoreCell.h"

#define STRING_LOAD_MORE @"点击加载更多"
#define STRING_LOADING @"加载中..."

@interface CTLoadingMoreCell()

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UIButton *button;

@end

@implementation CTLoadingMoreCell

+ (CTLoadingMoreCell *)loadingMoreCellForTableView:(UITableView *)tableView target:(id)target action:(SEL)action
{
    static NSString *cellId = @"commom-load-more-cell";
    CTLoadingMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        UINib *cellNib = [UINib nibWithNibName:@"CTLoadingMoreCell" bundle:nil];
        NSArray *views = [cellNib instantiateWithOwner:self options:nil];
        cell = [views lastObject];
        [cell.button removeTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [cell.button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityIndicatorView hidesWhenStopped];
        [self.contentView addSubview:activityIndicatorView];
        self.activityIndicatorView = activityIndicatorView;
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:17];
        nameLabel.text = STRING_LOAD_MORE;
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = self.contentView.bounds;
        [self.contentView addSubview:button];
        self.button = button;
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    float width = frame.size.width*0.5;
    self.activityIndicatorView.center = CGPointMake(width, frame.size.height*0.5);
    self.nameLabel.frame = CGRectMake(0, width, 100, frame.size.height);
    self.button.frame = self.bounds;
}

- (void)startLoading {
    [self.activityIndicatorView startAnimating];
    self.nameLabel.text = STRING_LOADING;
    self.userInteractionEnabled = NO;
}

- (void)stopLoading {
    [self.activityIndicatorView stopAnimating];
    self.nameLabel.text = STRING_LOAD_MORE;
    self.userInteractionEnabled = YES;
}


@end
