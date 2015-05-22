//
//  MenuViewController.m
//  Slide
//
//  Created by Ini on 7/22/14.
//  Copyright (c) 2014 Insi. All rights reserved.
//

#import "MenuViewController.h"

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[GCHelper defaultHelper] authenticateLocalUserOnViewController:self setCallbackObject:self];
    [[GCHelper defaultHelper] registerListener:self];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [[GCHelper defaultHelper] reportScore:((int)[defaults integerForKey:@"bestMoveCount3"]) forLeaderboardID:@"Best_Moves_3"];
    [[GCHelper defaultHelper] reportScore:(int)([defaults doubleForKey:@"bestTime3"] * 100) forLeaderboardID:@"Best_Time_3"];
    [[GCHelper defaultHelper] reportScore:((int)[defaults integerForKey:@"bestMoveCount4"]) forLeaderboardID:@"Best_Moves_4"];
    [[GCHelper defaultHelper] reportScore:(int)([defaults doubleForKey:@"bestTime4"] * 100) forLeaderboardID:@"Best_Time_4"];
    [[GCHelper defaultHelper] reportScore:((int)[defaults integerForKey:@"bestMoveCount5"]) forLeaderboardID:@"Best_Moves_5"];
    [[GCHelper defaultHelper] reportScore:(int)([defaults doubleForKey:@"bestTime5"] * 100) forLeaderboardID:@"Best_Time_5"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (IBAction)resetGame:(id)sender {
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    NSDictionary *defaultsDictionary = [[NSUserDefaults standardUserDefaults] persistentDomainForName: appDomain];
    for (NSString *key in [defaultsDictionary allKeys]) {
        NSLog(@"removing user pref for %@", key);
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
    [[GCHelper defaultHelper] resetAchievements];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Reset" message:@"All of your highscores and achievements have been cleared." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (IBAction)play:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"firstTime"];
}


- (IBAction)showLeaderboard:(id)sender {
    [[GCHelper defaultHelper] showLeaderboardOnViewController:self];
}

#pragma mark In App Purchase

- (IBAction)removeAds:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"paidFor"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Already Purchased" message:@"You've already purchased this item." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        _purchaseController = [storyboard instantiateViewControllerWithIdentifier:@"purchaseControl"];
        [self presentViewController:_purchaseController animated:YES completion:NULL];
    }
}

-(void)Purchased {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"paidFor"];
}

@end