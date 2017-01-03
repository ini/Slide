// Copyright © 2016 Insi. All rights reserved.

#import "DifficultyViewController.h"


@interface DifficultyButton : UIView

@property BOOL touchDown;
@property UIImageView *imageView;
@property UILabel *descriptionLabel;

@end


@implementation DifficultyButton

- (id)initWithImage:(UIImage *)image withDescription:(NSString *)description {
    self = [super init];
    
    if (self) {
        self.imageView = [[UIImageView alloc] initWithImage:image];
        self.imageView.backgroundColor = UIColor.slideMainColor;
        self.imageView.clipsToBounds = YES;
        self.imageView.layer.cornerRadius = 3.0;
        [self addSubview:self.imageView];
        
        self.descriptionLabel = [UILabel new];
        self.descriptionLabel.text = description;
        self.descriptionLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:20.0];
        self.descriptionLabel.textAlignment = NSTextAlignmentCenter;
        self.descriptionLabel.textColor = UIColor.slideMainColor;
        [self addSubview:self.descriptionLabel];
    }
    
    return self;
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.touchDown = YES;
    self.descriptionLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20.0];
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).with.offset(15.0);
        make.width.height.mas_equalTo(80.0);
    }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.touchDown) {
        self.descriptionLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:20.0];
    }
    self.touchDown = NO;
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).with.offset(15.0);
        make.width.height.mas_equalTo(75.0);
    }];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}

@end


@interface DifficultyViewController ()

@property DifficultyButton *easyButton;
@property DifficultyButton *mediumButton;
@property DifficultyButton *hardButton;

@end

@implementation DifficultyViewController

- (id)init {
    self = [super init];
    
    if (self) {
        self.title = @"Difficulty";
        self.view.backgroundColor = UIColor.whiteColor;
        
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
    }
    
    return self;
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    [self.easyButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_bottom).multipliedBy(0.17);
        make.width.height.mas_equalTo(106.0);
    }];
    
    [self.mediumButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_bottom).multipliedBy(0.42);
        make.width.height.mas_equalTo(106.0);
    }];
    
    [self.hardButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_bottom).multipliedBy(0.67);
        make.width.height.mas_equalTo(106.0);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)presentEasyScreen {
    GameViewController *easyScreen = [[GameViewController alloc] initWithGridHeight:3 andWidth:3];
    SlideRootViewController *easyNavigationController = [[SlideRootViewController alloc] initWithRootViewController:easyScreen];
    [self presentViewController:easyNavigationController animated:YES completion:nil];
}

- (void)presentMediumScreen {
    GameViewController *mediumScreen = [[GameViewController alloc] initWithGridHeight:4 andWidth:4];
    SlideRootViewController *mediumNavigationController = [[SlideRootViewController alloc] initWithRootViewController:mediumScreen];
    [self presentViewController:mediumNavigationController animated:YES completion:nil];
}

- (void)presentHardScreen {
    GameViewController *hardScreen = [[GameViewController alloc] initWithGridHeight:5 andWidth:5];
    SlideRootViewController *hardNavigationController = [[SlideRootViewController alloc] initWithRootViewController:hardScreen];
    [self presentViewController:hardNavigationController animated:YES completion:nil];
}

@end
