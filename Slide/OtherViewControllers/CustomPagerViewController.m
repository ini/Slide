

#import "CustomPagerViewController.h"

@interface CustomPagerViewController ()

@end

@implementation CustomPagerViewController

- (void)viewDidLoad
{
	// Do any additional setup after loading the view, typically from a nib.
    [super viewDidLoad];
    
	[self addChildViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"page1"]];
	[self addChildViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"page2"]];
	[self addChildViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"page3"]];
    [self addChildViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"page4"]];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
