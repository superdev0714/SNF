//
//  ViewWebVC.m
//  Sample
//
//  Created by Sahil garg on 15/05/17.
//  Copyright © 2017 DS. All rights reserved.
//

#import "ViewWebVC.h"
#import "ShowDataVC.h"
#include <stdlib.h>

@interface ViewWebVC ()

@end

@implementation ViewWebVC

-(void)viewWillAppear:(BOOL)animated {
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
//    NSLog(@"%@",self.strUrl);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.strUrl]];
    [webView loadRequest:request];
    
    webView.delegate= self;
    [webView setScalesPageToFit:YES];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)action_Back:(id)sender {
    [[[UIApplication sharedApplication] delegate].window.rootViewController dismissViewControllerAnimated:true completion:nil];
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {

   [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (IBAction)btnSendBar:(id)sender {
    
    NSString *strID = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"];
    if (strID.length==0) {
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSData *myData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.strUrl]];
   
    NSURL *url = [NSURL URLWithString:@"https://snfscan.com/m_action.php"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [request setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/536.26.14 (KHTML, like Gecko) Version/6.0.1 Safari/536.26.14" forHTTPHeaderField:@"User-Agent"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSMutableDictionary *dicton = [[NSMutableDictionary alloc]initWithObjectsAndKeys:strID,@"userid",nil];
    
    for (NSString *param in dicton)
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [dicton objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }


    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSString *strfileName =[NSString stringWithFormat:@"File%d",arc4random_uniform(1000)];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploaded_file\"; filename=\"%@.pdf\"\r\n",strfileName] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[NSData dataWithData:myData]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];

    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setURL:url];
    
    [[[NSURLSession sharedSession]dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if (error) {
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:ok];
                
                [self presentViewController:alertController animated:YES completion:nil];
                
            } else {
                NSLog(@"JSON : %@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
                
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data  options:NSJSONReadingMutableContainers error:nil];
                if ([json isKindOfClass:[NSDictionary class]]) {
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Document scaned successfully." preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        ShowDataVC *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"ShowDataVC"];
                        myController.dict = json;
                        [self presentViewController:myController animated:true completion:nil];
                    }];
                    [alertController addAction:ok];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                    
                } else {
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"response is not json" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                }
            }
        });
        
        
    }] resume];
}

@end
