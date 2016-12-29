// Copyright © 2016 Insi. All rights reserved.

#import "DifficultyViewController.h"


@interface DifficultyButton : UIView

@property UIImageView *imageView;
@property UILabel *descriptionLabel;

@end


@implementation DifficultyButton

- (id)initWithImage:(UIImage *)image withDescription:(NSString *)description {
    self = [super init];
    
    if (self) {
        self.imageView = [[UIImageView alloc] initWithImage:image];
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:self.imageView];
        
        self.descriptionLabel = [UILabel new];
        self.descriptionLabel.text = description;
        self.descriptionLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:20.0];
        self.descriptionLabel.textAlignment = NSTextAlignmentCenter;
        self.descriptionLabel.textColor = UIColor.slideBlue;
        [self addSubview:self.descriptionLabel];
    }
    return self;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)updateConstraints {
    [super updateConstraints];
    
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).with.offset(15.0);
        make.width.height.mas_equalTo(75.0);
    }];
    
    [self.descriptionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.imageView.mas_bottom).with.offset(3.0);
        make.width.mas_equalTo(88.0);
        make.height.mas_equalTo(28.0);
    }];
}

- (void)addActionOnTap:(nonnull SEL)action withTarget:(id)target {
    UITapGestureRecognizer *tapGestureRecognizer =
        [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self addGestureRecognizer:tapGestureRecognizer];
}

@end


@interface DifficultyViewController ()

@property SlideButton *backButton;
@property DifficultyButton *easyButton;
@property DifficultyButton *mediumButton;
@property DifficultyButton *hardButton;

@end

@implementation DifficultyViewController

- (id)init {
    self = [super init];
    
    self.view.backgroundColor = UIColor.whiteColor;

    self.backButton = [SlideButton new];
    self.backButton.backgroundColor = UIColor.slideGrey;
    [self.backButton setTitle:@"Back" forState:UIControlStateNormal];
    [self.backButton setTitleColor:UIColor.slideBlue forState:UIControlStateNormal];
    self.backButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0];
    self.backButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.backButton.layer.cornerRadius = 10.0;
    [self.backButton addTarget:self
                        action:@selector(back)
              forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
    
    self.easyButton = [[DifficultyButton alloc] initWithImage:[UIImage imageNamed:@"easy.png"] withDescription:@"Easy"];
    [self.easyButton addActionOnTap:@selector(presentEasyScreen) withTarget:self];
    [self.view addSubview:self.easyButton];
    
    self.mediumButton = [[DifficultyButton alloc] initWithImage:[UIImage imageNamed:@"medium.png"] withDescription:@"Medium"];
    [self.mediumButton addActionOnTap:@selector(presentMediumScreen) withTarget:self];
    [self.view addSubview:self.mediumButton];
    
    self.hardButton = [[DifficultyButton alloc] initWithImage:[UIImage imageNamed:@"hard.png"] withDescription:@"Hard"];
    [self.hardButton addActionOnTap:@selector(presentHardScreen) withTarget:self];
    [self.view addSubview:self.hardButton];

    [self updateViewConstraints];
    
    return self;
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    [self.backButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).with.offset(20.0);
        make.width.mas_equalTo(144.0);
        make.height.mas_equalTo(36.0);
    }];
    
    [self.easyButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_bottom).multipliedBy(0.15);
        make.width.height.mas_equalTo(88.0);
    }];
    
    [self.mediumButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_bottom).multipliedBy(0.40);
        make.width.height.mas_equalTo(88.0);
    }];
    
    [self.hardButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_bottom).multipliedBy(0.65);
        make.width.height.mas_equalTo(88.0);
    }];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)presentEasyScreen {
    GameViewController *easyScreen = [[GameViewController alloc] initWithGridHeight:3 andWidth:3];
    [self presentViewController:easyScreen animated:YES completion:nil];
}

- (void)presentMediumScreen {
    GameViewController *mediumScreen = [[GameViewController alloc] initWithGridHeight:4 andWidth:4];
    [self presentViewController:mediumScreen animated:YES completion:nil];
}

- (void)presentHardScreen {
    GameViewController *hardScreen = [[GameViewController alloc] initWithGridHeight:5 andWidth:5];
    [self presentViewController:hardScreen animated:YES completion:nil];
}

@end
