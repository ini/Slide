//  Copyright (c) 2016 Insi. All rights reserved.

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>


@interface GCHelper : NSObject<GKGameCenterControllerDelegate, GKChallengeListener>

{
    BOOL gameCenterAvailable;
    BOOL userAuthenticated;
}

@property (nonatomic, readonly) UIViewController *authenticationViewController;
@property (assign, readonly) BOOL gameCenterAvailable;
@property (nonatomic, strong) NSArray* leaderboards;
@property (nonatomic, strong) NSMutableDictionary *achievementsDictionary;

+ (GCHelper *)defaultHelper;
- (void)authenticateLocalUserOnCompletion:(void(^)(void))completion;

- (void)reportScore:(int)score forLeaderboardID:(NSString*)identifier;
- (void)showLeaderboardOnViewController:(UIViewController*)viewController;

- (void)reportAchievementIdentifier: (NSString*) identifier percentComplete: (float) percent;
- (GKAchievement *)getAchievementForIdentifier: (NSString*) identifier;
- (void)resetAchievements;
- (void)registerListener:(id<GKLocalPlayerListener>)listener;

@end
