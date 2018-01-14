//
//  ShowDataVC.h
//  Sample
//
//  Created by Sahil garg on 16/05/17.
//  Copyright © 2017 DS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ContactsUI/ContactsUI.h>
#import "MBProgressHUD.h"

@interface ShowDataVC : UIViewController <UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate>
{
    //UITextView *txtView;
    IBOutlet UILabel *lbl_Top;
    IBOutlet UITableView *tbView;
    NSMutableArray *arrayKeyword;
    NSMutableArray *arrayCount;
    NSMutableArray *arrayColors;
    IBOutlet UITextView *txtView;
    
    IBOutlet UIView *viewPopUp;
    IBOutlet UIView *viewEntry;
    
    IBOutlet UIButton *btnSelectEmail;
    IBOutlet UITextField *txtMesssage;
    IBOutlet UIButton *btnPhoneNumber;
    
    IBOutlet UIButton *btnSendEmail;
    IBOutlet UIButton *btnSendSMS;
    IBOutlet UIScrollView *scroll;
    UIActivityIndicatorView *spinner1;
    NSDictionary *diction;
}

@property (strong, nonatomic) NSArray *arrContacts;
@property (strong, nonatomic) NSArray *contactDetailArray;
@property (strong, nonatomic) NSMutableArray *contactPhoneArray;
@property (strong, nonatomic) NSMutableArray *contactNameArray;

@property (weak, nonatomic) IBOutlet UIButton *btnEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblError;
@property (nonatomic,strong) NSDictionary *dict;

-(IBAction)action_Email:(id)sender;
-(IBAction)action_SendEmail:(id)sender;
-(IBAction)action_SendSMS:(id)sender;
-(IBAction)action_Back:(id)sender;

- (IBAction)action_SelectEmail:(id)sender;
- (IBAction)action_PhoneNubmer:(id)sender;
- (IBAction)action_close:(id)sender;

@end
