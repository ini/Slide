//
//  GameViewController.h
//  Slide
//
//  Created by Ini on 8/25/14.
//  Copyright (c) 2014 Insi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <iAd/iAd.h>
#import "MoveController.h"
#import "BlockView.h"
#import "GCHelper.h"

@interface GameViewController : UIViewController

{
    NSTimer *Timer;
    NSTimer *scrambleTime;
    BOOL timerOn;
    IBOutlet UILabel *moveLabel;
    IBOutlet UILabel *timerLabel;
    IBOutlet UILabel *bestLabel;
}
    
@property (weak, nonatomic) IBOutlet UIView *backGround;
@property (strong, nonatomic) IBOutlet UIButton *pauseButton;
@property (strong, nonatomic) IBOutlet UIView *alert;
@property (strong, nonatomic) IBOutlet UILabel *alertLabel;
@property (strong, nonatomic) IBOutlet UIView *optionView;
@property (strong, nonatomic) IBOutlet UIScrollView *sv;
@property (strong, nonatomic) IBOutlet ADBannerView *adBanner;
@property (strong, nonatomic) IBOutlet UILabel *record;

@property (strong, nonatomic) MoveController *model;
@property (strong, nonatomic) NSArray *blocks;
@property (strong, nonatomic) NSString *bestTime;
@property (strong, nonatomic) NSString *bestMoveCount;
@property (strong, nonatomic) NSString *bestyTime;
@property (strong, nonatomic) NSString *bestyMoveCount;

@property int gridSize;
@property int blockSize;
@property int spacing;

@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *rightSwiper;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *leftSwiper;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *downSwiper;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *upSwiper;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tappy;


- (void)resetLocations;
- (void)startTimer;
- (void)stopTimer;
- (void)resetTimer;
- (void)timerCount;
- (NSString *)getTimerLabelText:(int)milSec and:(int)sec and:(int)min and:(int)hour;
- (void)updateGameCenterAchievements;
- (NSArray *)getPointFromLocation:(int)loc;
- (int)getLocationFromPoint:(int)row and:(int)col;
- (void)startMoves;
- (void)startMovesHelper:(int)loc andDirection:(NSString*)dir;
- (BOOL)checkForWin;
- (void)tapLocation:(int)locNum and:(UISwipeGestureRecognizerDirection)direction;
- (IBAction)pause:(id)sender;
   
@end
