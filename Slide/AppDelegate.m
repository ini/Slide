//  Copyright (c) 2016 Insi. All rights reserved.

#import "AppDelegate.h"

@import Firebase;


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    UIViewController *rvc;

    if ([defaults objectForKey:@"firstTime"] == nil) {
        rvc = [HowToPlayViewController new];
    }
    else {
        rvc = [SlideRootViewController new];
    }
    self.window.rootViewController = rvc;
    [self.window makeKeyAndVisible];

    [FIRApp configure];
    [GADMobileAds configureWithApplicationID:@"ca-app-pub-8780766193173131~7131332408"];
    
    return YES;
}

@end
