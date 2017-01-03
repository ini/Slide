//  Copyright (c) 2016 Insi. All rights reserved.

#import "GCHelper.h"


@interface GCHelper ()

- (void)loadLeaderBoardInfo;

@end


@implementation GCHelper

@synthesize gameCenterAvailable;

#pragma mark Initialization

static GCHelper *_sharedHelper = nil;

+ (GCHelper*)defaultHelper {
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        _sharedHelper = [[GCHelper alloc] init];
    });
    return _sharedHelper;
}

- (id)init {
    if ((self = [super init])) {
        gameCenterAvailable = [self isGameCenterAvailable];
        
        if (gameCenterAvailable) {
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc addObserver:self selector:@selector(authenticationChanged) name:GKPlayerAuthenticationDidChangeNotificationName object:nil];
        }
    }
    return self;
}

- (BOOL)isGameCenterAvailable {
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer
                                           options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}

#pragma mark Authentication

- (void)authenticationChanged {
    if ([GKLocalPlayer localPlayer].isAuthenticated && !userAuthenticated) {
        //NSLog(@"Authentication changed: player authenticated.");
        userAuthenticated = TRUE;
        
        [self loadLeaderBoardInfo];
        [self loadAchievements];
        
    }
    else if (![GKLocalPlayer localPlayer].isAuthenticated && userAuthenticated) {
        //NSLog(@"Authentication changed: player not authenticated.");
        userAuthenticated = FALSE;
    }
}

- (void)authenticateLocalUserOnCompletion:(void(^)(void))completion {
    if (!gameCenterAvailable) return;
    __weak GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];

    // NSLog(@"Authenticating local user...");
    if (localPlayer.authenticated == NO) {
        localPlayer.authenticateHandler = ^(UIViewController *authViewController, NSError *error) {
            if (authViewController != nil) {
                UIViewController *currentVC = [GCHelper currentViewController];
                [currentVC presentViewController:authViewController animated:YES completion:nil];
            }
            else {
                completion();
                if (error != nil) {
                    return;
                }
            }
        };
    }
    else {
        // NSLog(@"Already authenticated!");
    }
}

#pragma mark Leaderboards

- (void)loadLeaderBoardInfo {
    [GKLeaderboard loadLeaderboardsWithCompletionHandler:^(NSArray *leaderboards, NSError *error) {
        self.leaderboards = leaderboards;
    }];
}


- (void)showLeaderboardOnViewController:(UIViewController *)viewController {
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    if (gameCenterController != nil) {
        gameCenterController.gameCenterDelegate = self;
        gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
        [viewController presentViewController: gameCenterController animated: YES completion:nil];
    }
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController {
    [gameCenterViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (void)reportScore:(int)score forLeaderboardID:(NSString *)identifier {
    GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier: identifier];
    scoreReporter.value = score;
    scoreReporter.context = 0;
    
    [GKScore reportScores:@[scoreReporter] withCompletionHandler:^(NSError *error) {
        if (error == nil) {
            //NSLog(@"Score reported successfully!");
        }
        else {
            //NSLog(@"Unable to report score!");
        }
    }];
}

#pragma mark Achievements

- (void)reportAchievementIdentifier:(NSString *) identifier percentComplete:(float)percent {
    GKAchievement *achievement = [self getAchievementForIdentifier:identifier];
    if (achievement && achievement.percentComplete != 100.0) {
        achievement.percentComplete = percent;
        achievement.showsCompletionBanner = YES;
        
        [GKAchievement reportAchievements:@[achievement] withCompletionHandler:^(NSError *error) {
            if (error != nil) {
                //NSLog(@"Error while reporting achievement: %@", error.description);
            }
        }];
    }
}

- (void)loadAchievements {
    self.achievementsDictionary = [[NSMutableDictionary alloc] init];
    [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error) {
        if (error != nil) {
            // Handle the error.
            //NSLog(@"Error while loading achievements: %@", error.description);
        }
        else if (achievements != nil) {
            for (GKAchievement *achievement in achievements)
                self.achievementsDictionary[achievement.identifier] = achievement;
        }
    }];
}

- (GKAchievement *)getAchievementForIdentifier: (NSString *) identifier {
    GKAchievement *achievement = [self.achievementsDictionary objectForKey:identifier];
    if (achievement == nil) {
        achievement = [[GKAchievement alloc] initWithIdentifier:identifier];
        self.achievementsDictionary[achievement.identifier] = achievement;
    }
    return achievement;
}

- (void)resetAchievements {
    self.achievementsDictionary = [[NSMutableDictionary alloc] init];
    [GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error)
     {
         if (error != nil) {
             // handle the error.
             //NSLog(@"Error while reseting achievements: %@", error.description);
             
         }
     }];
}


#pragma mark Challenges

- (void)registerListener:(id<GKLocalPlayerListener>)listener {
    [[GKLocalPlayer localPlayer] registerListener:listener];
}

#pragma mark Helper Methods 

+ (UIViewController *)findCurrentViewController:(UIViewController *)vc {
    
    if (vc.presentedViewController) {
        // Return the current view controller for the presented view controller
        return [GCHelper findCurrentViewController:vc.presentedViewController];
        
    }
    else if ([vc isKindOfClass:UISplitViewController.class]) {
        // Return right hand side
        UISplitViewController *svc = (UISplitViewController*) vc;
        if (svc.viewControllers.count > 0) {
            return [GCHelper findCurrentViewController:svc.viewControllers.lastObject];
        }
        else {
            return vc;
        }
    }
    else if ([vc isKindOfClass:UINavigationController.class]) {
        // Return top view
        UINavigationController *svc = (UINavigationController *)vc;
        if (svc.viewControllers.count > 0) {
            return [GCHelper findCurrentViewController:svc.topViewController];
        }
        else {
            return vc;
        }
    }
    else if ([vc isKindOfClass:UITabBarController.class]) {
        // Return visible view
        UITabBarController* svc = (UITabBarController*) vc;
        if (svc.viewControllers.count > 0) {
            return [GCHelper findCurrentViewController:svc.selectedViewController];
        }
        else {
            return vc;
        }
    }
    else {
        // Unknown view controller type, return last child view controller
        return vc;
    }
    
}

+ (UIViewController *)currentViewController {
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [GCHelper findCurrentViewController:viewController];
}

@end
