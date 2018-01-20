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
    
    IBOutlet UILabel *lbl_Top;
    IBOutlet UITableView *tbView;
    NSMutableArray *arrayKeyword;
    NSMutableArray *arrayCount;
    NSMutableArray *arrayColors;
    IBOutlet UITextView *txtView;
    
    IBOutlet UIView *viewPopUp;
    IBOutlet UIView *viewEntry;
    
    IBOutlet UITextField *txtMesssage;
    
    IBOutlet UISegmentedControl *scType;
    
    IBOutlet UILabel *lblType;
    IBOutlet UIButton *btnContactInfo;
    
    IBOutlet UIButton *btnSend;
    IBOutlet UIScrollView *scroll;
    UIActivityIndicatorView *spinner1;
    NSDictionary *diction;
}

@property (strong, nonatomic) NSArray *arrContacts;
@property (strong, nonatomic) NSArray *contactDetailArray;
@property (strong, nonatomic) NSMutableArray *contactPhoneArray;
@property (strong, nonatomic) NSMutableArray *contactNameArray;

@property (weak, nonatomic) IBOutlet UIButton *btnResult;
@property (weak, nonatomic) IBOutlet UILabel *lblError;
@property (nonatomic,strong) NSDictionary *dict;


-(IBAction)action_Back:(id)sender;
-(IBAction)action_Result:(id)sender;

- (IBAction)onTypeChange:(id)sender;
- (IBAction)selectContactInfo:(id)sender;
- (IBAction)action_send:(id)sender;
- (IBAction)action_close:(id)sender;

@end
