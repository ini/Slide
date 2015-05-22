//
//  PurchaseViewController.h
//  Slide
//
//  Created by Ini on 8/28/14.
//  Copyright (c) 2014 Insi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface PurchaseViewController : UIViewController <SKPaymentTransactionObserver,SKProductsRequestDelegate>
{
    UIAlertView *askToPurchase;
}

-(BOOL)IAPItemPurchased;
- (IBAction)GoBack:(id)sender;
- (IBAction)BuyProduct:(id)sender;
- (IBAction)Restore:(id)sender;

@end
