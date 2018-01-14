//
//  KeywordVC.m
//  Sample
//
//  Created by Sahil garg on 31/05/17.
//  Copyright © 2017 DS. All rights reserved.
//

#import "KeywordVC.h"

@interface KeywordVC ()

@end

@implementation KeywordVC
@synthesize arrayWords,status,list,planLevel,date;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[SKPaymentQueue defaultQueue]
     addTransactionObserver:self];
    tbView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    btn_Add.layer.cornerRadius = 10.0;
    btn_Add.layer.borderWidth = 1.0;
    btn_Add.layer.borderColor = [UIColor blackColor].CGColor;
    [btn_Add setClipsToBounds:YES];
    
    btn_Save.layer.cornerRadius = 10.0;
    btn_Save.layer.borderWidth = 1.0;
    btn_Save.layer.borderColor = [UIColor blackColor].CGColor;
    [btn_Save setClipsToBounds:YES];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)actionBack:(id)sender {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionAdd:(id)sender {
    
    if (txtView.text.length > 0) {
        
        if ([planLevel integerValue] == 1 && arrayWords.count==10) {
        
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Sorry! You have reached the maximum number of keywords that can be added for this plan. But you can upgrade your plan for adding upto 20 keywords." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Upgrade to Keyword Pack of 20 words" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self pay];
            }];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertController addAction:cancel];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
            return;
        }

        if ([planLevel integerValue] == 2 && arrayWords.count==20) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Sorry! You have reached the maximum number of keywords that can be added for this plan." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            }];
            
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
            return;
        }
        
        [txtView resignFirstResponder];
        
        [self saveKeywords];
    }
    
}

- (void)saveKeywords {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    list = [NSString stringWithFormat:@"%@\n%@",list,txtView.text];
    NSString *noteDataString = [NSString stringWithFormat:@"action=%@&keywords=%@&userid=%@&keywordname=%@", @"savekeywords",list,[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"],txtView.text];
    NSLog(@"savekeywords..%@",noteDataString);
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    NSURL *url = [NSURL URLWithString:@"https://snfscan.com/keywords_mobileapi.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPBody = [noteDataString dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"POST";
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
         dispatch_async(dispatch_get_main_queue(), ^{
         
             if (error) {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 NSLog(@"%@",[error localizedDescription]);
                 
                 UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
                 
                 UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                     
                 }];
                 
                 [alertController addAction:cancel];
                 
                 [self presentViewController:alertController animated:YES completion:nil];
                 
             } else {
                 if (data.length ==0) {
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                     UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Unable to connect with server. Please try again." preferredStyle:UIAlertControllerStyleAlert];
                     
                     UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                         
                     }];
                     
                     [alertController addAction:cancel];
                     [self presentViewController:alertController animated:YES completion:nil];
                     
                 } else {
                     [self getkeyword];
                 }
             }
             
         });
        // The server answers with an error because it doesn't receive the params
    }];
    [postDataTask resume];
}

-(void)getkeyword {
    NSString *noteDataString = [NSString stringWithFormat:@"userid=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"]];
    
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
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Custom Keyword Saved" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        txtView.text = @"";
                        [arrayWords removeAllObjects];
                        arrayWords = [[dict valueForKey:@"keywords"] mutableCopy];
                        [tbView reloadData];
                        
                    }];
                    
                    [alertController addAction:cancel];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
            }
            
        });
    }];
    
    [postDataTask resume];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrayWords.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    KeyTbCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"KeyTbCellIdentifier"];
    if (!cell) {
        cell = [[KeyTbCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KeyTbCellIdentifier"];
    }
    
    cell.lblKeyword.text = [NSString stringWithFormat:@"%ld. %@",indexPath.row+1,[[arrayWords valueForKey:@"keywordname"] objectAtIndex:indexPath.row]];
    
    cell.editBtn.tag = indexPath.row;
    [cell.editBtn addTarget:self action:@selector(editRow:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)editRow:(UIButton*)sender {
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Edit Keyword" message: @"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Update Keyword" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
      
        UIAlertController * alertController1 = [UIAlertController alertControllerWithTitle: @"Edit Custom Keyword" message: @"" preferredStyle:UIAlertControllerStyleAlert];
        [alertController1 addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Enter Custom Keyword";
            textField.textColor = [UIColor blackColor];
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            //textField.borderStyle = UITextBorderStyleRoundedRect;
        }];
        
        [alertController1 addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }]];
        
        [alertController1 addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSArray * textfields = alertController1.textFields;
            UITextField * namefield = textfields[0];
            
            if (namefield.text.length == 0) {
                
                return ;
            }
            [self updateKeyword:sender.tag withKeyword:namefield.text];
            
        }]];
        [self presentViewController:alertController1 animated:YES completion:nil];

    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Delete Keyword" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self deleteKeywords:sender.tag];
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void)updateKeyword:(NSInteger)sender withKeyword:(NSString*)string{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *noteDataString = [NSString stringWithFormat: @"https://snfscan.com/mobileapi.php?action=update_keyword&id=%@&keywordname=%@&oldkeywordname=%@",[[arrayWords objectAtIndex:sender] valueForKey:@"id"],string,[[arrayWords objectAtIndex:sender] valueForKey:@"keywordname"]];
    [[[NSURLSession sharedSession]dataTaskWithURL:[NSURL URLWithString:noteDataString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if (error) {
                
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
                    //NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                    [self getkeyword];
                    
                }
            }
            
        });
        
    }] resume];
}

-(void)deleteKeywords:(NSInteger)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *noteDataString = [NSString stringWithFormat: @"https://snfscan.com/mobileapi.php?action=delete_keyword&id=%@&oldkeywordname=%@",[[arrayWords objectAtIndex:sender] valueForKey:@"id"],[[arrayWords objectAtIndex:sender] valueForKey:@"keywordname"]];
    noteDataString = [noteDataString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    noteDataString = [noteDataString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    [[[NSURLSession sharedSession]dataTaskWithURL:[NSURL URLWithString:noteDataString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if (error) {
                
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
                    //NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                    [self getkeyword];
                    
                }
            }
            
        });
        
    }] resume];
}

- (void)pay {
    
    productID = @"com.vghybrid.snfreferral.upgrade";
    [self getProductInfo];
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

-(void)updateStatus {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *noteDataString = [NSString stringWithFormat: @"https://snfscan.com/mobileapi.php?action=save_transaction&userid=%@&fees=%@&level=%@&status=%@&created=%@",   [[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"],@"50",@"2",strStatus,[date stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    
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
                                planLevel = @"2";
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

@end
