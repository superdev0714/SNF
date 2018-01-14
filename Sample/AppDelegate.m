//
//  AppDelegate.m
//  Sample
//
//  Created by Sahil garg on 15/05/17.
//  Copyright © 2017 DS. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "ViewWebVC.h"
#import "PayPalMobile.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

//NSString *htmlstr = `@"This is <font color='red'>simple</font>"`;
//
//NSMutableAttributedString *attributedTitleString = [[NSMutableAttributedString alloc] initWithData:[htmlstr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//
//textField.attributedText =attributedTitleString;
//
//textField.font = [UIFont fontWithName:@"vardana" size:20.0];

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //access_token$production$x622xj5c2vq27j3s$348330a9ad53fb7e294763fd231c6b83
    
    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : @"access_token$production$x622xj5c2vq27j3s$348330a9ad53fb7e294763fd231c6b83",PayPalEnvironmentSandbox : @""}];
    
    return YES;
}


-(BOOL)application:(UIApplication *)application
           openURL:(NSURL *)url
 sourceApplication:(NSString *)sourceApplication
        annotation:(id)annotation
{
  
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"] length] > 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                    @"Main" bundle:[NSBundle mainBundle]];
        ViewWebVC *myController = [storyboard instantiateViewControllerWithIdentifier:@"ViewWebVC"];
        myController.strUrl = [url absoluteString];
        [self.window.rootViewController dismissViewControllerAnimated:NO completion:nil];
        [self.window.rootViewController presentViewController:myController animated:true completion:nil];
        
       return YES;
    } else {
        return NO;
    }
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
