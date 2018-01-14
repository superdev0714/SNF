//
//  ViewController.m
//  Sample
//
//  Created by Sahil garg on 15/05/17.
//  Copyright © 2017 DS. All rights reserved.
//

#import "ViewController.h"
#import "ViewWebVC.h"
#import <CommonCrypto/CommonDigest.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    btn_Login.layer.cornerRadius = 10.0;
    btn_Login.layer.borderWidth = 1.0;
    btn_Login.layer.borderColor = [UIColor blackColor].CGColor;
    [btn_Login setClipsToBounds:YES];
    
    btn_SignUp.layer.cornerRadius = 10.0;
    btn_SignUp.layer.borderWidth = 1.0;
    btn_SignUp.layer.borderColor = [UIColor blackColor].CGColor;
    [btn_SignUp setClipsToBounds:YES];
    
    signup = false;
    [btn_Login setEnabled:NO];
    
    //NSLog(@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"UserId"]);
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"UserId"] length] > 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UIViewController *myController = [storyboard instantiateViewControllerWithIdentifier:@"InstructionVC"];
        [self.navigationController pushViewController:myController animated:true];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionTick:(id)sender {
    signup = !signup;
    if (signup) {
        [btnTick setBackgroundImage:[UIImage imageNamed:@"check-box-outline"] forState:UIControlStateNormal];
        [btn_Login setEnabled:YES];
    } else {
        [btnTick setBackgroundImage:[UIImage imageNamed:@"check-box-outline-blank"] forState:UIControlStateNormal];
        [btn_Login setEnabled:NO];
    }
}

-(IBAction)actionTerms:(id)sender
{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://snfscan.com/terms&condition.php"]];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)isnumericAlphaForEmail:(NSString*)string
{
    
    BOOL stricterFilter = NO;
    
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:string];
    
//    NSCharacterSet *NUMBERS = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz@._-/0123456789+"];
//    
//    for(int i=0; i<[string length]; i++)
//    {
//        unichar letter=[string characterAtIndex:i];
//        NSString* letterstring=[[NSString alloc] initWithCharacters:&letter length:1];
//        if([letterstring isEqualToString:@" "])
//        {
//            return NO;
//        }
//        
//        if (![NUMBERS characterIsMember:letter])
//        {
//            return NO;
//        }
//    }
//    return YES;
}

- (IBAction)actionSignup:(id)sender {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://snfscan.com/login/sign_up.php"]];
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
//                                @"Main" bundle:[NSBundle mainBundle]];
//    UIViewController *myController = [storyboard instantiateViewControllerWithIdentifier:@"RegisterVC"];
//    [self.navigationController pushViewController:myController animated:true];
}

- (IBAction)actionLogin:(id)sender
{
    if (txtEmail.text.length ==0 ) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Please enter valid email address." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    if (![self isnumericAlphaForEmail:txtEmail.text]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Please enter valid email address." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    if (txtPassword.text.length == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Please enter valid password." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    [self loginUser];
    
    
}

- (NSString *)MD5String:(NSString*) string {
    const char *cStr = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];  
}


-(void) loginUser {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *md5Pass = [self MD5String:txtPassword.text];
    
    NSString *noteDataString = [NSString stringWithFormat: @"https://snfscan.com/mobileapi.php?action=%@&email=%@&password=%@", @"login" , txtEmail.text ,md5Pass];
    
    NSLog(@"%@", noteDataString);
    
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
                    
                    NSLog(@"JSON : %@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
                    
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                    if ([[dict valueForKey:@"status"] integerValue] == 1) {
                        
                        NSString *strUserId = [NSString stringWithFormat:@"%ld",[[dict valueForKey:@"userid"] integerValue]];
                        
                        [[NSUserDefaults standardUserDefaults] setValue:strUserId forKey:@"UserId"];
                        
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                        UIViewController *myController = [storyboard instantiateViewControllerWithIdentifier:@"InstructionVC"];
                        [self.navigationController pushViewController:myController animated:true];
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

- (IBAction)actionLink:(id)sender {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://snfscan.com/login/sign_up.php"]];
}

- (IBAction)actionForgetPassword:(id)sender {
    
    
    UIAlertController * alertController1 = [UIAlertController alertControllerWithTitle: @"Enter your email address" message: @"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController1 addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Enter your email";
        textField.textColor = [UIColor blackColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        //textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    
    
    [alertController1 addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController1.textFields;
        UITextField * namefield = textfields[0];
        
        if (namefield.text.length == 0) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Please enter valid email address." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [alertController1 dismissViewControllerAnimated:YES completion:nil];
                [self actionForgetPassword:nil];
            }];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];

            return ;
        }
        
        if (![self isnumericAlphaForEmail:namefield.text]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Please enter valid email address." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [alertController1 dismissViewControllerAnimated:YES completion:nil];
                [self actionForgetPassword:nil];
            }];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];

            return;
        }
        [alertController1 dismissViewControllerAnimated:YES completion:nil];
        [self forgetPassword:namefield.text];
        
    }]];
    
    [alertController1 addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    
    [self presentViewController:alertController1 animated:YES completion:nil];
    
}

-(void)forgetPassword:(NSString*)forget {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *noteDataString = [NSString stringWithFormat: @"https://snfscan.com/login/forgot.php?usernamemail=%@", forget];
    
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
                    
                    //NSLog(@"JSON : %@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
                    
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//                    if ([[dict valueForKey:@"status"] integerValue] == 1) {
//                        
//                        NSString *strUserId = [NSString stringWithFormat:@"%ld",[[dict valueForKey:@"userid"] integerValue]];
//                        
//                        [[NSUserDefaults standardUserDefaults] setValue:strUserId forKey:@"UserId"];
//                        
//                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//                        UIViewController *myController = [storyboard instantiateViewControllerWithIdentifier:@"InstructionVC"];
//                        [self.navigationController pushViewController:myController animated:true];
//                    } else {
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[dict valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            
                        }];
                        
                        [alertController addAction:cancel];
                        [self presentViewController:alertController animated:YES completion:nil];
//                    }
                    
                }
            }
            
        });
        
    }] resume];
}

@end
