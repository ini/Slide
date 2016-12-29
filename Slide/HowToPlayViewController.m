//  Copyright © 2016 Insi. All rights reserved.

#import "HowToPlayViewController.h"


@interface PageContentViewController : UIViewController

@property NSUInteger index;
@property NSArray *imageNames;
@property UIPageViewController *pageViewController;
@property UIPageControl *pageControl;

@property UILabel *titleLabel;
@property UIImageView *imageView;
@property SlideButton *letsPlayButton;

@property CGFloat pageControlLastContentOffset;

+ (NSArray *)pageTitles;
+ (NSArray *)imageTitles;

@end


@implementation PageContentViewController

- (id)initWithIndex:(NSUInteger)index pageViewController:(UIPageViewController *)pageViewController {
    self = [super init];
    
    if (self) {
        self.view.backgroundColor = UIColor.whiteColor;
        self.index = index;
        self.pageViewController = pageViewController;
        
        // Get the page control of the UIPageViewController
        for (UIView *view in self.pageViewController.view.subviews) {
            if ([view isKindOfClass:[UIPageControl class]]) {
                self.pageControl = (UIPageControl *)view;
            }
        }
        [self addGestureRecognizers];
        
        self.titleLabel = [UILabel new];
        self.titleLabel.text = PageContentViewController.pageTitles[self.index];
        self.titleLabel.textColor = UIColor.slideBlue;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:24.0];
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.view addSubview:self.titleLabel];

        NSString *imageName = PageContentViewController.imageTitles[self.index];
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        self.imageView.backgroundColor = UIColor.redColor;
        [self.view addSubview:self.imageView];
        
        self.letsPlayButton = [SlideButton new];
        self.letsPlayButton.backgroundColor = UIColor.slideGrey;
        self.letsPlayButton.alpha = 0.0;
        self.letsPlayButton.titleLabel.font =
            [UIFont fontWithName:@"HelveticaNeue-Medium" size:22.0];
        self.letsPlayButton.hidden = (self.index != PageContentViewController.pageTitles.count - 1);
        [self.letsPlayButton setTitle:@"Let's Play" forState:UIControlStateNormal];
        [self.letsPlayButton setTitleColor:UIColor.slideBlue forState:UIControlStateNormal];
        [self.letsPlayButton addTarget:self
                       action:@selector(showMainMenu)
             forControlEvents:UIControlEventTouchUpInside];
        [self.pageViewController.view addSubview:self.letsPlayButton];
        
        [self updateViewConstraints];
    }
    
    return self;
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.imageView.mas_top);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(280.0);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).with.offset(20.0);
        make.width.height.equalTo(self.view.mas_width);
    }];
    
    [self.letsPlayButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.pageViewController.view);
        make.height.mas_equalTo(60.0);
    }];
}

- (void)addGestureRecognizers {
    if (self.index == 0 || self.index == 2) {
        UISwipeGestureRecognizer *left = [UISwipeGestureRecognizer new];
        left.direction = UISwipeGestureRecognizerDirectionLeft;
        [left addTarget:self action:@selector(goToNextViewController)];
        [self.view addGestureRecognizer:left];
    }
    else if (self.index == 1) {
        UISwipeGestureRecognizer *up = [UISwipeGestureRecognizer new];
        up.direction = UISwipeGestureRecognizerDirectionUp;
        [up addTarget:self action:@selector(goToNextViewController)];
        [self.view addGestureRecognizer:up];
    }
}

- (void)goToNextViewController {
    if (self.index + 1 < PageContentViewController.pageTitles.count) {
        PageContentViewController *nextViewController =
        [[PageContentViewController alloc] initWithIndex:(self.index + 1)
                                      pageViewController:self.pageViewController];
        [self.pageViewController setViewControllers:@[nextViewController]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:YES
                                         completion:nil];
        [self.pageControl setCurrentPage:self.index + 1];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.letsPlayButton.hidden) {
        // Fade out the page control
        [UIView animateWithDuration:0.5 animations:^{
            self.pageControl.alpha = 0.0;
        } completion:^(BOOL finished) {
            // Animate in the "Let's Play" button on the last screen
            [UIView animateWithDuration:1.0 animations:^{ self.letsPlayButton.alpha = 1.0; }];
        }];
        
        // Disable scrolling once the last screen is reached
        for (UIView *view in self.pageViewController.view.subviews) {
            if ([view isKindOfClass:UIScrollView.class]) {
                UIScrollView *scrollView = (UIScrollView *)view;
                scrollView.scrollEnabled = NO;
            }
        }
    }
}

- (void)showMainMenu {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"firstTime"];
    
    MainMenuViewController *menuScreen = [MainMenuViewController new];
    [menuScreen setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:menuScreen animated:YES completion:nil];
}

+ (NSArray *)pageTitles {
    return @[@"Slide tiles into the empty space.",
             @"Slide more than one tile at a time to speed things up.",
             @"Put all of the tiles back in order, and you win!", @"Are you ready?"];
}

+ (NSArray *)imageTitles {
    return @[@"howToPage1.png", @"howToPage2.png", @"howToPage3.png", @"howToPage4.png"];
}

@end


@interface HowToPlayViewController ()

@property UIPageViewController *pageController;
@property NSArray *pageTitles;
@property NSArray *imageTitles;

@end


@implementation HowToPlayViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageController.dataSource = self;
    self.pageController.view.frame = self.view.bounds;
    self.pageController.view.backgroundColor = UIColor.whiteColor;
    
    // Customize the page indicator colors
    for (UIView *view in self.pageController.view.subviews) {
        if ([view isKindOfClass:[UIPageControl class]]) {
            UIPageControl *pc = (UIPageControl *)view;
            pc.pageIndicatorTintColor = UIColor.slideGrey;
            pc.currentPageIndicatorTintColor = UIColor.slideDarkGrey;
        }
    }
    
    PageContentViewController *initialViewController = [self viewControllerAtIndex:0];
    [self.pageController setViewControllers:@[initialViewController]
                                  direction:UIPageViewControllerNavigationDirectionForward animated:NO
                                 completion:nil];
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    [self.pageController didMoveToParentViewController:self];
}

- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index {
    return [[PageContentViewController alloc] initWithIndex:index
                                         pageViewController:self.pageController];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [(PageContentViewController *)viewController index];
    if (index == 0) return nil;
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [(PageContentViewController *)viewController index];
    index++;
    if (index == PageContentViewController.pageTitles.count) return nil;
    
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return PageContentViewController.pageTitles.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

@end
