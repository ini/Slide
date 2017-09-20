//  Copyright © 2017 Insi. All rights reserved.

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "UIColor+Slide.h"

@protocol PlayGameSliderDelegate;


@interface PlayGameSlider : UIView
    
@property UISlider* slider;
@property id <PlayGameSliderDelegate> delegate;

- (void)reset;

@end


@protocol PlayGameSliderDelegate

- (void)unlocked;

@end
