//  Copyright © 2016 Insi. All rights reserved.

#import "GameViewController.h"
#import "PracticeOptionsViewController.h"
#import "SlideRootViewController.h"


@interface PracticeChooserViewController : UIViewController
    <UIPickerViewDelegate, UIPickerViewDataSource>

- (id)initWithHeight:(int)height andWidth:(int)width;

@end


@interface PracticeViewController : GameViewController

@end
