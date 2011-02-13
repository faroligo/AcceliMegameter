//
//  AcceliMegameterAppDelegate.m
//  AcceliMegameter
//
//  Created by Oliver Farago on 07/11/2010.
//  Copyright Rumex IT 2010. All rights reserved.
//

#import "AcceliMegameterAppDelegate.h"
#import "MainViewController.h"

@implementation AcceliMegameterAppDelegate

@synthesize window;
@synthesize mainViewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.  

    // Add the main view controller's view to the window and display.
	application.idleTimerDisabled = YES;
    [window addSubview:mainViewController.view];
    [window makeKeyAndVisible];

    return YES;
}

+ (void)initialize
{
	if (![[NSUserDefaults standardUserDefaults] objectForKey:@"BNRMessagePrefKey"])  {
		
		NSString  *mainBundlePath = [[NSBundle mainBundle] bundlePath];
		NSString  *settingsPropertyListPath = [mainBundlePath
											   stringByAppendingPathComponent:@"Settings.bundle/Root.plist"];
		
		NSDictionary *settingsPropertyList = [NSDictionary 
											  dictionaryWithContentsOfFile:settingsPropertyListPath];
		
		NSMutableArray      *preferenceArray = [settingsPropertyList objectForKey:@"PreferenceSpecifiers"];
		NSMutableDictionary *registerableDictionary = [NSMutableDictionary dictionary];
		
		for (int i = 0; i < [preferenceArray count]; i++)  { 
			NSString  *key = [[preferenceArray objectAtIndex:i] objectForKey:@"Key"];
			
			if (key)  {
				id  value = [[preferenceArray objectAtIndex:i] objectForKey:@"DefaultValue"];
				[registerableDictionary setObject:value forKey:key];
			}
		}
		
		[[NSUserDefaults standardUserDefaults] registerDefaults:registerableDictionary]; 
		[[NSUserDefaults standardUserDefaults] synchronize]; 
	} 
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [mainViewController release];
    [window release];
    [super dealloc];
}

@end
