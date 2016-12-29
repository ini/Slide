//  Copyright © 2016 Insi. All rights reserved.

#import "PracticeOptionsViewController.h"
#import "MainMenuViewController.h"

@interface PracticeOptionsViewController ()

@property UILabel *optionsLabel;
@property SlideButton *changeBoardSizeButton;
@property SlideButton *howToPlayButton;
@property SlideButton *menuButton;
@property SlideButton *backButton;

@end


@implementation PracticeOptionsViewController

- (id)init {
    self = [super init];
    
    if (self) {
        self.view.backgroundColor = UIColor.whiteColor;
        self.optionsLabel = [UILabel new];
        self.optionsLabel.text = @"Practice Options";
        self.optionsLabel.textAlignment = NSTextAlignmentCenter;
        self.optionsLabel.textColor = UIColor.slideBlue;
        self.optionsLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:40.0];
        [self.view addSubview:self.optionsLabel];
        
        self.changeBoardSizeButton = [SlideButton new];
        self.changeBoardSizeButton.backgroundColor = UIColor.slideGrey;
        self.changeBoardSizeButton.layer.cornerRadius = 10.0;
        self.changeBoardSizeButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:23.0];
        [self.changeBoardSizeButton setTitle:@"Change Board Size" forState:UIControlStateNormal];
        [self.changeBoardSizeButton setTitleColor:UIColor.slideBlue forState:UIControlStateNormal];
        [self.changeBoardSizeButton addTarget:self
                                        action:@selector(changeBoardSize)
                              forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.changeBoardSizeButton];
        
        self.howToPlayButton = [SlideButton new];
        self.howToPlayButton.backgroundColor = UIColor.slideGrey;
        self.howToPlayButton.layer.cornerRadius = 10.0;
        self.howToPlayButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:23.0];
        [self.howToPlayButton setTitle:@"How to Play" forState:UIControlStateNormal];
        [self.howToPlayButton setTitleColor:UIColor.slideBlue forState:UIControlStateNormal];
        [self.howToPlayButton addTarget:self
                                 action:@selector(showHowToPlay)
                       forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.howToPlayButton];
        
        self.menuButton = [SlideButton new];
        self.menuButton.backgroundColor = UIColor.slideGrey;
        self.menuButton.layer.cornerRadius = 10.0;
        self.menuButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:23.0];
        [self.menuButton setTitle:@"Menu" forState:UIControlStateNormal];
        [self.menuButton setTitleColor:UIColor.slideBlue forState:UIControlStateNormal];
        [self.menuButton addTarget:self action:@selector(menu) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.menuButton];
        
        self.backButton = [SlideButton new];
        self.backButton.backgroundColor = UIColor.slideGrey;
        self.backButton.layer.cornerRadius = 10.0;
        self.backButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:23.0];
        [self.backButton setTitle:@"Back" forState:UIControlStateNormal];
        [self.backButton setTitleColor:UIColor.slideBlue forState:UIControlStateNormal];
        [self.backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.backButton];
        
        [self updateViewConstraints];
    }
    return self;
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    [self.optionsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom).multipliedBy(0.05);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(320.0);
        make.height.mas_equalTo(60.0);
    }];
    
    [self.changeBoardSizeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom).multipliedBy(0.25);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(250.0);
        make.height.mas_equalTo(50.0);
    }];
    
    [self.howToPlayButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.changeBoardSizeButton.mas_bottom).with.offset(8.0);
        make.centerX.width.height.equalTo(self.changeBoardSizeButton);
    }];
    
    [self.menuButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.howToPlayButton.mas_bottom).with.offset(8.0);
        make.centerX.width.height.equalTo(self.changeBoardSizeButton);
    }];
    
    [self.backButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.menuButton.mas_bottom).with.offset(8.0);
        make.centerX.width.height.equalTo(self.changeBoardSizeButton);
    }];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)changeBoardSize {
    if ([self.presentingViewController isKindOfClass:[PracticeViewController class]]) {
        [(PracticeViewController *)self.presentingViewController showChooserView];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showHowToPlay {
    HowToPlayViewController *howToPlayScreen = [HowToPlayViewController new];
    [self presentViewController:howToPlayScreen animated:YES completion:nil];
}

- (void)menu {
    MainMenuViewController *mainMenuScreen = [MainMenuViewController new];
    [mainMenuScreen setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:mainMenuScreen animated:YES completion:nil];
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
