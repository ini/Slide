//  Copyright © 2016 Insi. All rights reserved.

#import "OptionsViewController.h"


@interface OptionsViewController ()

@property UILabel *optionsLabel;
@property SlideButton *resetGameButton;
@property SlideButton *howToPlayButton;
@property SlideButton *gameCenterButton;
@property SlideButton *practiceModeButton;
@property SlideButton *creditsButton;
@property SlideButton *backButton;

@property UIView *creditsView;

@end


@implementation OptionsViewController

- (id)init {
    self = [super init];
    
    if (self) {
        self.view.backgroundColor = UIColor.whiteColor;
        
        self.optionsLabel = [UILabel new];
        self.optionsLabel.text = @"Options";
        self.optionsLabel.textAlignment = NSTextAlignmentCenter;
        self.optionsLabel.textColor = UIColor.slideBlue;
        self.optionsLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:40.0];
        [self.view addSubview:self.optionsLabel];
        
        self.resetGameButton = [SlideButton new];
        self.resetGameButton.backgroundColor = UIColor.slideGrey;
        self.resetGameButton.layer.cornerRadius = 10.0;
        self.resetGameButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:23.0];
        [self.resetGameButton setTitle:@"Reset Game" forState:UIControlStateNormal];
        [self.resetGameButton setTitleColor:UIColor.slideBlue forState:UIControlStateNormal];
        [self.resetGameButton addTarget:self
                                 action:@selector(resetGame)
                       forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.resetGameButton];
        
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

        self.gameCenterButton = [SlideButton new];
        self.gameCenterButton.backgroundColor = UIColor.slideGrey;
        self.gameCenterButton.layer.cornerRadius = 10.0;
        self.gameCenterButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:23.0];
        [self.gameCenterButton setTitle:@"Game Center" forState:UIControlStateNormal];
        [self.gameCenterButton setTitleColor:UIColor.slideBlue forState:UIControlStateNormal];
        [self.gameCenterButton addTarget:self
                                  action:@selector(showGameCenter)
                        forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.gameCenterButton];
        
        self.practiceModeButton = [SlideButton new];
        self.practiceModeButton.backgroundColor = UIColor.slideGrey;
        self.practiceModeButton.layer.cornerRadius = 10.0;
        self.practiceModeButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:23.0];
        [self.practiceModeButton setTitle:@"Practice Mode" forState:UIControlStateNormal];
        [self.practiceModeButton setTitleColor:UIColor.slideBlue forState:UIControlStateNormal];
        [self.practiceModeButton addTarget:self
                                    action:@selector(showPracticeMode)
                          forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.practiceModeButton];
        
        self.creditsButton = [SlideButton new];
        self.creditsButton.backgroundColor = UIColor.slideGrey;
        self.creditsButton.layer.cornerRadius = 10.0;
        self.creditsButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:23.0];
        [self.creditsButton setTitle:@"Credits" forState:UIControlStateNormal];
        [self.creditsButton setTitleColor:UIColor.slideBlue forState:UIControlStateNormal];
        [self.creditsButton addTarget:self
                               action:@selector(showCredits)
                     forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.creditsButton];
        
        self.backButton = [SlideButton new];
        self.backButton.backgroundColor = UIColor.slideGrey;
        self.backButton.layer.cornerRadius = 10.0;
        self.backButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:23.0];
        [self.backButton setTitle:@"Back" forState:UIControlStateNormal];
        [self.backButton setTitleColor:UIColor.slideBlue forState:UIControlStateNormal];
        [self.backButton addTarget:self
                            action:@selector(back)
                  forControlEvents:UIControlEventTouchUpInside];
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
    
    [self.resetGameButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom).multipliedBy(0.2);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(250.0);
        make.height.mas_equalTo(50.0);
    }];
    
    [self.howToPlayButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.resetGameButton.mas_bottom).with.offset(8.0);
        make.centerX.width.height.equalTo(self.resetGameButton);
    }];
    
    [self.gameCenterButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.howToPlayButton.mas_bottom).with.offset(8.0);
        make.centerX.width.height.equalTo(self.resetGameButton);
    }];
    
    [self.practiceModeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.gameCenterButton.mas_bottom).with.offset(8.0);
        make.centerX.width.height.equalTo(self.resetGameButton);
    }];
    
    [self.creditsButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.practiceModeButton.mas_bottom).with.offset(8.0);
        make.centerX.width.height.equalTo(self.resetGameButton);
    }];
    
    [self.backButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.creditsButton.mas_bottom).with.offset(8.0);
        make.centerX.width.height.equalTo(self.resetGameButton);
    }];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)resetGame {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Reset Game"
                                                                   message:@"Are you sure you want to reset the game? This will clear all of your high scores and achievements, from your device and from Game Center."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *reset = [UIAlertAction actionWithTitle:@"Reset"
                                                    style:UIAlertActionStyleDestructive
                                                  handler:^(UIAlertAction *action) {
        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
        NSDictionary *defaultsDictionary =
            [[NSUserDefaults standardUserDefaults] persistentDomainForName: appDomain];
                                                      
        for (NSString *key in [defaultsDictionary allKeys]) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        }
                                                      
        [[GCHelper defaultHelper] resetAchievements];
        
        UIAlertController *finishedAlert =
            [UIAlertController alertControllerWithTitle:@"Game Reset"
                                                message:@"All of your highscores and achievements have been cleared."
                                         preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok =
            [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [finishedAlert addAction:ok];
        [self presentViewController:finishedAlert animated:YES completion:nil];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];

    [alert addAction:reset];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showHowToPlay {
    HowToPlayViewController *howToPlayScreen = [HowToPlayViewController new];
    [self presentViewController:howToPlayScreen animated:YES completion:nil];
}

- (void)showGameCenter {
    if (!GKLocalPlayer.localPlayer.isAuthenticated) {
        if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)]) {
            NSOperatingSystemVersion ios10 =
                (NSOperatingSystemVersion){.majorVersion = 10, .minorVersion = 0, .patchVersion = 0};
            if ([NSProcessInfo.processInfo isOperatingSystemAtLeastVersion:ios10]) {
                UIAlertController *alert =
                    [UIAlertController alertControllerWithTitle:@"Game Center Unavailable"
                                                        message:@"Go to your Game Center preferences in the Settings app and sign in."
                                                 preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *dismiss = [UIAlertAction actionWithTitle:@"Dismiss"
                                                                 style:UIAlertActionStyleCancel
                                                               handler:nil];
                [alert addAction:dismiss];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"gamecenter:"]];
            }
        }
        else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"gamecenter:"]];
        }
    }
    else {
        [[GCHelper defaultHelper] showLeaderboardOnViewController:self];
    }
}

- (void)showPracticeMode {
    PracticeViewController *practiceScreen = [PracticeViewController new];
    [self presentViewController:practiceScreen animated:YES completion:nil];
}

- (void)showCredits {
    self.creditsView = [UIView new];
    self.creditsView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.creditsView];
    
    [self.creditsView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    SlideButton *creditsBackButton = [SlideButton new];
    creditsBackButton = [SlideButton new];
    creditsBackButton.backgroundColor = UIColor.slideGrey;
    creditsBackButton.layer.cornerRadius = 10.0;
    creditsBackButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:23.0];
    [creditsBackButton setTitle:@"Back" forState:UIControlStateNormal];
    [creditsBackButton setTitleColor:UIColor.slideBlue forState:UIControlStateNormal];
    [creditsBackButton addTarget:self
                        action:@selector(back)
              forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *creditsBackButtonRecognizer = [UITapGestureRecognizer new];
    [creditsBackButtonRecognizer addTarget:self action:@selector(dismissCredits)];
    [creditsBackButton addGestureRecognizer:creditsBackButtonRecognizer];
    [self.creditsView addSubview:creditsBackButton];
    
    [creditsBackButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.backButton);
    }];
    
    UILabel *versionLabel = [UILabel new];
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    versionLabel.text = [NSString stringWithFormat:@"Version %@", version];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.textColor = UIColor.slideBlue;
    versionLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:28.0];
    [self.creditsView addSubview:versionLabel];
    
    [versionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.creditsView.mas_bottom).multipliedBy(0.2);
        make.centerX.equalTo(self.creditsView);
        make.width.mas_equalTo(280.0);
        make.height.mas_equalTo(48.0);
    }];
    
    UILabel *copyrightLabel = [UILabel new];
    copyrightLabel.text = @"© Ini Oguntola, 2016";
    copyrightLabel.textAlignment = NSTextAlignmentCenter;
    copyrightLabel.textColor = UIColor.slideBlue;
    copyrightLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:22.0];
    [self.creditsView addSubview:copyrightLabel];
    
    [copyrightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(versionLabel.mas_bottom);
        make.width.height.centerX.equalTo(versionLabel);
    }];
}

- (void)dismissCredits {
    [self.creditsView removeFromSuperview];
    self.creditsView = nil;
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
