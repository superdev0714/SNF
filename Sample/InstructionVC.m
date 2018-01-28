//
//  InstructionVC.m
//  Sample
//
//  Created by Sahil garg on 31/05/17.
//  Copyright © 2017 DS. All rights reserved.
//

#import "InstructionVC.h"
#import "KeywordVC.h"

@interface InstructionVC ()
//@property (nonatomic, strong, readwrite) PayPalConfiguration *payPalConfiguration;

@end

@implementation InstructionVC


//- (instancetype)initWithCoder:(NSCoder *)aDecoder {
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//        _payPalConfiguration = [[PayPalConfiguration alloc] init];
//        
//        // See PayPalConfiguration.h for details and default values.
//        // Should you wish to change any of the values, you can do so here.
//        // For example, if you wish to accept PayPal but not payment card payments, then add:
//        _payPalConfiguration.acceptCreditCards = NO;
//        // Or if you wish to have the user choose a Shipping Address from those already
//        // associated with the user's PayPal account, then add:
//        _payPalConfiguration.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    // Do any additional setup after loading the view.
    
    
    NSString *strUrl = [NSString stringWithFormat: @"https://snfscan.com/getplan_api.php?user_id=%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"]];
    [[[NSURLSession sharedSession]dataTaskWithURL:[NSURL URLWithString:strUrl] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!error)  {
                if (data.length > 0) {
                    
                    NSLog(@"JSON : %@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
                    
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                    
                    NSString *strName = [dict valueForKey:@"name"];
                    [[NSUserDefaults standardUserDefaults] setValue:strName forKey:@"username"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [self.lblWelcome setText:[NSString stringWithFormat:@"Welcome %@", strName]];
                    
                    NSString *strPlan = [dict valueForKey:@"plan"];
                    NSString *plan = [NSString stringWithFormat:@"You are using %@ Plan", strPlan];
                    [self.lblPlan setText:plan];
                }
            }
            
        });
        
    }] resume];
    
    
    NSString *str1 = @"1. Open a PDF patient referral on mobile device.\n2. Select SHARE/IMPORT function and select SNFscan app.\n3. Select “Scan Doc” in top banner.\n4. Document scan will initiate (30+ seconds to process, 200 page daily limit) \n5. SNFscan results will display. \n6. Select “Share Results” in top banner. \n7. Select “Email” or “SMS text” from contacts, add optional message. \n\nPlease review and agree to service ";
    NSAttributedString *attributedString1 = [[NSAttributedString alloc] initWithString:str1];
    NSMutableAttributedString *strInstruction = [[NSMutableAttributedString alloc] init];
    [strInstruction appendAttributedString:attributedString1];
    
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"Terms & Conditions" attributes:@{NSLinkAttributeName: [NSURL URLWithString:@"https://snfscan.com/login/terms&condition.php"]}];
    [strInstruction appendAttributedString:str2];
    
    NSAttributedString *str3 = [[NSAttributedString alloc] initWithString:@" prior to use. \n\n Level 1 (10 keywords) – FREE \n\n Level 2 (50 Standard keywords) - $100 p/m \n\n Level 3 (50 Standard & 50 Pharmacy keywords) - $189 p/m \n\n Level 4 (100 keywords & 50 Customized) – coming soon"];
    [strInstruction appendAttributedString:str3];
    
    txtInstruction.attributedText = strInstruction;
}

-(void)viewWillAppear:(BOOL)animated {
//    [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentNoNetwork];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    planLevel = 0;
    strDate = @"";
//    [self getKeywords];
    [self getStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)pay {
    
    // Create a PayPalPayment
//    PayPalPayment *payment = [[PayPalPayment alloc] init];
//    
//    // Amount, currency, and description
    if ([paymentPlan isEqualToString:@"A"]) {
        
        productID = @"com.vghybrid.snfreferral.20words";
        [self getProductInfo];
//        payment.shortDescription = @"Buy Keyword Pack of 20 words";
    } else {
        productID = @"com.vghybrid.snfreferral.40words";
        [self getProductInfo];
//        payment.shortDescription = @"Buy Keyword Pack of 40 words";
    }
    
    
    // Use the intent property to indicate that this is a "sale" payment,
    // meaning combined Authorization + Capture.
    // To perform Authorization only, and defer Capture to your server,
    // use PayPalPaymentIntentAuthorize.
    // To place an Order, and defer both Authorization and Capture to
    // your server, use PayPalPaymentIntentOrder.
    // (PayPalPaymentIntentOrder is valid only for PayPal payments, not credit card payments.)
//    payment.intent = PayPalPaymentIntentSale;
    
    // If your app collects Shipping Address information from the customer,
    // or already stores that information on your server, you may provide it here.
    // payment.shippingAddress = address; // a previously-created PayPalShippingAddress object
    
    // Several other optional fields that you can set here are documented in PayPalPayment.h,
    // including paymentDetails, items, invoiceNumber, custom, softDescriptor, etc.
    
    // Check whether payment is processable.
//    if (!payment.processable) {
//        // If, for example, the amount was negative or the shortDescription was empty, then
//        // this payment would not be processable. You would want to handle that here.
//    } else {
//        PayPalPaymentViewController *paymentViewController;
//        paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment configuration:self.payPalConfiguration delegate:self];
//        
//        // Present the PayPalPaymentViewController.
//        [self presentViewController:paymentViewController animated:YES completion:nil];
//    }
}

-(void)getProductInfo
{
    if ([SKPaymentQueue canMakePayments])
    {
        SKProductsRequest *request = [[SKProductsRequest alloc]
                                      initWithProductIdentifiers:
                                      [NSSet setWithObject:productID]];
        request.delegate = self;
        
        [request start];
    }
    else {
        NSLog(@"Please enable In App Purchase in Settings");
    }
}

#pragma mark -
#pragma mark SKProductsRequestDelegate

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    
    NSArray *products = response.products;
    
    if (products.count != 0)
    {
        product = products[0];
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
//        _product = products[0];
//        _buyButton.enabled = YES;
//        _productTitle.text = _product.localizedTitle;
//        _productDescription.text = _product.localizedDescription;
    } else {
//        _productTitle.text = @"Product not found";
    }
    
    products = response.invalidProductIdentifiers;
    
    for (SKProduct *product1 in products)
    {
        NSLog(@"Product not found: %@", product1);
    }
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                
                strStatus = @"1";
                [self updateStatus];
                
                [[SKPaymentQueue defaultQueue]
                 finishTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateFailed:
                // NSLog(@"Transaction Failed");
                
                strStatus = @"0";
                [self updateStatus];
                
                [[SKPaymentQueue defaultQueue]
                 finishTransaction:transaction];
                break;
                
            default:
                break;
        }
    }
}

//#pragma mark - PayPalPaymentDelegate methods
//
//- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController
//                 didCompletePayment:(PayPalPayment *)completedPayment {
//    // Payment was processed successfully; send to server for verification and fulfillment.
//    [self verifyCompletedPayment:completedPayment];
//    
//    // Dismiss the PayPalPaymentViewController.
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
//    // The payment was canceled; dismiss the PayPalPaymentViewController.
//    
//    [self dismissViewControllerAnimated:YES completion:^{
//        strStatus = @"0";
//        [self updateStatus];
//    }];
//    
//}
//
//- (void)verifyCompletedPayment:(PayPalPayment *)completedPayment {
//    // Send the entire confirmation dictionary
//    NSData *confirmation = [NSJSONSerialization dataWithJSONObject:completedPayment.confirmation options:0 error:nil];
//    NSLog(@"%@",confirmation);
//    strStatus = @"1";
//    [self updateStatus];
//    // Send confirmation to your server; your server should verify the proof of payment
//    // and give the user their goods or services. If the server is not reachable, save
//    // the confirmation and try again later.
//}

-(void)updateStatus {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *noteDataString;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *oriDate = [formatter stringFromDate:[NSDate date]];
    oriDate = [oriDate stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    if ([paymentPlan isEqualToString:@"A"]) {
        noteDataString = [NSString stringWithFormat: @"https://snfscan.com/mobileapi.php?action=save_transaction&userid=%@&fees=%@&level=%@&status=%@&created=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"],@"100",@"1",strStatus,oriDate];
    } else {
        noteDataString = [NSString stringWithFormat: @"https://snfscan.com/mobileapi.php?action=save_transaction&userid=%@&fees=%@&level=%@&status=%@&created=%@",   [[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"],@"150",@"2",strStatus,oriDate];
    }
    
    [[[NSURLSession sharedSession]dataTaskWithURL:[NSURL URLWithString:noteDataString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (error) {
                // NSLog(@"%@",[error localizedDescription]);
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alertController addAction:cancel];
                [self presentViewController:alertController animated:YES completion:nil];
            } else {
                if (data.length ==0) {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Unable to connect with server. Please try again." preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    
                    [alertController addAction:cancel];
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                } else {
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                    if ([[dict valueForKey:@"status"] integerValue] == 1) {
                        if ([strStatus isEqualToString:@"1"]) {
                            
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Payment is successful." preferredStyle:UIAlertControllerStyleAlert];
                            
                            UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                if ([paymentPlan isEqualToString:@"A"]) {
                                    planLevel = 1;
                                } else {
                                    planLevel = 2;
                                }
                                
                                [self getKeywords];
                            }];
                            
                            [alertController addAction:cancel];
                            [self presentViewController:alertController animated:YES completion:nil];
                            
                            
                        }
                    } else {
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[dict valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            
                        }];
                        
                        [alertController addAction:cancel];
                        [self presentViewController:alertController animated:YES completion:nil];
                    }
                    
                }
            }
            
        });
        
    }] resume];
}

-(void)getStatus {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *noteDataString = [NSString stringWithFormat: @"https://snfscan.com/mobileapi.php?action=transactions&userid=%@",   [[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"]];
    [[[NSURLSession sharedSession]dataTaskWithURL:[NSURL URLWithString:noteDataString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (error) {
                // NSLog(@"%@",[error localizedDescription]);
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alertController addAction:cancel];
                [self presentViewController:alertController animated:YES completion:nil];
            } else {
                if (data.length ==0) {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Unable to connect with server. Please try again." preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    
                    [alertController addAction:cancel];
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                } else {
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                    if ([[dict valueForKey:@"status"] integerValue] == 1) {
                        NSArray *arr = [dict valueForKey:@"list"];
                        planLevel =  [[[arr firstObject] valueForKey:@"level"] integerValue];
                        strDate = [[arr firstObject] valueForKey:@"created"];
                    } else {
                        
                    }
                    
                }
            }
            
        });
        
    }] resume];
    
}

- (IBAction)action_logout:(id)sender {
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"UserId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
   // NSLog(@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"UserId"]);
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)actionLink:(id)sender {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://snfscan.com/login/terms&condition.php"]];
}

- (IBAction)actionChangePlan:(id)sender {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://www.snfscan.com"]];
}

//- (IBAction)action_addKeywords:(id)sender {
//    
//    if (planLevel == 0){
//        
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Please select keyword search plan." preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction *planC = [UIAlertAction actionWithTitle:@"FREE standard keywords (not custom)" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//        }];
//        [alertController addAction:planC];
//        
//        UIAlertAction *planA = [UIAlertAction actionWithTitle:@"10 custom keywords - $100 p/m" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            paymentPlan = @"A";
//            [self pay];
//        }];
//        
//        [alertController addAction:planA];
//        
//        UIAlertAction* planB = [UIAlertAction actionWithTitle:@"20 custom keywords - $150 p/m" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            paymentPlan = @"B";
//            [self pay];
//        }];
//        
//        [alertController addAction:planB];
//        
//        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            
//        }];
//        
//        [alertController addAction:cancel];
//        
//        [self presentViewController:alertController animated:YES completion:nil];
//        
//    } else {
//        
//        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//        NSDate *oriDate = [formatter dateFromString:strDate];
//        
//        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
//        [dateComponents setMonth:1];
//        NSCalendar *calendar = [NSCalendar currentCalendar];
//        NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:oriDate options:0];
//        NSString *strDay  = [formatter stringFromDate:newDate];
//        
//        if ([strDay isEqualToString:[formatter stringFromDate:[NSDate date]]]) {
//            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Your plan is expired. Select from the below plans to add keywords." preferredStyle:UIAlertControllerStyleAlert];
//            
//            UIAlertAction *planA = [UIAlertAction actionWithTitle:@"Add upto 10 keywords." style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                paymentPlan = @"A";
//                [self pay];
//            }];
//            
//            [alertController addAction:planA];
//            
//            UIAlertAction* planB = [UIAlertAction actionWithTitle:@"Add upto 20 keywords." style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                paymentPlan = @"B";
//                [self pay];
//            }];
//            
//            [alertController addAction:planB];
//            
//            UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                
//            }];
//            
//            [alertController addAction:cancel];
//            
//            [self presentViewController:alertController animated:YES completion:nil];
//            
//        } else {
//            [self getKeywords];
//        }
//
//    }
//}

-(void)getKeywords {

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *noteDataString = [NSString stringWithFormat:@"userid=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"]];
//    noteDataString = @"";
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    NSURL *url = [NSURL URLWithString:@"https://snfscan.com/keywords_mobileapi.php?action=getkeywords"];

    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPBody = [noteDataString dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"POST";
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if (error) {
                // NSLog(@"%@",[error localizedDescription]);
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alertController addAction:cancel];
                
                [self presentViewController:alertController animated:YES completion:nil];
                
            } else {
                if (data.length ==0) {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Unable to connect with server. Please try again." preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    
                    [alertController addAction:cancel];
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                } else {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                    NSMutableArray *arrayWords = [[NSMutableArray alloc]init];
                    NSLog(@"getKeywords..%@",dict);
                    arrayWords = [[dict valueForKey:@"keywords"] mutableCopy];
                   // arrayWords = [[arrayWords valueForKey:@"keywordname"] mutableCopy];
                    
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                    KeywordVC *myController = [storyboard instantiateViewControllerWithIdentifier:@"KeywordVC"];
                    myController.planLevel = [NSString stringWithFormat:@"%ld",(long)planLevel];
                    myController.arrayWords = arrayWords;
                    myController.status = [arrayWords valueForKey:@"keywordname"];
                    myController.date = strDate;
                    myController.list = [dict valueForKey:@"list"];
                    [self.navigationController pushViewController:myController animated:true];
                    
                }
            }
            
        });
    }];
    
    [postDataTask resume];
}

-(void)viewDidDisappear:(BOOL)animated {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end
