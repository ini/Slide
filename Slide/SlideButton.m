//  Copyright © 2016 Insi. All rights reserved.

#import "SlideButton.h"


@interface SlideButton ()

@end


@implementation SlideButton

- (id)init {
    self = [super init];
    
    if (self) {
        self.clipsToBounds = YES;
        self.highlightStyle = SlideButtonHighlightStyleBackground;
        self.highlightMask = [UIView new];
        self.highlightMask.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.1];
        self.highlightMask.hidden = YES;
        [self addSubview:self.highlightMask];
    }
    
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.highlightMask mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (self.highlightStyle == SlideButtonHighlightStyleBackground) {
        self.highlightMask.hidden = !highlighted;
    }
    else if (self.highlightStyle == SlideButtonHighlightStyleText && highlighted) {
        if ([self.titleLabel.font.fontName isEqualToString:@"HelveticaNeue-Light"]) {
            self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue"
                                                   size:self.titleLabel.font.pointSize];
        }
    }
    else if (self.highlightStyle == SlideButtonHighlightStyleText && !highlighted) {
        if ([self.titleLabel.font.fontName isEqualToString:@"HelveticaNeue"]) {
            self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light"
                                                   size:self.titleLabel.font.pointSize];
        }
    }
}

@end

@interface SlidingButton ()


@property UIFont *buttonFont;
@property UIView *dragPoint;
@property UILabel *buttonLabel;
@property UILabel *dragPointButtonLabel;
@property UIImageView *imageView;
@property BOOL unlocked;
@property BOOL layoutSet;


@property CGFloat buttonCornerRadius;
@property CGFloat dragPointWidth;
@property UIColor *dragPointColor;
@property UIColor *buttonColor;
@property UIColor *buttonUnlockedColor;
@property NSString *buttonText;
@property NSString *buttonUnlockedText;
@property UIColor *buttonTextColor;
@property UIColor *buttonUnlockedTextColor;
@property UIImage *image;
@property UIColor *dragPointTextColor;

@end


@implementation SlidingButton

- (id)init {
    self = [super init];
    
    self.clipsToBounds = YES;
    
    self.buttonFont = [UIFont boldSystemFontOfSize:17.0];
    self.dragPoint = [UIView new];
    self.buttonLabel = [UILabel new];
    self.dragPointButtonLabel = [UILabel new];
    self.imageView = [UIImageView new];
    self.unlocked = NO;
    self.layoutSet = NO;
    
    self.buttonCornerRadius = 30.0;
    self.dragPointWidth = 70.0;
    self.dragPointColor = UIColor.darkGrayColor;
    self.buttonColor = UIColor.grayColor;
    self.buttonUnlockedColor = UIColor.blackColor;
    self.buttonText = @"Unlock";
    self.buttonUnlockedText = @"UNLOCKED";
    self.image = [UIImage new];
    self.buttonTextColor = UIColor.whiteColor;
    self.buttonUnlockedTextColor = UIColor.whiteColor;
    self.dragPointTextColor = UIColor.whiteColor;

    [self setStyle];
    [self updateConstraints];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.layoutSet) {
        [self setUpButton];
        self.layoutSet = YES;
    }
}

- (void)setStyle {
    self.buttonLabel.text = self.buttonText;
    self.dragPointButtonLabel.text = self.buttonText;
//    self.dragPoint.frame.size.width     = self.dragPointWidth;
    self.dragPoint.backgroundColor = self.dragPointColor;
    self.backgroundColor = self.buttonColor;
    self.imageView.image = self.image;
    self.buttonLabel.textColor = self.buttonTextColor;
    self.dragPointButtonLabel.textColor = self.dragPointTextColor;
    self.dragPoint.layer.cornerRadius = self.buttonCornerRadius;
    self.layer.cornerRadius = self.buttonCornerRadius;
}

- (void)setUpButton {
    self.backgroundColor = self.buttonColor;
    self.dragPoint.backgroundColor = self.dragPointColor;
    self.dragPoint.layer.cornerRadius = self.buttonCornerRadius;
    [self addSubview:self.dragPoint];
    
    self.buttonLabel.textAlignment = NSTextAlignmentCenter;
    self.buttonLabel.text = self.buttonText;
    self.buttonLabel.font = self.buttonFont;
    self.buttonLabel.textColor = self.buttonTextColor;
    [self addSubview:self.buttonLabel];
    
    self.dragPointButtonLabel.textAlignment = NSTextAlignmentCenter;
    self.dragPointButtonLabel.text = self.buttonText;
    self.dragPointButtonLabel.font = self.buttonFont;
    self.dragPointButtonLabel.textColor = self.dragPointTextColor;
    [self.dragPoint addSubview:self.dragPointButtonLabel];
    
    [self bringSubviewToFront:self.dragPoint];

    self.imageView.contentMode = UIViewContentModeCenter;
    self.imageView.image = self.image;
    [self.dragPoint addSubview:self.imageView];
    
    
        // start detecting pan gesture
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
    panGestureRecognizer.minimumNumberOfTouches = 1;
    [self.dragPoint addGestureRecognizer:panGestureRecognizer];
}

- (void)updateConstraints {
    [super updateConstraints];
    
    [self.dragPoint mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        //make.left.equalTo(self.mas_width).multipliedBy(-1.0).with.offset(self.dragPointWidth);
        make.top.width.height.equalTo(self);
    }];
    
    [self.buttonLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [self.dragPointButtonLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self);
        //make.left.equalTo(self.mas_width).with.offset(-self.dragPointWidth);
        make.left.equalTo(self);
        make.width.mas_equalTo(self.dragPointWidth);
    }];
}

- (void)panDetected:(UIPanGestureRecognizer *)sender {
    CGPoint translatedPoint = [sender translationInView:self];
    translatedPoint = CGPointMake(translatedPoint.x, self.frame.size.height / 2.0);
    
    CGRect newSenderFrame = sender.view.frame;
    newSenderFrame.origin.x = (self.dragPointWidth - self.frame.size.width) + translatedPoint.x;
    sender.view.frame = newSenderFrame;
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGFloat xVelocity = [sender velocityInView:self].x * 0.2;
        CGFloat xFinal = translatedPoint.x + xVelocity;
        
        if (xFinal < 0) {
            xFinal = 0;
        }
        else if (xFinal + self.dragPointWidth > self.frame.size.width - 60) {
            self.unlocked = YES;
            [self unlock];
        }
        
        float animationDuration = fabs(xVelocity * 0.0002) + 0.2;
        [UIView transitionWithView:self duration:animationDuration
                           options:UIViewAnimationOptionCurveEaseOut
                        animations:nil
                        completion:^(BOOL finished) {
                [self animationFinished];
        }];
    }
}

- (void)animationFinished {
    if (!self.unlocked) [self reset];
}

- (void)unlock {
    [UIView transitionWithView:self duration:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.dragPoint.frame =
            CGRectMake(self.frame.size.width - self.dragPoint.frame.size.width, 0,
                   self.dragPoint.frame.size.width, self.dragPoint.frame.size.height);
    } completion:^(BOOL finished) {
        self.dragPointButtonLabel.text = self.buttonUnlockedText;
        self.imageView.hidden = YES;
        self.dragPoint.backgroundColor = self.buttonUnlockedColor;
        self.dragPointButtonLabel.textColor = self.buttonUnlockedTextColor;
        [self.delegate setButtonStatus:@"Unlocked" sender:self];
    }];
}
    
//reset button animation (RESET)
- (void)reset {
    [UIView transitionWithView:self duration:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.dragPoint.frame =
            CGRectMake(self.dragPointWidth - self.frame.size.width, 0,
                       self.dragPoint.frame.size.width, self.dragPoint.frame.size.height);
    } completion:^(BOOL finished) {
        self.dragPointButtonLabel.text = self.buttonText;
        self.imageView.hidden = NO;
        self.dragPoint.backgroundColor = self.dragPointColor;
        self.dragPointButtonLabel.textColor = self.dragPointTextColor;
        self.unlocked = NO;
    }];
}

@end
