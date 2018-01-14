//
//  KeywordVC.h
//  Sample
//
//  Created by Sahil garg on 31/05/17.
//  Copyright © 2017 DS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "KeyTbCell.h"
#import <StoreKit/StoreKit.h>

@interface KeywordVC : UIViewController <UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate,SKPaymentTransactionObserver, SKProductsRequestDelegate>
{
    IBOutlet UITableView *tbView;
    IBOutlet UITextField *txtView;
    IBOutlet UIButton *btn_Add;
    IBOutlet UIButton *btn_back;
    IBOutlet UIButton *btn_Save;
    
    NSString *strStatus;
    
    SKProduct *product;
    NSString *productID;
}

@property (nonatomic,strong)NSMutableArray *arrayWords;
@property (nonatomic,strong)NSString *status;
@property (nonatomic,strong)NSString *list;
@property (nonatomic,strong)NSString *planLevel;
@property (nonatomic,strong)NSString *date;

- (IBAction)actionAdd:(id)sender;
- (IBAction)actionBack:(id)sender;

@end
