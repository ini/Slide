// Copyright © 2016 Insi. All rights reserved.

#import <UIKit/UIKit.h>
#import "DifficultyViewController.h"
#import "GCHelper.h"
#import "Masonry.h"
#import "OptionsViewController.h"
#import "PlayGameSlider.h"
#import "SlideButton.h"
#import "UIColor+Slide.h"


@interface MainMenuViewController : UIViewController <GKLocalPlayerListener, PlayGameSliderDelegate>

@property BOOL shouldPerformSliderBounceAnimation;

@end
