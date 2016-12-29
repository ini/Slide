//  Copyright (c) 2016 Insi. All rights reserved.

#import <UIKit/UIKit.h>

#import "GameOptionsViewController.h"
#import "GCHelper.h"
#import "GridView.h"
#import "SlideButton.h"
#import "UIColor+Slide.h"

@import GoogleMobileAds;


@interface GameViewController : UIViewController <GridViewDelegate, UIScrollViewDelegate>

@property (nonatomic) BOOL isPaused;
@property (nonatomic) BOOL gameInProgress;

@property UIScrollView *header;
@property UIView *headerContentView;

@property UILabel *yourBestLabel;
@property UILabel *highScoresLabel;
@property UIView *horizontalDivider;
@property SlideButton *startOverButton;
@property SlideButton *pauseButton;
@property SlideButton *optionsButton;
@property UIView *statusView;
@property UILabel *timeLabel;
@property UILabel *movesLabel;

@property UILabel *descriptionLabel;
@property UIView *gridContainerView;

- (id)initWithGridHeight:(int)height andWidth:(int)width;
- (void)setGridHeight:(int)height andWidth:(int)width;
- (void)startOver;

@end
