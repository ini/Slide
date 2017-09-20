// Copyright © 2016 Insi. All rights reserved.

#import "MainMenuViewController.h"


@interface MainMenuViewController ()

@property UILabel *titleLabel;
@property PlayGameSlider *playGameSlider;
@property UIButton *optionsButton;

@end


@implementation MainMenuViewController

- (id)init {
    self = [super init];
    
    if (self) {
        self.view.backgroundColor = UIColor.whiteColor;
        self.shouldPerformSliderBounceAnimation = NO;
        
        self.titleLabel = [UILabel new];
        self.titleLabel.text = @"Slide";
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:75.0];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = UIColor.slideMainColor;
        [self.view addSubview:self.titleLabel];
        
        self.playGameSlider = [PlayGameSlider new];
        self.playGameSlider.delegate = self;
        [self.view addSubview:self.playGameSlider];
        
        self.optionsButton = [UIButton new];
        [self.optionsButton setImage:[[UIImage imageNamed:@"gear_icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                            forState:UIControlStateNormal];
        [self.optionsButton.imageView setTintColor:UIColor.slideDarkGrey];
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
        make.top.equalTo(self.view.mas_top).with.offset(32.0);
        make.width.mas_equalTo(320.0);
        make.height.mas_equalTo(124.0);
    }];
    
    [self.playGameSlider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view).with.offset(30.0);
        make.left.right.equalTo(self.view).inset(20.0);
        make.height.mas_equalTo(70.0);
    }];
    
    [self.optionsButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.view).inset(10.0);
        make.width.height.mas_equalTo(35.0);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self initGameCenter];
    [self.playGameSlider reset];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([self isBeingPresented] || [self isMovingToParentViewController]) {
        if (self.shouldPerformSliderBounceAnimation) {
            [self performSliderBounceAnimation];
        }
    }
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

- (void)presentOptionsScreen {
    OptionsViewController *optionsScreen = [OptionsViewController new];
    [self.navigationController pushViewController:optionsScreen animated:YES];
}

- (void)performSliderBounceAnimation {
    [UIView animateWithDuration:0.2 animations:^{
        [self.playGameSlider.slider setValue:0.2 animated:YES];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3
                              delay:0
             usingSpringWithDamping:0.2
              initialSpringVelocity:5.0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             [self.playGameSlider.slider setValue:0 animated:YES];
                         } completion:nil];
    }];
}

# pragma mark PlayGameSliderDelegate

- (void)unlocked {
    [self presentDifficultyScreen];
}

@end
