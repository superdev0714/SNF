//
//  InstructionVC.h
//  Sample
//
//  Created by Sahil garg on 31/05/17.
//  Copyright © 2017 DS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
//#import "PayPalMobile.h"
#import <StoreKit/StoreKit.h>

@interface InstructionVC : UIViewController <SKPaymentTransactionObserver, SKProductsRequestDelegate>
{
    NSInteger planLevel;
    NSString *paymentPlan;
    NSString *strStatus;
    NSString *strDate;

    SKProduct *product;
    NSString *productID;
    
    IBOutlet UITextView *txtInstruction;
}

@property (weak, nonatomic) IBOutlet UILabel *lblWelcome;
@property (weak, nonatomic) IBOutlet UILabel *lblPlan;

- (IBAction)actionLink:(id)sender;
- (IBAction)actionChangePlan:(id)sender;


//- (IBAction)action_addKeywords:(id)sender;
- (IBAction)action_logout:(id)sender;

@end
