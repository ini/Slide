//  Copyright © 2016 Insi. All rights reserved.

#import <UIKit/UIKit.h>
#import "HowToPlayViewController.h"
#import "MainMenuViewController.h"


@interface SlideRootViewController : UINavigationController

@property (nonatomic) BOOL navigationBarTransparent;

- (void)updateNavigationControllerColorsWithColor:(UIColor *)color;

@end
