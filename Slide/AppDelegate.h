//
//  AppDelegate.h
//  Slide
//
//  Created by Ini on 7/19/14.
//  Copyright (c) 2014 Insi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) GameViewController *myGameViewController;

@end
