//  Copyright © 2016 Insi. All rights reserved.

#import "GameOptionsViewController.h"
#import "MainMenuViewController.h"

@interface GameOptionsViewController ()

@property SlideButton *changeDifficultyButton;
@property SlideButton *howToPlayButton;
@property SlideButton *menuButton;

@end


@implementation GameOptionsViewController

- (id)init {
    self = [super init];
    
    if (self) {
        self.title = @"Game Options";
        self.view.backgroundColor = UIColor.whiteColor;
        
        self.changeDifficultyButton = [SlideButton new];
        self.changeDifficultyButton.backgroundColor = UIColor.slideGrey;
        self.changeDifficultyButton.layer.cornerRadius = 10.0;
        self.changeDifficultyButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:23.0];
        [self.changeDifficultyButton setTitle:@"Change Difficulty" forState:UIControlStateNormal];
        [self.changeDifficultyButton setTitleColor:UIColor.slideMainColor forState:UIControlStateNormal];
        [self.changeDifficultyButton addTarget:self
                                        action:@selector(changeDifficulty)
                              forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.changeDifficultyButton];
        
        self.howToPlayButton = [SlideButton new];
        self.howToPlayButton.backgroundColor = UIColor.slideGrey;
        self.howToPlayButton.layer.cornerRadius = 10.0;
        self.howToPlayButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:23.0];
        [self.howToPlayButton setTitle:@"How to Play" forState:UIControlStateNormal];
        [self.howToPlayButton setTitleColor:UIColor.slideMainColor forState:UIControlStateNormal];
        [self.howToPlayButton addTarget:self
                                 action:@selector(showHowToPlay)
                       forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.howToPlayButton];
        
        self.menuButton = [SlideButton new];
        self.menuButton.backgroundColor = UIColor.slideGrey;
        self.menuButton.layer.cornerRadius = 10.0;
        self.menuButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:23.0];
        [self.menuButton setTitle:@"Menu" forState:UIControlStateNormal];
        [self.menuButton setTitleColor:UIColor.slideMainColor forState:UIControlStateNormal];
        [self.menuButton addTarget:self action:@selector(menu) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.menuButton];
        
        [self updateViewConstraints];
    }
    return self;
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    [self.changeDifficultyButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom).multipliedBy(0.25);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(250.0);
        make.height.mas_equalTo(50.0);
    }];
    
    [self.howToPlayButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.changeDifficultyButton.mas_bottom).with.offset(8.0);
        make.centerX.width.height.equalTo(self.changeDifficultyButton);
    }];
    
    [self.menuButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.howToPlayButton.mas_bottom).with.offset(8.0);
        make.centerX.width.height.equalTo(self.changeDifficultyButton);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)changeDifficulty {
    DifficultyViewController *difficultyScreen = [DifficultyViewController new];
    [self.navigationController pushViewController:difficultyScreen animated:YES];
}

- (void)showHowToPlay {
    HowToPlayViewController *howToPlayScreen = [HowToPlayViewController new];
    [self presentViewController:howToPlayScreen animated:YES completion:nil];
}

- (void)menu {
    SlideRootViewController *viewController = [SlideRootViewController new];
    [self presentViewController:viewController animated:YES completion:nil];
}

@end
