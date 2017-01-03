// Copyright © 2016 Insi. All rights reserved.

#import "MainMenuViewController.h"


@interface MainMenuViewController ()

@property UILabel *titleLabel;
@property SlideButton *playGameButton;
@property SlideButton *practiceModeButton;
@property SlideButton *optionsButton;

@end


@implementation MainMenuViewController

- (id)init {
    self = [super init];
    
    if (self) {
        self.view.backgroundColor = UIColor.whiteColor;
        
        self.titleLabel = [UILabel new];
        self.titleLabel.text = @"Slide";
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:75.0];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = UIColor.slideMainColor;
        [self.view addSubview:self.titleLabel];

        self.playGameButton = [SlideButton new];
        self.playGameButton.highlightStyle = SlideButtonHighlightStyleText;
        [self.playGameButton setTitle:@"Play Game" forState:UIControlStateNormal];
        [self.playGameButton setTitleColor:UIColor.slideMainColor forState:UIControlStateNormal];
        self.playGameButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:22.0];
        self.playGameButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.playGameButton addTarget:self
                                action:@selector(presentDifficultyScreen)
                      forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.playGameButton];
        
        self.practiceModeButton = [SlideButton new];
        self.practiceModeButton.highlightStyle = SlideButtonHighlightStyleText;
        [self.practiceModeButton setTitle:@"Practice Mode" forState:UIControlStateNormal];
        [self.practiceModeButton setTitleColor:UIColor.slideMainColor forState:UIControlStateNormal];
        self.practiceModeButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:22.0];
        self.practiceModeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.practiceModeButton addTarget:self
                                    action:@selector(presentPracticeModeScreen)
                          forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.practiceModeButton];
        
        self.optionsButton = [SlideButton new];
        self.optionsButton.highlightStyle = SlideButtonHighlightStyleText;
        [self.optionsButton setTitle:@"Options" forState:UIControlStateNormal];
        [self.optionsButton setTitleColor:UIColor.slideMainColor forState:UIControlStateNormal];
        self.optionsButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:22.0];
        self.optionsButton.titleLabel.textAlignment = NSTextAlignmentCenter;
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
        make.height.mas_equalTo(35.0);
    }];

    [self.practiceModeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.playGameButton.mas_bottom).with.offset(15.0);
        make.height.mas_equalTo(35.0);
    }];
    
    [self.optionsButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.practiceModeButton.mas_bottom).with.offset(15.0);
        make.height.mas_equalTo(35.0);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self initGameCenter];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
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
    [self.navigationController pushViewController:difficultyScreen animated:YES];
}

- (void)presentPracticeModeScreen {
    PracticeChooserViewController *practiceChooserScreen = [PracticeChooserViewController new];
    [self.navigationController pushViewController:practiceChooserScreen animated:YES];
}

- (void)presentOptionsScreen {
    OptionsViewController *optionsScreen = [OptionsViewController new];
    [self.navigationController pushViewController:optionsScreen animated:YES];
}

@end
