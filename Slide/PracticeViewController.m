//  Copyright © 2016 Insi. All rights reserved.

#import "PracticeViewController.h"


@interface PracticeChooserViewController ()

@property UIPickerView *picker;
@property UILabel *byLabel;
@property SlideButton *playButton;

@end


@implementation PracticeChooserViewController

- (id)init {
    return [self initWithHeight:4 andWidth:4];
}

- (id)initWithHeight:(int)height andWidth:(int)width {
    self = [super init];
    
    if (self) {
        self.view.backgroundColor = UIColor.whiteColor;
        
        self.picker = [UIPickerView new];
        self.picker.backgroundColor = UIColor.whiteColor;
        self.picker.delegate = self;
        self.picker.dataSource = self;
        
        [self.picker selectRow:(height - 2) inComponent:0 animated:NO];
        [self.picker selectRow:(width - 2) inComponent:2 animated:NO];
            
        [self.view addSubview:self.picker];
            
        self.byLabel = [UILabel new];
        self.byLabel.text = @"by";
        self.byLabel.textColor = [UIColor.slideMainColor colorWithAlphaComponent:0.9];
        self.byLabel.textAlignment = NSTextAlignmentCenter;
        self.byLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:45.0];
        [self.view addSubview:self.byLabel];
            
        self.playButton = [SlideButton new];
        self.playButton.backgroundColor = UIColor.slideGrey;
        self.playButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:22.0];
        [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
        [self.playButton setTitleColor:UIColor.slideMainColor forState:UIControlStateNormal];
        [self.playButton addTarget:self
                            action:@selector(showPracticeGame)
                  forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.playButton];
        
        [self updateViewConstraints];
    }
    
    return self;
}

- (void)updateViewConstraints {
    [super updateViewConstraints];

    [self.picker mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(216.0);
        make.width.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).with.offset(-50.0);
    }];
    
    [self.byLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.picker);
    }];
    
    [self.playButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(60.0);
    }];
}

- (void)showPracticeGame {
    int height = (int)[self.picker selectedRowInComponent:0] + 2;
    int width = (int)[self.picker selectedRowInComponent:2] + 2;
    
    PracticeViewController *practiceScreen = [[PracticeViewController alloc] initWithGridHeight:height andWidth:width];
    SlideRootViewController *practiceNavigationController = [[SlideRootViewController alloc] initWithRootViewController:practiceScreen];
    [self presentViewController:practiceNavigationController animated:YES completion:nil];
}

# pragma mark - UIPickerViewDelegate / UIPickerViewDataSource Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0 || component == 2) return 7;
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 70.0 + 10.0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    UILabel *rowLabel = [UILabel new];
    rowLabel.text = [NSString stringWithFormat:@"%d", (int)row + 2];
    rowLabel.textColor = UIColor.slideMainColor;
    rowLabel.textAlignment = NSTextAlignmentCenter;
    rowLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:60.0];
    
    if (component == 0) {
        rowLabel.textAlignment = NSTextAlignmentRight;
    }
    else if (component == 2) {
        rowLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    return rowLabel;
}

@end


@interface PracticeViewController ()

@property int gridHeight;
@property int gridWidth;

@end


@implementation PracticeViewController

- (id)initWithGridHeight:(int)height andWidth:(int)width {
    self = [super initWithGridHeight:height andWidth:width];
    
    if (self) {
        self.gridHeight = height;
        self.gridWidth = width;
        self.yourBestLabel.hidden = YES;
        self.highScoresLabel.hidden = YES;
        self.horizontalDivider.hidden = YES;
        self.descriptionLabel.hidden = YES;
    }
    
    return self;
}

- (void)updateHeaderConstraints {
    [self.header mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.gridContainerView.mas_top).with.offset(-10.0);
    }];
    
    [self.headerContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.top.left.right.equalTo(self.header);
        make.height.greaterThanOrEqualTo(self.header);
        make.height.mas_greaterThanOrEqualTo(110.0);
    }];

    [self.startOverButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pauseButton);
        make.left.equalTo(self.headerContentView).with.offset(10.0);
        make.right.equalTo(self.pauseButton.mas_left).with.offset(-6.0);
        make.height.mas_offset(30.0);
        make.width.equalTo(self.pauseButton);
    }];
    
    [self.pauseButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerContentView).with.offset(10.0);
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

- (void)showOptions {
    PracticeOptionsViewController *optionsScreen = [[PracticeOptionsViewController alloc] initWithPreviousHeight:self.gridHeight andPreviousWidth:self.gridWidth];
    [self.navigationController pushViewController:optionsScreen animated:YES];
}

@end
