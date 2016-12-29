//  Copyright © 2016 Insi. All rights reserved.

#import "PracticeViewController.h"


@interface PracticeViewController ()

@property int height;
@property int width;

@property UIView *chooserView;

@end

@implementation PracticeViewController

- (id)init {
    self = [super init];
    
    if (self) {
        [self showChooserView];
        self.yourBestLabel.hidden = YES;
        self.highScoresLabel.hidden = YES;
        self.horizontalDivider.hidden = YES;
        self.descriptionLabel.hidden = YES;
    }
    
    return self;
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
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

- (void)showChooserView {
    self.chooserView = [UIView new];
    self.chooserView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.chooserView];
    [self.chooserView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIPickerView *picker = [UIPickerView new];
    picker.backgroundColor = UIColor.whiteColor;
    picker.delegate = self;
    picker.dataSource = self;
    
    [picker selectRow:2 inComponent:0 animated:NO];
    [picker selectRow:2 inComponent:2 animated:NO];
    [self pickerView:picker didSelectRow:2 inComponent:0];
    [self pickerView:picker didSelectRow:2 inComponent:2];
    
    [self.chooserView addSubview:picker];
    [picker mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(216.0);
        make.width.centerX.equalTo(self.chooserView);
        make.centerY.equalTo(self.chooserView).with.offset(-50.0);
    }];
    
    UILabel *byLabel = [UILabel new];
    byLabel.text = @"by";
    byLabel.textColor = [UIColor.slideBlue colorWithAlphaComponent:0.9];
    byLabel.textAlignment = NSTextAlignmentCenter;
    byLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:45.0];
    [self.chooserView addSubview:byLabel];
    [byLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(picker);
    }];
   
    SlideButton *playButton = [SlideButton new];
    playButton.backgroundColor = UIColor.slideGrey;
    playButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:22.0];
    [playButton setTitle:@"Play" forState:UIControlStateNormal];
    [playButton setTitleColor:UIColor.slideBlue forState:UIControlStateNormal];
    [playButton addTarget:self
                   action:@selector(showPracticeGame)
         forControlEvents:UIControlEventTouchUpInside];
    [self.chooserView addSubview:playButton];
    [playButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.chooserView);
        make.height.mas_equalTo(60.0);
    }];
}

- (void)showPracticeGame {
    [UIView transitionWithView:self.chooserView
                      duration:0.25
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
        self.chooserView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.chooserView removeFromSuperview];
        self.chooserView = nil;
        [self performSelector:@selector(startOver) withObject:nil afterDelay:1.0];
    }];
}

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
    rowLabel.textColor = UIColor.slideBlue;
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

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    int height = (int)[pickerView selectedRowInComponent:0] + 2;
    int width = (int)[pickerView selectedRowInComponent:2] + 2;
    [self setGridHeight:height andWidth:width];
}

@end
