//
//  AppDelegate.m
//  FBDemo
//
//  Created by user37 on 2018/1/19.
//  Copyright © 2018年 user37. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"
@import FBSDKCoreKit;
@import SystemConfiguration;
@interface AppDelegate ()
@property Reachability *reachability;
@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    self.reachability = [Reachability reachabilityForInternetConnection];
    //網路有變化時會發送通知
    [self.reachability startNotifier];
    //訂閱kReachabilityChangedNotification通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChanged) name:kReachabilityChangedNotification object:nil ];
    
    if([self.reachability currentReachabilityStatus]==ReachableViaWiFi) {
        NSLog(@"wifi");
    }
    else if ([self.reachability currentReachabilityStatus]==ReachableViaWWAN) {
        NSLog(@"3G or 4G");
    }
    else if ([self.reachability currentReachabilityStatus]==NotReachable) {
        NSLog(@"飛航");
    }
    return YES;
}

-(void)networkChanged {
    if ([self.reachability currentReachabilityStatus] == ReachableViaWiFi || [self.reachability currentReachabilityStatus] == ReachableViaWWAN){
        NSLog(@"開始下載");
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

//應用程式從背景變成作用中，就會被呼叫
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}
//其他應用程式呼叫你的應用程式，會被呼叫到的：facebook app會呼叫你的應用程式（驗證完導回你的應用程式）
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url
           options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance]
                    application:application  openURL:url                                                  sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]                                                  annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    return handled;
}



- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"FBDemo"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
