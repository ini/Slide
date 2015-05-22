
//
//  GCHelper.h
//  Slide
//
//  Created by Ini on 7/22/14.
//  Copyright (c) 2014 Insi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface GCHelper : NSObject<GKGameCenterControllerDelegate, GKChallengeListener>

{
    BOOL gameCenterAvailable;
    BOOL userAuthenticated;
}

@property (assign, readonly) BOOL gameCenterAvailable;
@property (nonatomic, strong) NSArray* leaderboards;
@property (nonatomic, strong) NSMutableDictionary *achievementsDictionary;

+ (GCHelper*)defaultHelper;
- (void)authenticateLocalUserOnViewController:(UIViewController*)viewController setCallbackObject:(id)obj;

- (void)reportScore:(int)score forLeaderboardID:(NSString*)identifier;
- (void)showLeaderboardOnViewController:(UIViewController*)viewController;

- (void)reportAchievementIdentifier: (NSString*) identifier percentComplete: (float) percent;
- (GKAchievement*)getAchievementForIdentifier: (NSString*) identifier;
- (void)resetAchievements;
- (void)registerListener:(id<GKLocalPlayerListener>)listener;

@end
