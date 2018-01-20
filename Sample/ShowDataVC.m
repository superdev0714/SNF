//
//  ShowDataVC.m
//  Sample
//
//  Created by Sahil garg on 16/05/17.
//  Copyright © 2017 DS. All rights reserved.
//

#import "ShowDataVC.h"
#import "ShowDataCell.h"
#import "AppDelegate.h"
#import "ActionSheetStringPicker.h"

@interface ShowDataVC ()
{
    NSString *strEmail;
    NSString *strPhone;
    NSString *strName;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightTxt;

@end

@implementation ShowDataVC
@synthesize dict;
@synthesize arrContacts;
@synthesize contactDetailArray;
@synthesize contactPhoneArray;
@synthesize contactNameArray;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    strEmail = @"";
    strPhone = @"";
    strName = @"";
    
    arrContacts = [[NSArray alloc] init];
    contactDetailArray  = [[NSArray alloc]init];
    contactPhoneArray = [[NSMutableArray alloc] init];
    contactNameArray = [[NSMutableArray alloc] init];
    
    btnContactInfo.layer.borderWidth = 0.5f;
    btnContactInfo.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btnContactInfo.layer.cornerRadius = 5;
    
    [self getEmailContacts];
    
    CNContactStore *cnContactStore = [[CNContactStore alloc] init];
    
    [cnContactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
        if (granted == YES) {
            
            NSArray *keys = @[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey];
            NSString *containerId = cnContactStore.defaultContainerIdentifier;
            NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
        
            NSError *error;
            contactDetailArray = [cnContactStore unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
            
            if (error) {
                NSLog(@"error fetching contacts %@", error);
                contactDetailArray = [[NSArray alloc] init];
            } else {
                for (CNContact *cnContact in contactDetailArray) {
                    
                    if (cnContact.phoneNumbers.count > 2) {
                        for (CNLabeledValue *label in cnContact.phoneNumbers) {
                            NSString *phoneNumber = [label.value stringValue];
                            if ([label.label isEqualToString:@"_$!<Mobile>!$_"]) {
                                if ([phoneNumber length] > 0) {
                                    [contactPhoneArray addObject:phoneNumber];
                                    [contactNameArray addObject:[NSString stringWithFormat:@"%@ %@", cnContact.givenName, cnContact.familyName]];
                                }
                            }
                            
                        }
                    } else if (cnContact.phoneNumbers.count > 0) {
                        NSString *phoneNumber = [cnContact.phoneNumbers[0].value stringValue];
                        if ([phoneNumber length] > 0) {
                            [contactPhoneArray addObject:phoneNumber];
                            [contactNameArray addObject:[NSString stringWithFormat:@"%@ %@", cnContact.givenName, cnContact.familyName]];
                        }
                    }
                    
                }
                [self orderbyAlphabets];
            }
        }
    }];
    
    viewPopUp.hidden = YES;
    
    viewEntry.layer.cornerRadius = 10.0;
    viewEntry.layer.borderWidth = 1.0;
    viewEntry.layer.borderColor = [UIColor whiteColor].CGColor;
    [viewEntry setClipsToBounds:YES];
    
    btnSend.layer.cornerRadius = 10.0;
    btnSend.layer.borderWidth = 1.0;
    btnSend.layer.borderColor = [UIColor blackColor].CGColor;
    [btnSend setClipsToBounds:YES];
    
    arrayCount = [[NSMutableArray alloc]init];
    arrayKeyword = [[NSMutableArray alloc]init];
    arrayColors =[[NSMutableArray alloc]init];
    
    diction = @{@"lightgray":[UIColor colorWithRed:211/255.0f green:211/255.0f blue:211/255.0f alpha:1.0],@"lightpink":[UIColor colorWithRed:255/255.0f green:182/255.0f blue:193/255.0f alpha:1.0],@"Yellow":[UIColor colorWithRed:255/255.0f green:255/255.0f blue:0/255.0f alpha:1.0],@"cyan":[UIColor colorWithRed:224/255.0f green:255/255.0f blue:255/255.0f alpha:1.0],@"aqua":[UIColor colorWithRed:0/255.0f green:255/255.0f blue:255/255.0f alpha:1.0],@"lightgreen":[UIColor colorWithRed:144/255.0f green:238/255.0f blue:144/255.0f alpha:1.0],@"lightblue":[UIColor colorWithRed:173/255.0f green:216/255.0f blue:230/255.0f alpha:1.0],@"wheat":[UIColor colorWithRed:245/255.0f green:222/255.0f blue:179/255.0f alpha:1.0]};
    
    [arrayKeyword addObject:@"Keyword"];
    [arrayCount addObject:@"Count"];
    
    if ([[dict valueForKey:@"status"] integerValue] == 0) {
        
       _lblError.text = [dict valueForKey:@"message"];
        scroll.hidden = YES;
        lbl_Top.hidden = YES;
        _btnResult.hidden = YES;
        return;
    }
    
    for (id string in [dict valueForKey:@"Count"]) {
        [arrayCount addObject:[NSString stringWithFormat:@"%d", (int)[string integerValue]]];
    }
    
    for (id string in [dict valueForKey:@"Keyword"]) {
        [arrayKeyword addObject:[[string componentsSeparatedByString:@"&&"] lastObject]];
        [arrayColors addObject:[[[string componentsSeparatedByString:@"&&"] firstObject] stringByReplacingOccurrencesOfString:@" " withString:@""]];
    }
    
    lbl_Top.text = [NSString stringWithFormat:@"TOTAL MATCHES FOUND = %ld", [[dict valueForKey:@"totalmatches"] integerValue]];
    
    NSString *str1 = [[dict valueForKey:@"content"] stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
   
    NSData *str1Data = [str1 dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    NSString  *str2 = [[NSString alloc] initWithData:str1Data encoding:NSUTF8StringEncoding];
        
    [txtView setEditable:NO];
    
    tbView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [tbView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    tbView.layer.borderWidth= 1.0;
    tbView.layer.borderColor = [UIColor blackColor].CGColor;
    [tbView setClipsToBounds:YES];
    
    _heightConst.constant = arrayCount.count * 30;
   
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str2];
    for (int j=1; j<arrayKeyword.count ; j++) {
        NSArray *results = [self rangesOfString:[arrayKeyword objectAtIndex:j] inString:str2];
        for (int i=0; i<results.count; i++) {
            [string addAttribute:NSBackgroundColorAttributeName value:[diction valueForKey:[arrayColors objectAtIndex:j-1]] range:[[results objectAtIndex:i] rangeValue]];
        }
    }
    
    txtView.attributedText = string;
    [txtView sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width,MAXFLOAT)];
    _heightTxt.constant = txtView.frame.size.height;
    
    scroll.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width,txtView.frame.origin.y+txtView.frame.size.height);
}

-(void)getEmailContacts {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *strUrl = [NSString stringWithFormat:@"https://snfscan.com/getcontacts_api.php?user_id=%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"]];
    
    [[[NSURLSession sharedSession]dataTaskWithURL:[NSURL URLWithString:strUrl] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
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
                    
                    arrContacts = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                    NSLog(@"%@", arrContacts);
                }
            }
            
        });
        
    }] resume];

}

- (NSArray *)rangesOfString:(NSString *)searchString inString:(NSString *)str {
    NSMutableArray *results = [NSMutableArray array];
    NSRange searchRange = NSMakeRange(0, [str length]);
    NSRange range;
    while ((range = [str rangeOfString:searchString options:NSCaseInsensitiveSearch range:searchRange]).location != NSNotFound) {
        [results addObject:[NSValue valueWithRange:range]];
        searchRange = NSMakeRange(NSMaxRange(range), [str length] - NSMaxRange(range));
    }
    return results;
}

-(void)orderbyAlphabets {

    for (int i = 0; i < contactNameArray.count - 1; i++) {
        for (int j = i+1; j < contactNameArray.count; j++) {
            NSString *firstString = contactNameArray[i];
            NSString *secondString = contactNameArray[j];
            NSComparisonResult result = [firstString compare:secondString];
        
            if (result == NSOrderedDescending) {
                [contactNameArray exchangeObjectAtIndex:i withObjectAtIndex:j];
                [contactPhoneArray exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    
}

#pragma mark - tableview datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrayCount.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ShowDataCell";
    ShowDataCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.lblCount.text = [arrayCount objectAtIndex:indexPath.row];
    cell.lblKeyword.text = [arrayKeyword objectAtIndex:indexPath.row];
    if (indexPath.row>0) {
       cell.lblKeyword.backgroundColor = [diction valueForKey:[arrayColors objectAtIndex:indexPath.row-1]];
    }
    
    return cell;
}

#pragma mark - button events

-(IBAction)action_Back:(id)sender {
    [[[UIApplication sharedApplication] delegate].window.rootViewController dismissViewControllerAnimated:true completion:nil];
}

-(IBAction)action_Result:(id)sender {
    
    [btnContactInfo setTitle:@"Select from Contacts" forState:UIControlStateNormal];
    [btnContactInfo setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [scType setSelectedSegmentIndex:0];
    lblType.text = @"Email";
    strEmail = @"";
    strPhone = @"";
    strName = @"";
    txtMesssage.text = @"";
    viewPopUp.hidden = NO;
    
}

- (IBAction)onTypeChange:(id)sender {
    switch (scType.selectedSegmentIndex) {
        case 0:
            lblType.text = @"Email";
            break;
        case 1:
            lblType.text = @"Phone";
            break;
        default:
            break;
    }
    [btnContactInfo setTitle:@"Select from Contacts" forState:UIControlStateNormal];
    [btnContactInfo setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
}

- (IBAction)selectContactInfo:(id)sender {
    switch (scType.selectedSegmentIndex) {
        case 0:
            [self selectEmail];
            break;
        case 1:
            [self selectPhoneNubmer];
            break;
        default:
            break;
    }
}

- (IBAction)action_send:(id)sender {
    switch (scType.selectedSegmentIndex) {
        case 0:
            [self sendEmail];
            break;
        case 1:
            [self sendSMS];
            break;
        default:
            break;
    }
}

- (IBAction)action_close:(id)sender {
    [viewPopUp setHidden:YES];
}

- (void)selectEmail {
    
    NSMutableArray *arrEmails = [[NSMutableArray alloc] init];
    NSMutableArray *arrPhones = [[NSMutableArray alloc] init];
    NSMutableArray *arrNames = [[NSMutableArray alloc] init];
    
    if (arrContacts.count > 0) {
        for (NSDictionary *dic in arrContacts) {
            [arrEmails addObject:[dic valueForKey:@"email"]];
            [arrPhones addObject:[dic valueForKey:@"phone"]];
            [arrNames addObject:[dic valueForKey:@"name"]];
        }
        
        [ActionSheetStringPicker showPickerWithTitle:@"Emails" rows:arrNames initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            [btnContactInfo setTitle:arrEmails[selectedIndex] forState:UIControlStateNormal];
            [btnContactInfo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            strEmail = arrEmails[selectedIndex];
            strName = arrNames[selectedIndex];
            strPhone = @"";
            
        } cancelBlock:nil origin:btnContactInfo];
        
    }
    
}

- (void)selectPhoneNubmer {
    
    [ActionSheetStringPicker showPickerWithTitle:@"Contacts" rows:contactNameArray initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        [btnContactInfo setTitle:contactPhoneArray[selectedIndex] forState:UIControlStateNormal];
        [btnContactInfo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        for (CNContact *cnContact in contactDetailArray) {
            for (CNLabeledValue *label in cnContact.phoneNumbers) {
                NSString *phoneNumber = [label.value stringValue];
                if ([phoneNumber isEqual:contactPhoneArray[selectedIndex]]) {
                    strEmail = @"";
                    strPhone = phoneNumber;
                    strName = [NSString stringWithFormat:@"%@ %@", cnContact.givenName, cnContact.familyName];
                }
            }
        }
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:btnContactInfo];
    
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
-(void)sendEmail {
    
    if (strEmail.length ==0 ) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Please select valid email address." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    if (![self isnumericAlphaForEmail:strEmail]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Please enter valid email address." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    [self hitEmailWebservice:NO];
}


-(void) sendSMS {
    
    if (strPhone.length ==0 ) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Please select valid Phone number." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    [self.view endEditing:YES];
    
    NSString *strStart = @"<span style=\"background-color:yellow\">";
    NSString *strEnd = @"</span>";
    
    NSMutableString *strContent = [[dict valueForKey:@"content"] mutableCopy];
    
    for (int i=1; i<arrayKeyword.count-1; i++) {
        
        NSArray *arr = [strContent componentsSeparatedByString:[arrayKeyword objectAtIndex:i]];
        
        NSMutableString *strKey = [[NSMutableString alloc]init];
        
        for (int j=0; j<arr.count-1; j++) {
            [strKey appendString:[arr objectAtIndex:j]];
            strStart = [NSString stringWithFormat:@"<span style=\"background-color:%@\">", [arrayColors objectAtIndex:i-1]];
            [strKey appendString:strStart];
            [strKey appendString:[arrayKeyword objectAtIndex:i]];
            [strKey appendString:strEnd];
        }
        
        [strKey appendString:[arr lastObject]];
        
        strContent = strKey;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *urlString = @"https://snfscan.com/library/m_phone.php";
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    request.HTTPMethod = @"POST";
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    NSMutableString *table = [NSMutableString string];
    [table appendString:@"<center>"];
    [table appendString:lbl_Top.text];
    [table appendString:@"</center>"];
    
    [table appendString:@"<center>"];
    
    NSString *tableStart = @"<table border=\"1\">\n";
    NSString *rowStart = @"  <tr>\n";
    NSString *cellStart = @"    <td>";
    NSString *cellEnd = @"</td>\n";
    NSString *rowEnd = @"  </tr>\n";
    NSString *tableEnd = @"</table>";
    [table appendString:tableStart];
    for (int i=0; i< arrayKeyword.count; i++) {
        [table appendString:rowStart];  // one row for each object
        
        [table appendString:cellStart]; // first cell
        [table appendString:[arrayKeyword objectAtIndex:i]];
        [table appendString:cellEnd];
        
        [table appendString:cellStart]; // second cell
        [table appendString:[arrayCount objectAtIndex:i]];
        [table appendString:cellEnd];
        
        [table appendString:rowEnd]; // row end for each object
    }
    
    [table appendString:tableEnd];
    [table appendString:@"</center>"];
    
    [table appendString:@"<br></br>"];
    [table appendString:@"DOCUMENT CONTENT"];
    
    [table appendString:strContent];
    
    NSDictionary *parameters = @{@"content" :table, @"attachment" : [dict valueForKey:@"filepath"], @"attachmentname" : [dict valueForKey:@"filename"], @"phone": strPhone, @"message" : txtMesssage.text};
    
    NSMutableArray *paramArray = [[NSMutableArray alloc]init];
    
    for (NSString *string in parameters.allKeys)
    {
        [paramArray addObject:[NSString stringWithFormat:@"%@=%@",string,[parameters objectForKey:string]]];
    }
    
    NSString *params = [paramArray componentsJoinedByString:@"&"];
    NSData *body = [params dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody: body];
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if (!error) {
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"SNF Referral Scan sent successfully." preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:ok];
                
                [self presentViewController:alertController animated:YES completion:nil];
                
                return;
                
            } else {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:ok];
                
                [self presentViewController:alertController animated:YES completion:nil];
                
                return;
            }
        });
    }]resume];
}

-(void)hitEmailWebservice:(BOOL)isSMS {
    
    [self.view endEditing:YES];
    
    NSString *strStart = @"<span style=\"background-color:yellow\">";
    NSString *strEnd = @"</span>";
    
    NSMutableString *strContent = [[dict valueForKey:@"content"] mutableCopy];
    
    for (int i=1; i<arrayKeyword.count-1; i++) {
    
        NSArray *arr = [strContent componentsSeparatedByString:[arrayKeyword objectAtIndex:i]];
        
        NSMutableString *strKey = [[NSMutableString alloc]init];
        
        for (int j=0; j<arr.count-1; j++) {
            [strKey appendString:[arr objectAtIndex:j]];
            strStart = [NSString stringWithFormat:@"<span style=\"background-color:%@\">", [arrayColors objectAtIndex:i-1]];
            [strKey appendString:strStart];
            [strKey appendString:[arrayKeyword objectAtIndex:i]];
            [strKey appendString:strEnd];
        }
        
        [strKey appendString:[arr lastObject]];
        
        strContent = strKey;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *urlString = @"https://snfscan.com/library/m_email.php";
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0];
    request.HTTPMethod = @"POST";
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    NSMutableString *table = [NSMutableString string];
    [table appendString:@"<center>"];
    [table appendString:lbl_Top.text];
    [table appendString:@"</center>"];
    
    [table appendString:@"<center>"];
   
    NSString *tableStart = @"<table border=\"1\">\n";
    NSString *rowStart = @"  <tr>\n";
    NSString *cellStart = @"    <td>";
    NSString *cellEnd = @"</td>\n";
    NSString *rowEnd = @"  </tr>\n";
    NSString *tableEnd = @"</table>";
    [table appendString:tableStart];
    for (int i=0; i< arrayKeyword.count; i++) {
        [table appendString:rowStart];  // one row for each object
        
        [table appendString:cellStart]; // first cell
        [table appendString:[arrayKeyword objectAtIndex:i]];
        [table appendString:cellEnd];
        
        [table appendString:cellStart]; // second cell
        [table appendString:[arrayCount objectAtIndex:i]];
        [table appendString:cellEnd];
        
        [table appendString:rowEnd]; // row end for each object
    }

    [table appendString:tableEnd];
    [table appendString:@"</center>"];
 
    [table appendString:@"<br></br>"];
    [table appendString:@"DOCUMENT CONTENT"];
    
    [table appendString:strContent];
    
    NSDictionary *parameters = @{@"content" :table, @"attachment" : [dict valueForKey:@"filepath"], @"attachmentname" : [dict valueForKey:@"filename"], @"email": strEmail, @"message" : txtMesssage.text};
    if (isSMS) {
        parameters = @{@"content" :table, @"attachment" : [dict valueForKey:@"filepath"], @"attachmentname" : [dict valueForKey:@"filename"], @"email": strEmail, @"phone": strPhone, @"message" : txtMesssage.text};
    }
    NSMutableArray *paramArray = [[NSMutableArray alloc]init];
    
    for (NSString *string in parameters.allKeys)
    {
        [paramArray addObject:[NSString stringWithFormat:@"%@=%@",string,[parameters objectForKey:string]]];
    }
    
    NSString *params = [paramArray componentsJoinedByString:@"&"];
    NSData *body = [params dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody: body];
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if (!error) {
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"SNF Referral Scan sent successfully." preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:ok];
                
                [self presentViewController:alertController animated:YES completion:nil];
                
                return;
                
            } else {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:ok];
                
                [self presentViewController:alertController animated:YES completion:nil];
                
                return;
            }
        });
    }]resume];
    
}


-(BOOL)isnumericAlphaForEmail:(NSString*)string
{
    
    BOOL stricterFilter = NO;
    
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:string];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
