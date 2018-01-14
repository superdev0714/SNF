//
//  ViewController.h
//  Sample
//
//  Created by Sahil garg on 15/05/17.
//  Copyright © 2017 DS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface ViewController : UIViewController <UITextFieldDelegate> {
    
    IBOutlet UITextField *txtEmail;
    IBOutlet UITextField *txtPassword;
    
    IBOutlet UIButton *btn_Login;
    IBOutlet UIButton *btn_SignUp;
    
    BOOL signup;
    IBOutlet UIButton *btnTick;
}

- (IBAction)actionSignup:(id)sender;
- (IBAction)actionLogin:(id)sender;
- (IBAction)actionTerms:(id)sender;
- (IBAction)actionTick:(id)sender;
- (IBAction)actionLink:(id)sender;
- (IBAction)actionForgetPassword:(id)sender;

@end

