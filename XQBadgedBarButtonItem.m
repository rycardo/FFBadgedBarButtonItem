//
//  Forked From
//  FFBadgedBarButtonItem.m
//  FilterFresh
//
//  Created by Mark Granoff on 2/22/14.
//  Copyright (c) 2014 Hawk iMedia. All rights reserved.
//

#import "XQBadgedBarButtonItem.h"

@interface XQBadgedBarButtonItem()

@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) UILabel *badgeLabel;

@end

@implementation XQBadgedBarButtonItem

@synthesize badgeFont               = _badgeFont;
@synthesize badgeBackgroundColor    = _badgeBackgroundColor;
@synthesize badgeTextColor          = _badgeTextColor;

+(instancetype)barButtonItemWithImageNamed:(NSString *)imageName
                                    target:(id)target
                                    action:(SEL)action
{
    UIImage *image                  = [UIImage imageNamed:imageName];

    XQBadgedBarButtonItem *bbi      = [[XQBadgedBarButtonItem alloc] initWithImage:image
                                                                            target:target
                                                                            action:action];
    return bbi;
}

-(id)initWithImage:(UIImage *)image
            target:(id)target
            action:(SEL)action
{
    UIImageView *imageView          = [[UIImageView alloc] initWithImage:image];
    imageView.frame                 = CGRectMake(0, 7, image.size.width, image.size.height);

    UIView *v                       =
        [[UIView alloc] initWithFrame:CGRectMake(0, 0, (image.size.width + 7), (image.size.height + 7))];
    [v addSubview:imageView];

    NSString *string                = @"8";
    CGSize badgeSize                = [string sizeWithAttributes:@{NSFontAttributeName:self.badgeFont}];

    //UILabel *label                  = [[UILabel alloc] initWithFrame:CGRectMake(v.frame.size.width - 14, 0, height, height)];
    CGRect lFrame                   = CGRectMake((v.frame.size.width - 14), 0, badgeSize.width, badgeSize.height);
    UILabel *label                  = [[UILabel alloc] initWithFrame:lFrame];
    label.backgroundColor           = self.badgeBackgroundColor;
    label.layer.cornerRadius        = 7;
    label.layer.masksToBounds       = YES;
    label.userInteractionEnabled    = NO;
    label.font                      = self.badgeFont;
    label.textColor                 = self.badgeTextColor;
    label.textAlignment             = NSTextAlignmentCenter;
    label.text                      = @"";
    label.hidden                    = YES;

    [v addSubview:label];
    UITapGestureRecognizer *tap     = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    tap.numberOfTapsRequired        = 1;
    [v addGestureRecognizer:tap];

    self = [super initWithCustomView:v];
    if ( self )
    {
        self.buttonView = v;
        self.badgeLabel = label;
    }

    return self;
}

- (NSString *)badge
{
    if ( _badgeLabel.hidden )
        return nil;

    return _badgeLabel.text;
}

- (void)setBadge:(NSString *)badge
{
    if ( [self.badgeLabel.text isEqualToString:badge] )
    {
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^
    {
        self.badgeLabel.text = badge;

        if ( ( !badge        ) ||
             ( !badge.length ) )
        {
            self.badgeLabel.hidden = YES;
        }
        else
        {
            [self refreshBadge];
        }
    });
}
- (void)refreshBadge
{
    self.badgeLabel.backgroundColor = self.badgeBackgroundColor;
    self.badgeLabel.textColor       = self.badgeTextColor;
    self.badgeLabel.font            = self.badgeFont;

    NSString *string                = ( self.badge.length ) ? self.badge : @"8";
    CGSize badgeSize                = [string sizeWithAttributes:@{NSFontAttributeName:self.badgeFont}];

	CGRect lFrame                   = self.badgeLabel.frame;

	CGFloat scale					= UIScreen.mainScreen.scale;

	lFrame.size.width               = (badgeSize.width  + (3 * scale));	// Add Padding
    lFrame.size.height              = (badgeSize.height + (3 * scale)); // Add Padding

	CGFloat radius					= (lFrame.size.height / 2);

	lFrame.size.width				= MAX(lFrame.size.width, lFrame.size.height);

    self.badgeLabel.frame				= lFrame;
	self.badgeLabel.layer.cornerRadius	= radius;
	self.badgeLabel.layer.masksToBounds = YES;

	self.badgeLabel.hidden				= ( !self.badgeLabel.text.length );

    [self.buttonView setNeedsDisplay];
}

- (UIFont *)badgeFont
{
    if ( !_badgeFont )
    {
        _badgeFont = [UIFont systemFontOfSize:11];
    }
    return _badgeFont;
}

- (void)setBadgFont:(UIFont *)font
{
    if ( [_badgeFont isEqual:font] )
    {
        return;
    }

    _badgeFont = font;

    [self refreshBadge];
}

- (UIColor *)badgeBackgroundColor
{
    if ( !_badgeBackgroundColor )
    {
        _badgeBackgroundColor = UIColor.redColor;
    }
    return _badgeBackgroundColor;
}

- (void)setBadgeBackgroundColor:(UIColor *)colour
{
    if ( [_badgeBackgroundColor isEqual:colour] )
    {
        return;
    }

    _badgeBackgroundColor = colour;

    [self refreshBadge];
}

- (UIColor *)badgeTextColor
{
    if ( !_badgeTextColor )
    {
        _badgeTextColor = UIColor.whiteColor;
    }
    return _badgeTextColor;
}

- (void)setBadgeTextColor:(UIColor *)colour
{
    if ( [_badgeTextColor isEqual:colour] )
    {
        return;
    }

    _badgeTextColor = colour;

    [self refreshBadge];
}


@end
