//
//  ViewWebVC.h
//  Sample
//
//  Created by Sahil garg on 15/05/17.
//  Copyright © 2017 DS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface ViewWebVC : UIViewController <UIWebViewDelegate>
{
    IBOutlet UIWebView *webView;

}

@property(nonatomic,strong) NSString *strUrl;

@end
