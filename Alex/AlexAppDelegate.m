//
//  AlexAppDelegate.m
//  Alex
//
//  Created by Isa Goksu on 11-07-09.
//  Copyright 2011 ThoughtWorks. All rights reserved.
//

#import "AlexAppDelegate.h"
#import "DropboxSDK.h"

#import "RootViewController.h"

@interface AlexAppDelegate () <DBSessionDelegate>
@end

@implementation AlexAppDelegate


@synthesize window=_window;

@synthesize splitViewController=_splitViewController;

@synthesize rootViewController=_rootViewController;

@synthesize detailViewController=_detailViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Set these variables before launching the app
    NSString* consumerKey = @"do5a5ualhiq55c7";
	NSString* consumerSecret = @"5nw17z8vznamg3h";
	
	// Look below where the DBSession is created to understand how to use DBSession in your app
	
	NSString* errorMsg = nil;
	if ([consumerKey rangeOfCharacterFromSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]].location != NSNotFound) {
		errorMsg = @"Make sure you set the consumer key correctly in DBRouletteAppDelegate.m";
	} else if ([consumerSecret rangeOfCharacterFromSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]].location != NSNotFound) {
		errorMsg = @"Make sure you set the consumer secret correctly in DBRouletteAppDelegate.m";
	}
	
	DBSession* session = [[DBSession alloc] initWithConsumerKey:consumerKey consumerSecret:consumerSecret];
	session.delegate = self; // DBSessionDelegate methods allow you to handle re-authentica
	[DBSession setSharedSession:session];
    [session release];
	
	if (errorMsg != nil) {
		[[[[UIAlertView alloc]
		   initWithTitle:@"Error Configuring Session" message:errorMsg 
		   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
		  autorelease]
		 show];
	}
    
    // Override point for customization after application launch.
    // Add the split view controller's view to the window and display.
    self.window.rootViewController = self.splitViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)sessionDidReceiveAuthorizationFailure:(DBSession*)session {
    NSLog(@"Session failed");
	DBLoginController* loginController = [[DBLoginController new] autorelease];
	[loginController presentFromController:(UIViewController *) self.detailViewController];
}


- (void)dealloc
{
    [_window release];
    [_splitViewController release];
    [_rootViewController release];
    [_detailViewController release];
    [super dealloc];
}

@end
