//
//  AcceliMegameterAppDelegate.h
//  AcceliMegameter
//
//  Created by Oliver Farago on 07/11/2010.
//  Copyright Rumex IT 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface AcceliMegameterAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MainViewController *mainViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MainViewController *mainViewController;

@end

