//
//  DBAppDelegate.m
//  Diveboard
//
//  Created by Vladimir Popov on 2/25/14.
//  Copyright (c) 2014 Vladimir Popov. All rights reserved.
//

#import "DBAppDelegate.h"
#import "LoginViewController.h"

@interface DBAppDelegate()
{
//    DBLoginViewController *loginVC;

}

@end

@implementation DBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [BugSenseController sharedControllerWithBugSenseAPIKey:@"6ab17859"
                                            userDictionary:nil
                                            sendImmediately:YES];

    [BugSenseController setLogMessagesCount:10];
    [BugSenseController setLogMessagesLevel:8];

    LoginViewController *loginVC;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:Nil];
    } else {
        loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController-ipad" bundle:Nil];

    }
    
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [navVC setNavigationBarHidden:YES];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = navVC;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    AppManager *appManager = [AppManager sharedManager];
//    if (appManager.loadedDives && appManager.loginResult) {
//        [userDefault setObject:appManager.loadedDives forKey:kLoadedDiveData(appManager.loginResult.user.ID)];
//        [userDefault synchronize];
//    }

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppEvents activateApp];
    [FBAppCall handleDidBecomeActiveWithSession:[AppManager sharedManager].fbSession];
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[AppManager sharedManager].fbSession close];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:[AppManager sharedManager].fbSession];
    
}

@end
