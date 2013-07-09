//
//  CustomNavigationBar.m
//  Custom Navigation
//
//  Created by 23 on 7/8/13.
//  Copyright (c) 2013 Aged and Distilled. All rights reserved.
//

#import "CustomHeightNavigationBar.h"

const CGFloat kDefaultCustomNavigationBarHeight = 88.0;

@interface CustomHeightNavigationBar ()

@property (assign, nonatomic) CGFloat navigationBarHeight;

@end

@implementation CustomHeightNavigationBar

#pragma mark - Life Cycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self commonInit];
    }
    return  self;
}

- (void) commonInit
{
    _navigationBarHeight = kDefaultCustomNavigationBarHeight;
    [self invalidateTitleOffset];    
}

- (void) invalidateTitleOffset
{
    CGFloat naturalHeight = [super intrinsicContentSize].height;
    CGFloat dy = floor( (self.navigationBarHeight - naturalHeight) / 2.0);
    
    [self setTitleVerticalPositionAdjustment:-dy forBarMetrics:UIBarMetricsDefault];
        // On iOS 7 this will only apply when you use a custom UIView for the title
        // This only applies when you have a custom title view in the top navigation item
        // and will not adjust the natual title view in a navigation item

    [[UIBarButtonItem appearanceWhenContainedIn:[self class], nil] setBackButtonBackgroundVerticalPositionAdjustment:-dy forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearanceWhenContainedIn:[self class], nil] setBackgroundVerticalPositionAdjustment:-dy forBarMetrics:UIBarMetricsDefault];
        // On iOS 7 this does not adjust the default bar button items.
        // It is likely this will only work on UIBarButttonItems with custom views when ported to 7.
        // This causes the pop animation to have what I consider a glitch on iOS 6
        // may need to adjust with custom buttons, which could also fix the iOS 7 issue as well
}


#pragma mark - Navigation Items

- (void) replaceTitleViewInNavigationItem:(UINavigationItem*)item
{
    if (item.titleView != nil) return;
    
    UILabel* titleLabel = [UILabel new];
    titleLabel.text = item.title;
    [titleLabel sizeToFit];
        //TODO: the title will need attributes and appearance that is expected for a navigation bar
    
    item.titleView = titleLabel;
}

#pragma mark - Properties

- (void)setNavigationBarHeight:(CGFloat)navigationBarHeight
{
    self.navigationBarHeight = navigationBarHeight;
    
    [self invalidateTitleOffset];
    [self invalidateIntrinsicContentSize];
}


#pragma mark - UIView

- (CGSize)intrinsicContentSize
{
    return (CGSize){UIViewNoIntrinsicMetric, self.navigationBarHeight};
}



@end
