//  Copyright © 2016 Insi. All rights reserved.

#import "PracticeOptionsViewController.h"
#import "MainMenuViewController.h"


@interface PracticeOptionsViewController ()

@property int previousHeight;
@property int previousWidth;
@property SlideButton *changeBoardSizeButton;
@property SlideButton *howToPlayButton;
@property SlideButton *menuButton;

@end


@implementation PracticeOptionsViewController

- (id)initWithPreviousHeight:(int)height andPreviousWidth:(int)width {
    self = [super init];
    
    if (self) {
        self.title = @"Practice Options";
        self.view.backgroundColor = UIColor.whiteColor;
        self.previousHeight = height;
        self.previousWidth = width;
        
        self.changeBoardSizeButton = [SlideButton new];
        self.changeBoardSizeButton.backgroundColor = UIColor.slideGrey;
        self.changeBoardSizeButton.layer.cornerRadius = 10.0;
        self.changeBoardSizeButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:23.0];
        [self.changeBoardSizeButton setTitle:@"Change Board Size" forState:UIControlStateNormal];
        [self.changeBoardSizeButton setTitleColor:UIColor.slideMainColor forState:UIControlStateNormal];
        [self.changeBoardSizeButton addTarget:self
                                        action:@selector(changeBoardSize)
                              forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.changeBoardSizeButton];
        
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)changeBoardSize {
    PracticeChooserViewController *practiceScreenChooser = [[PracticeChooserViewController alloc] initWithHeight:self.previousHeight andWidth:self.previousWidth];
    [self.navigationController pushViewController:practiceScreenChooser animated:YES];
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
