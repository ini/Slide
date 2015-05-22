//
//  MenuViewController.h
//  Slide
//
//  Created by Ini on 7/22/14.
//  Copyright (c) 2014 Insi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "GCHelper.h"
#import "PurchaseViewController.h"


@interface MenuViewController : UIViewController<GKLocalPlayerListener>

- (IBAction)removeAds:(id)sender;

@property (strong, nonatomic) PurchaseViewController *purchaseController;

-(void)Purchased;

@end
