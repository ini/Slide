//  Copyright (c) 2016 Insi. All rights reserved.

#import "GameViewController.h"
#import "MainMenuViewController.h"


@interface GameViewController ()

@property GridView *grid;
@property GADBannerView *adBanner;
@property UIView *victoryView;

@property NSTimer *timer;
@property CFAbsoluteTime timerStartTime;
@property float timeElapsed;
@property int numMoves;

@property NSString *bestTimeKey;
@property NSString *bestMoveCountKey;
@property NSString *gameCenterBestTimeKey;
@property NSString *gameCenterBestMoveCountKey;

@end


@implementation GameViewController

- (id)init {
    self = [super init];
    
    if (self) {
        self.view.backgroundColor = UIColor.whiteColor;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.gameInProgress = NO;
        self.isPaused = NO;
        self.timeElapsed = 0;
        self.numMoves = 0;
        [self initHeader];
        
        self.descriptionLabel = [UILabel new];
        self.descriptionLabel.text = @"Put the numbers back in order!";
        self.descriptionLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:13.0];
        self.descriptionLabel.textAlignment = NSTextAlignmentCenter;
        self.descriptionLabel.textColor = UIColor.slideMainColor;
        [self.view addSubview:self.descriptionLabel];
        
        self.gridContainerView = [UIView new];
        [self.view addSubview:self.gridContainerView];
        
        self.grid = [[GridView alloc] init];
        self.grid.delegate = self;
        self.grid.userInteractionEnabled = NO;
        [self.gridContainerView addSubview:self.grid];
        
        self.adBanner = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
        // [self.view addSubview:self.adBanner];
        
        // Disable multiple touches
        [self.view.subviews makeObjectsPerformSelector:@selector(setExclusiveTouch:)
                                            withObject:[NSNumber numberWithBool:YES]];
        [self updateViewConstraints];
    }
    
    return self;
}

- (id)initWithGridHeight:(int)height andWidth:(int)width {
    self = [self init];
    if (self) {
        [self setGridHeight:height andWidth:width];
        if (height == width && 3 <= height && height <= 5) {
            self.bestTimeKey = [NSString stringWithFormat:@"bestTime%i", height];
            self.bestMoveCountKey = [NSString stringWithFormat:@"bestMoveCount%i", height];
            self.gameCenterBestTimeKey = [NSString stringWithFormat:@"Best_Time_%i", height];
            self.gameCenterBestMoveCountKey = [NSString stringWithFormat:@"Best_Moves_%i", height];
        }
    }
    return self;
}


- (void)setGridHeight:(int)height andWidth:(int)width {
    [self.grid removeFromSuperview];
    self.grid = [[GridView alloc] initWithHeight:height andWidth:width];
    self.grid.delegate = self;
    self.grid.userInteractionEnabled = NO;
    [self.gridContainerView addSubview:self.grid];
    [self updateViewConstraints];
}

- (void)initHeader {
    self.header = [UIScrollView new];
    self.header.alwaysBounceVertical = YES;
    self.header.showsVerticalScrollIndicator = NO;
    self.header.delegate = self;
    [self.view addSubview:self.header];
    
    self.headerContentView = [UIView new];
    [self.header addSubview:self.headerContentView];
    
    self.yourBestLabel = [UILabel new];
    self.yourBestLabel.text = @"Your Best:";
    self.yourBestLabel.textColor = UIColor.slideMainColor;
    self.yourBestLabel.textAlignment = NSTextAlignmentLeft;
    self.yourBestLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0];
    [self.headerContentView addSubview:self.yourBestLabel];
    
    self.highScoresLabel = [UILabel new];
    self.highScoresLabel.text = [NSString stringWithFormat:@"%d moves in %.02f seconds", 0, 0.00];
    self.highScoresLabel.textColor = UIColor.slideMainColor;
    self.highScoresLabel.textAlignment = NSTextAlignmentLeft;
    self.highScoresLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
    [self.headerContentView addSubview:self.highScoresLabel];
    
    self.horizontalDivider = [UIView new];
    self.horizontalDivider.backgroundColor = UIColor.slideMainColor;
    [self.headerContentView addSubview:self.horizontalDivider];
    
    self.startOverButton = [SlideButton new];
    self.startOverButton.backgroundColor = UIColor.slideGrey;
    self.startOverButton.layer.cornerRadius = 10.0;
    [self.startOverButton setTitle:@"START OVER" forState:UIControlStateNormal];
    [self.startOverButton setTitleColor:UIColor.slideMainColor forState:UIControlStateNormal];
    self.startOverButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0];
    [self.startOverButton addTarget:self
                             action:@selector(startOver)
                   forControlEvents:UIControlEventTouchUpInside];
    [self.headerContentView addSubview:self.startOverButton];
    
    self.pauseButton = [SlideButton new];
    self.pauseButton.backgroundColor = UIColor.slideGrey;
    self.pauseButton.layer.cornerRadius = 10.0;
    [self.pauseButton setTitle:@"PAUSE" forState:UIControlStateNormal];
    [self.pauseButton setTitleColor:UIColor.slideMainColor forState:UIControlStateNormal];
    self.pauseButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0];
    [self.pauseButton addTarget:self
                         action:@selector(pauseButtonPressed)
               forControlEvents:UIControlEventTouchUpInside];
    [self.headerContentView addSubview:self.pauseButton];
    
    self.optionsButton = [SlideButton new];
    self.optionsButton.backgroundColor = UIColor.slideGrey;
    self.optionsButton.layer.cornerRadius = 10.0;
    [self.optionsButton setTitle:@"OPTIONS" forState:UIControlStateNormal];
    [self.optionsButton setTitleColor:UIColor.slideMainColor forState:UIControlStateNormal];
    self.optionsButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0];
    [self.optionsButton addTarget:self
                           action:@selector(showOptions)
                 forControlEvents:UIControlEventTouchUpInside];
    [self.headerContentView addSubview:self.optionsButton];
    
    self.statusView = [UIView new];
    self.statusView.backgroundColor = UIColor.slideGrey;
    self.statusView.layer.cornerRadius = 10.0;
    [self.headerContentView addSubview:self.statusView];
    
    UITapGestureRecognizer *tapGestureRecognizer =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pauseButtonPressed)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.statusView addGestureRecognizer:tapGestureRecognizer];
    
    self.timeLabel = [UILabel new];
    self.timeLabel.text = @"0.00";
    self.timeLabel.textColor = UIColor.slideMainColor;
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.statusView addSubview:self.timeLabel];
    
    self.movesLabel = [UILabel new];
    self.movesLabel.text = @"No moves";
    self.movesLabel.textColor = UIColor.slideMainColor;
    self.movesLabel.textAlignment = NSTextAlignmentCenter;
    self.movesLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
    [self.statusView addSubview:self.movesLabel];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    [self updateHeaderConstraints];
    
    [self.descriptionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.gridContainerView.mas_top).with.offset(-5.0f);
        make.width.mas_equalTo(300.0);
        make.height.mas_equalTo(28.0);
    }];
    
    [self.gridContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view).with.offset(-60.0);
        make.left.equalTo(self.view).with.offset(10.0);
        make.right.equalTo(self.view).with.offset(-10.0);
        make.height.mas_equalTo(self.gridContainerView.mas_width);
    }];
    
    [self.grid mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.gridContainerView);
        if (self.grid.height > self.grid.width) {
            float mult = (float)self.grid.width / self.grid.height;
            make.height.equalTo(self.gridContainerView);
            make.width.equalTo(self.grid.mas_height).multipliedBy(mult).with.offset(10 * (1 - mult));
        }
        else if (self.grid.height < self.grid.width){
            float mult = (float)self.grid.height / self.grid.width;
            make.height.equalTo(self.grid.mas_width).multipliedBy(mult).with.offset(10 * (1 - mult));
            make.width.equalTo(self.gridContainerView);
        }
        else {
            make.edges.equalTo(self.gridContainerView);
        }
    }];
    
    [self.adBanner mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(50.0);
    }];
}

- (void)updateHeaderConstraints {
    [self.header mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.descriptionLabel.mas_top);
    }];
    
    [self.headerContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.top.left.right.equalTo(self.header);
        make.height.greaterThanOrEqualTo(self.header);
        make.height.mas_greaterThanOrEqualTo(164.0);
    }];

    [self.yourBestLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.headerContentView).with.offset(20.0);
        make.width.mas_equalTo(75.0);
        make.height.mas_equalTo(28.0);
    }];
    
    [self.highScoresLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.yourBestLabel);
        make.left.equalTo(self.yourBestLabel.mas_right);
        make.right.equalTo(self.headerContentView).with.offset(-20.0);
        make.height.mas_equalTo(28.0);
    }];
    
    [self.horizontalDivider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.yourBestLabel.mas_bottom);
        make.left.equalTo(self.headerContentView).with.offset(10.0);
        make.right.equalTo(self.headerContentView).with.offset(-10.0);
        make.height.mas_offset(1.0);
    }];
    
    [self.startOverButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pauseButton);
        make.left.equalTo(self.headerContentView).with.offset(10.0);
        make.right.equalTo(self.pauseButton.mas_left).with.offset(-6.0);
        make.height.mas_offset(30.0);
        make.width.equalTo(self.pauseButton);
    }];
    
    [self.pauseButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.horizontalDivider.mas_bottom).with.offset(6.0);
        make.centerX.equalTo(self.headerContentView);
        make.height.mas_offset(30.0);
    }];
    
    [self.optionsButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pauseButton);
        make.left.equalTo(self.pauseButton.mas_right).with.offset(6.0);
        make.right.equalTo(self.headerContentView).with.offset(-10.0);
        make.height.mas_offset(30.0);
        make.width.equalTo(self.pauseButton);
    }];
    
    [self.statusView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pauseButton.mas_bottom).with.offset(6.0);
        make.bottom.equalTo(self.headerContentView);
        make.left.equalTo(self.startOverButton);
        make.right.equalTo(self.optionsButton);
    }];
    
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.statusView);
        make.centerY.equalTo(self.statusView).with.offset(-12.0);
    }];
    
    [self.movesLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom).with.offset(-5.0);
        make.left.right.equalTo(self.statusView);
        make.height.mas_equalTo(28.0);
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.header.contentSize = self.headerContentView.frame.size;
    if (self.headerContentView.frame.size.height == self.header.frame.size.height) {
        self.header.alwaysBounceVertical = NO;
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateHighScoresLabel];
    [self updateGameCenterAchievements];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pause)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [self.header layoutIfNeeded];
    float fontSizeIncrease = (self.headerContentView.frame.size.height - 164.0) / 4.0;
    self.timeLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:41.0 + fontSizeIncrease];
    
    self.adBanner.adUnitID = @"ca-app-pub-8780766193173131/8608065602";
    self.adBanner.rootViewController = self;
    
    GADRequest *request = [GADRequest request];
    [self.adBanner loadRequest:request];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.gameInProgress && (self.isBeingPresented || self.isMovingToParentViewController)) {
        [self.grid performSelector:@selector(scramble) withObject:nil afterDelay:1.0];
        CGPoint bottomOffset =
            CGPointMake(0, self.header.contentSize.height - self.header.bounds.size.height);
        [UIView animateWithDuration:0.5 delay:1.0 options:0 animations:^{
            self.header.contentOffset = bottomOffset;
        } completion:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.gameInProgress) self.isPaused = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Timer

- (void)startTimer {
    if (self.timer && self.timer.isValid) return;
    
    self.timerStartTime = CFAbsoluteTimeGetCurrent();
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.005
                                                  target:self
                                                selector:@selector(timerTick)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)stopTimer {
    CFAbsoluteTime currentTime = CFAbsoluteTimeGetCurrent();
    self.timeElapsed += currentTime - self.timerStartTime;
    self.timeLabel.text = [self formattedTime:self.timeElapsed];
    [self.timer invalidate];
}

- (void)timerTick {
    CFAbsoluteTime currentTime = CFAbsoluteTimeGetCurrent();
    float timeElapsed = self.timeElapsed + currentTime - self.timerStartTime;
    self.timeLabel.text = [self formattedTime:timeElapsed];
}

- (NSString *)formattedTime:(float)timeElapsed {
    int milliseconds = (int) (timeElapsed * 100) % 100;
    int seconds = (int) timeElapsed % 60;
    int minutes = (int) (timeElapsed / 60) % 3600;
    int hours = (int) timeElapsed / 3600;
    
    if (hours > 0) {
        return [NSString stringWithFormat:@"%d:%02d:%02d.%02d", hours, minutes, seconds, milliseconds];
    }
    else if (minutes > 0) {
        return [NSString stringWithFormat:@"%d:%02d.%02d", minutes, seconds, milliseconds];
    }
    return [NSString stringWithFormat:@"%d.%02d", seconds, milliseconds];
}

# pragma mark - Game Actions

- (void)startOver {
    [self stopTimer];
    self.gameInProgress = NO;
    self.isPaused = NO;
    self.timeElapsed = 0;
    self.numMoves = 0;
    self.movesLabel.text = @"No Moves";
    self.timeLabel.text = @"0.00";
    [self.grid scramble];
    CGPoint bottomOffset =
        CGPointMake(0, self.header.contentSize.height - self.header.bounds.size.height);
    [UIView animateWithDuration:0.5 delay:1.0 options:0 animations:^{
        self.header.contentOffset = bottomOffset;
    } completion:nil];
}

- (void)pauseButtonPressed {
    self.isPaused = !self.isPaused;
}

- (void)pause {
    self.isPaused = YES;
}

- (void)setIsPaused:(BOOL)paused {
    if (paused && self.gameInProgress) {
        [self stopTimer];
        [self.pauseButton setTitle:@"PAUSED" forState:UIControlStateNormal];
        self.pauseButton.backgroundColor = UIColor.slideDarkGrey;
    }
    else if (!paused) {
        if (self.gameInProgress) [self startTimer];
        [self.pauseButton setTitle:@"PAUSE" forState:UIControlStateNormal];
        self.pauseButton.backgroundColor = UIColor.slideGrey;
    }
    _isPaused = paused;
}

- (void)showOptions {
    if (self.header.contentOffset.y != -self.header.contentInset.top) {
        [UIView animateWithDuration:0.3 animations:^{
            self.header.contentOffset = CGPointMake(0, -self.header.contentInset.top);
        } completion:^(BOOL finished) {
            GameOptionsViewController *optionsScreen = [GameOptionsViewController new];
            [self.navigationController pushViewController:optionsScreen animated:YES];
        }];
    }
    else {
        GameOptionsViewController *optionsScreen = [GameOptionsViewController new];
        [self.navigationController pushViewController:optionsScreen animated:YES];
    }
}

#pragma mark - GridViewDelegate Methods

- (void)moveMade {
    self.gameInProgress = YES;
    self.isPaused = NO;
    self.numMoves += 1;
    self.movesLabel.text =
        (self.numMoves == 1) ? @"1 Move" :[NSString stringWithFormat:@"%d Moves", self.numMoves];
    
    CGPoint bottomOffset =
        CGPointMake(0, self.headerContentView.frame.size.height - self.header.bounds.size.height);
    [self.header setContentOffset:bottomOffset animated:YES];
}

- (void)gridSolved {
    if (self.gameInProgress) {
        [self stopTimer];
        self.gameInProgress = NO;
        [self showVictoryView];
    }
}

#pragma mark - UIScrollViewDelegate Methods

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint bottomOffset =
        CGPointMake(0, self.header.contentSize.height - self.header.bounds.size.height);
    self.isPaused = (self.header.contentOffset.y != bottomOffset.y && self.gameInProgress);
}

#pragma mark - End of Game

- (void)showVictoryView {
    self.victoryView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.victoryView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.0]];
    [self.view addSubview:self.victoryView];
    
    UIView *dialogView = [UIView new];
    dialogView.backgroundColor = UIColor.slideGrey;
    dialogView.layer.cornerRadius = 10.0;
    [self.victoryView addSubview:dialogView];
    
    [dialogView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(300.0);
        make.height.mas_equalTo(250.0);
        make.centerX.equalTo(self.victoryView);
        make.centerY.equalTo(self.victoryView).with.offset(-100.0);
    }];
    
    BOOL isRecord = [self updateHighScoreWithTime:self.timeElapsed andMoveCount:self.numMoves];
    
    if (isRecord) {
        UILabel *recordLabel = [UILabel new];
        recordLabel.text = @"New Record!";
        recordLabel.textColor = UIColor.slideMainColor;
        recordLabel.textAlignment = NSTextAlignmentCenter;
        recordLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0];
        [dialogView addSubview:recordLabel];
        
        [recordLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(dialogView).with.offset(10.0);
            
            make.left.right.equalTo(dialogView);
            make.height.mas_equalTo(20.0);
        }];
    }
    
    UILabel *youWinLabel = [UILabel new];
    youWinLabel.text = @"You Win!";
    youWinLabel.textColor = UIColor.slideMainColor;
    youWinLabel.textAlignment = NSTextAlignmentCenter;
    youWinLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:44.0];
    [dialogView addSubview:youWinLabel];
    
    [youWinLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dialogView).with.offset(30.0);
        make.left.right.equalTo(dialogView);
        make.height.mas_equalTo(50.0);
    }];
    
    UILabel *statsLabel = [UILabel new];
    statsLabel.text =
        [NSString stringWithFormat:@"%d moves in %@", self.numMoves, [self formattedTime:self.timeElapsed]];
    statsLabel.textColor = UIColor.slideMainColor;
    statsLabel.textAlignment = NSTextAlignmentCenter;
    statsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0];
    [dialogView addSubview:statsLabel];
    
    [statsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(youWinLabel.mas_bottom);
        make.left.right.equalTo(dialogView);
        make.height.mas_equalTo(28.0);
    }];
    
    SlideButton *playAgainButton = [SlideButton new];
    playAgainButton.backgroundColor = UIColor.whiteColor;
    playAgainButton.layer.cornerRadius = 10.0;
    playAgainButton.titleLabel.font = [UIFont fontWithName:@"System" size:15.0];
    [playAgainButton setTitle:@"Play Again" forState:UIControlStateNormal];
    [playAgainButton setTitleColor:UIColor.slideMainColor forState:UIControlStateNormal];
    [playAgainButton addTarget:self
                        action:@selector(playAgain)
              forControlEvents:UIControlEventTouchUpInside];
    [dialogView addSubview:playAgainButton];
    
    [playAgainButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(statsLabel.mas_bottom).with.offset(15.0);
        make.centerX.equalTo(dialogView);
        make.width.mas_equalTo(164.0);
        make.height.mas_equalTo(44.0);
    }];
    
    SlideButton *quitButton = [SlideButton new];
    quitButton.backgroundColor = UIColor.whiteColor;
    quitButton.layer.cornerRadius = 10.0;
    quitButton.titleLabel.font = [UIFont fontWithName:@"System" size:15.0];
    [quitButton setTitle:@"Quit" forState:UIControlStateNormal];
    [quitButton setTitleColor:UIColor.slideMainColor forState:UIControlStateNormal];
    [quitButton addTarget:self action:@selector(quit) forControlEvents:UIControlEventTouchUpInside];
    [dialogView addSubview:quitButton];
    
    [quitButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(playAgainButton.mas_bottom).with.offset(8.0);
        make.width.height.centerX.equalTo(playAgainButton);
    }];
    
    [UIView animateWithDuration:0.4 animations:^{
        [self.victoryView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.75]];
    }];
}


- (void)playAgain {
    [self.victoryView removeFromSuperview];
    self.victoryView = nil;
    [self performSelector:@selector(startOver) withObject:nil afterDelay:0.7];
}

- (void)quit {
    SlideRootViewController *viewController = [SlideRootViewController new];
    [self presentViewController:viewController animated:YES completion:nil];
}

- (BOOL)updateHighScoreWithTime:(float)time andMoveCount:(int)numMoves {
    if (!self.bestTimeKey || !self.bestMoveCountKey) return NO;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL newHighScoreSet = NO;

    if (time < [defaults doubleForKey:self.bestTimeKey] || [defaults doubleForKey:self.bestTimeKey] == 0) {
        newHighScoreSet = YES;
        [defaults setObject:@(time) forKey:self.bestTimeKey];
        if (self.gameCenterBestTimeKey) {
            [[GCHelper defaultHelper] reportScore:(time * 100) forLeaderboardID:self.gameCenterBestTimeKey];
        }
    }
    if (numMoves < [defaults integerForKey:self.bestMoveCountKey] || [defaults integerForKey:self.bestMoveCountKey] == 0) {
        newHighScoreSet = YES;
        [defaults setObject:@(numMoves) forKey:self.bestMoveCountKey];
        if (self.gameCenterBestMoveCountKey) {
            [[GCHelper defaultHelper] reportScore:(self.numMoves)
                                 forLeaderboardID:self.gameCenterBestMoveCountKey];
        }
    }
    
    [self updateHighScoresLabel];
    [self updateGameCenterAchievements];
    return newHighScoreSet;
}

- (void)updateHighScoresLabel {
    if (!self.bestTimeKey || !self.bestMoveCountKey) return;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    double time = [defaults doubleForKey:self.bestTimeKey];
    int numMoves = (int)[defaults integerForKey:self.bestMoveCountKey];
    
    NSString *timeString = [self formattedTime:time];
    NSString *moveString =
        (numMoves == 1) ? @"1 move" : [NSString stringWithFormat:@"%i moves", numMoves];
    self.highScoresLabel.text = [NSString stringWithFormat:@"%@ in %@", moveString, timeString];
}

- (void)updateGameCenterAchievements {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *easyBestTimeAchievements =
        @{@"beatEasy":@(INFINITY), @"easy30":@30, @"easy15":@15, @"easy5":@5};
    NSDictionary *easyBestMoveCountAchievements =
        @{@"100easy":@100, @"50easy":@50, @"15easy":@15};
    NSDictionary *mediumBestTimeAchievements =
        @{@"beatMedium":@(INFINITY), @"medium1":@60, @"medium30":@30, @"medium15" : @15};
    NSDictionary *mediumBestMoveCountAchievements =
        @{@"200medium":@200, @"100medium":@100, @"50medium":@50};
    NSDictionary *hardBestTimeAchievements =
        @{@"beatHard":@(INFINITY), @"hard2":@120, @"hard1":@60, @"hard30" : @30};
    NSDictionary *hardBestMoveCountAchievements =
        @{@"300hard":@300, @"150hard":@150, @"75hard":@75};
    
    NSDictionary *achievementsMap =
        @{@"bestTime3":easyBestTimeAchievements,
          @"bestTime4":mediumBestTimeAchievements,
          @"bestTime5":hardBestTimeAchievements,
          @"bestMoveCount3":easyBestMoveCountAchievements,
          @"bestMoveCount4":mediumBestMoveCountAchievements,
          @"bestMoveCount5":hardBestMoveCountAchievements};

    for (NSString *defaultsKey in achievementsMap) {
        NSDictionary *achievements = achievementsMap[defaultsKey];
        for (NSString *achievementIdentifier in achievements) {
            float value = [defaults floatForKey:defaultsKey];
            if (value > 0 && value < [achievements[achievementIdentifier] floatValue]) {
                [[GCHelper defaultHelper] reportAchievementIdentifier:achievementIdentifier
                                                      percentComplete:100.0f];
            }
        }
    }
}

@end
