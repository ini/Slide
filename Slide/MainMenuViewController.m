// Copyright © 2016 Insi. All rights reserved.

#import "MainMenuViewController.h"


@interface MainMenuViewController ()

@property UILabel *titleLabel;
@property SlideButton *playGameButton;
@property SlideButton *optionsButton;

@end


@implementation MainMenuViewController

- (id)init {
    self = [super init];
    
    if (self) {
        self.view.backgroundColor = UIColor.whiteColor;
        
        self.titleLabel = [UILabel new];
        self.titleLabel.text = @"Slide";
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Ultralight" size:75.0];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = UIColor.slideBlue;
        [self.view addSubview:self.titleLabel];

        self.playGameButton = [SlideButton new];
        self.playGameButton.backgroundColor = UIColor.slideGrey;
        [self.playGameButton setTitle:@"Play Game" forState:UIControlStateNormal];
        [self.playGameButton setTitleColor:UIColor.slideBlue forState:UIControlStateNormal];
        self.playGameButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:25.0];
        self.playGameButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.playGameButton.layer.cornerRadius = 10.0;
        [self.playGameButton addTarget:self
                                action:@selector(presentDifficultyScreen)
                      forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.playGameButton];
        
        self.optionsButton = [SlideButton new];
        self.optionsButton.backgroundColor = UIColor.slideGrey;
        [self.optionsButton setTitle:@"Options" forState:UIControlStateNormal];
        [self.optionsButton setTitleColor:UIColor.slideBlue forState:UIControlStateNormal];
        self.optionsButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:25.0];
        self.optionsButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.optionsButton.layer.cornerRadius = 10.0;
        [self.optionsButton addTarget:self
                                action:@selector(presentOptionsScreen)
                      forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.optionsButton];
        
        [self updateViewConstraints];
    }
    return self;
}

- (void)updateViewConstraints {
    [super updateViewConstraints];

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).with.offset(28.0);
        make.width.mas_equalTo(320.0);
        make.height.mas_equalTo(124.0);
    }];
    
    [self.playGameButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).with.offset(-32.0);
        make.width.mas_equalTo(240.0);
        make.height.mas_equalTo(68.0);
    }];
    
    [self.optionsButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.playGameButton.mas_bottom).with.offset(20.0);
        make.width.mas_equalTo(240.0);
        make.height.mas_equalTo(68.0);
    }];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self initGameCenter];
}

- (void)initGameCenter {
    [[GCHelper defaultHelper] authenticateLocalUserOnCompletion:^{
        [[GCHelper defaultHelper] registerListener:self];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [[GCHelper defaultHelper] reportScore:((int)[defaults integerForKey:@"bestMoveCount3"])
                             forLeaderboardID:@"Best_Moves_3"];
        [[GCHelper defaultHelper] reportScore:(int)([defaults doubleForKey:@"bestTime3"] * 100)
                             forLeaderboardID:@"Best_Time_3"];
        [[GCHelper defaultHelper] reportScore:((int)[defaults integerForKey:@"bestMoveCount4"])
                             forLeaderboardID:@"Best_Moves_4"];
        [[GCHelper defaultHelper] reportScore:(int)([defaults doubleForKey:@"bestTime4"] * 100)
                             forLeaderboardID:@"Best_Time_4"];
        [[GCHelper defaultHelper] reportScore:((int)[defaults integerForKey:@"bestMoveCount5"])
                             forLeaderboardID:@"Best_Moves_5"];
        [[GCHelper defaultHelper] reportScore:(int)([defaults doubleForKey:@"bestTime5"] * 100)
                             forLeaderboardID:@"Best_Time_5"];
    }];
}

- (void)presentDifficultyScreen {
    DifficultyViewController *difficultyScreen = [DifficultyViewController new];
    [difficultyScreen setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:difficultyScreen animated:YES completion:nil];
}

- (void)presentOptionsScreen {
    OptionsViewController *optionsScreen = [OptionsViewController new];
    [optionsScreen setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:optionsScreen animated:YES completion:nil];
}

@end
