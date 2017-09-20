//  Copyright © 2017 Insi. All rights reserved.

#import "PlayGameSlider.h"

@interface PlayGameSlider ()

@property UIView *sliderBackground;
@property UIImageView *sliderThumbImageView;

@end

@implementation PlayGameSlider

- (id)init {
    self = [super init];
    
    if (self) {
        self.backgroundColor = UIColor.slideMainColor;
        self.layer.cornerRadius = 10.0;
        
        self.sliderBackground = [UIView new];
        self.sliderBackground.layer.cornerRadius = 3.0;
        self.sliderBackground.clipsToBounds = YES;
        self.sliderBackground.backgroundColor = UIColor.slideGrey;
        
        self.slider = [UISlider new];
        
        UIImage *transparentImage = [UIImage new];
        UIImage *sliderThumbImage = [UIImage imageNamed:@"play_game_slider_thumb.png"];
        
        // Replace non-transparent pixels with the main theme color
        CGRect rect = CGRectMake(0, 0, sliderThumbImage.size.width, sliderThumbImage.size.height);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextClipToMask(context, rect, sliderThumbImage.CGImage);
        CGContextSetFillColorWithColor(context, [UIColor.slideMainColor CGColor]);
        CGContextFillRect(context, rect);
        sliderThumbImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        [self.slider setMinimumTrackImage:transparentImage forState:UIControlStateNormal];
        [self.slider setMaximumTrackImage:transparentImage forState:UIControlStateNormal];
        [self.slider setThumbImage:sliderThumbImage forState:UIControlStateNormal];
        self.slider.backgroundColor = UIColor.clearColor;
        self.slider.minimumValue = 0.0;
        self.slider.maximumValue = 1.0;
        self.slider.continuous = YES;
        self.slider.value = 0.0;
        
        [self.slider addTarget:self
                        action:@selector(sliderUp:)
              forControlEvents:UIControlEventTouchUpInside];
        [self.slider addTarget:self
                        action:@selector(sliderDown:)
              forControlEvents:UIControlEventTouchDown];
        [self.slider addTarget:self
                        action:@selector(sliderChanged:)
              forControlEvents:UIControlEventValueChanged];
        
        self.label = [UILabel new];
        self.label.text = @"slide to play";
        self.label.backgroundColor = UIColor.clearColor;
        self.label.textColor = UIColor.slideMainColor;
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:28.0];

        [self.sliderBackground addSubview:self.label];
        [self.sliderBackground addSubview:self.slider];
        [self addSubview:self.sliderBackground];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat thumbImageLength = self.sliderBackground.frame.size.height - 4.0;
    UIImage *resizedSliderThumbImage =
        [PlayGameSlider imageWithImage:self.slider.currentThumbImage
                          scaledToSize:CGSizeMake(thumbImageLength, thumbImageLength)];
    [self.slider setThumbImage:resizedSliderThumbImage forState:UIControlStateNormal];
    [self updateConstraints];
}

- (void)updateConstraints {
    [super updateConstraints];

    [self.sliderBackground mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).inset(10.0);
    }];
    
    [self.slider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sliderBackground);
        make.bottom.equalTo(self.sliderBackground).with.mas_offset(-2.0);
        make.left.right.equalTo(self.sliderBackground).inset(4.0);
    }];
    
    [self.sliderThumbImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.sliderBackground);
    }];
    
    [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.slider).with.offset(self.slider.currentThumbImage.size.width / 2);
        make.centerY.equalTo(self.slider);
        make.height.equalTo(self.sliderBackground);
    }];
}

# pragma mark Slider Events

- (void)sliderUp: (UISlider *) sender {
    if (self.touchIsDown) {
        self.touchIsDown = NO;
        
        if (self.slider.value != 1.0) {
            [self.slider setValue: 0 animated: YES];
            self.label.alpha = 1.0;
        }
        else {
            [self.delegate unlocked];
        }
    }
}

- (void)sliderDown: (UISlider *) sender {
    self.touchIsDown = YES;
}

- (void)sliderChanged: (UISlider *) sender {
    // Fade the label text as the slider moves to the right
    self.label.alpha = MAX(0.0, 1.0 - (self.slider.value * 3.5));
    
    // Stop the animation if the slider moved off the zero point
    if (self.slider.value != 0) {
        [self.label.layer setNeedsDisplay];
    }
}

- (void)reset {
    self.slider.value = 0.0;
    self.label.alpha = 1.0;
    self.touchIsDown = NO;
}

# pragma mark Static Helper Functions

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
