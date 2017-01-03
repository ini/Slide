//  Copyright © 2016 Insi. All rights reserved.

#import "SlideRootViewController.h"

CGFloat const backButtonLeftInset = 25.0;
CGFloat const navigationBarHeight = 70.0;


@implementation UIViewController (Slide)

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end


@interface SlideNavigationBar : UINavigationBar

@end


@implementation SlideNavigationBar

- (void)layoutSubviews {
    [super layoutSubviews];
    for (UIView *view in self.subviews.copy) {
        view.frame = ({
            CGRect frame = view.frame;
            CGFloat navigationBarHeight = CGRectGetHeight(self.frame);
            CGFloat viewHeight = CGRectGetHeight(view.frame);
            if (![view isKindOfClass:UILabel.class] && frame.origin.x != 0.0) {
                frame.origin.x = backButtonLeftInset;
            }
            if (frame.origin.x != 0.0) {
                frame.origin.y = (navigationBarHeight - viewHeight) / 2.0;
            }
            frame;
        });
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(self.frame.size.width, navigationBarHeight);
}

@end


@interface SlideRootViewController ()

@end


@implementation SlideRootViewController

- (id)init {
    return [self initWithRootViewController:[MainMenuViewController new]];
}

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithNavigationBarClass:SlideNavigationBar.class toolbarClass:nil];
    
    if (self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"darkMenu"] != nil) {
            self.navigationBarTransparent = ![defaults boolForKey:@"darkMenu"];
        }
        else {
            self.navigationBarTransparent = YES;
        }
        [self addChildViewController:rootViewController];
    }
    
    return self;
}

- (void)updateNavigationControllerColorsWithColor:(UIColor *)color {
    [self setNavigationBarTransparent:self.navigationBarTransparent];
    [self.navigationBar layoutSubviews];
    for (UIViewController __strong *vc in self.viewControllers) {
        if (![vc isEqual:self.visibleViewController]) {
            [vc.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            vc = [vc init];
        }
        vc.navigationController.navigationBar.tintColor =
            (self.navigationBarTransparent) ? color : UIColor.whiteColor;
        [self configureViewController:vc];
    }
}

- (void)setNavigationBarTransparent:(BOOL)navigationBarTransparent {
    if (navigationBarTransparent) {
        self.navigationBar.tintColor = UIColor.slideMainColor;
        UINavigationBar.appearance.tintColor = UIColor.slideMainColor;
        [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self.navigationBar setShadowImage:[UIImage new]];
    }
    else {
        self.navigationBar.tintColor = UIColor.whiteColor;
        UINavigationBar.appearance.tintColor = UIColor.whiteColor;
        [self.navigationBar setBackgroundImage:UIColor.slideMainColor.image forBarMetrics:UIBarMetricsDefault];
    }
    
    self.navigationBar.translucent = navigationBarTransparent;
    _navigationBarTransparent = navigationBarTransparent;
}

- (void)addChildViewController:(UIViewController *)childController {
    [self configureViewController:childController];
    [super addChildViewController:childController];
}

- (void)setViewControllers:(NSArray<__kindof UIViewController *> *)viewControllers {
    for (UIViewController *vc in viewControllers) {
        [self configureViewController:vc];
    }
    [super setViewControllers:viewControllers];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self configureViewController:viewController];
    [super pushViewController:viewController animated:YES];
}

- (void)configureViewController:(UIViewController *)viewController {
    viewController.extendedLayoutIncludesOpaqueBars = YES;
    
    // Set title to custom font and size
    UILabel *titleView = [UILabel new];
    titleView.text = viewController.title;
    titleView.textColor = (self.navigationBarTransparent) ? UIColor.slideMainColor : UIColor.whiteColor;
    titleView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:30.0];
    viewController.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    
    // Remove "Back" text after the back button
    viewController.navigationItem.backBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@""
                                         style:UIBarButtonItemStylePlain
                                        target:nil
                                        action:nil];
}

@end
