//
//  FlipsideViewController.h
//  AcceliMegameter
//
//  Created by Oliver Farago on 07/11/2010.
//  Copyright Rumex IT 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FlipsideViewControllerDelegate;


@interface FlipsideViewController : UIViewController {
	id <FlipsideViewControllerDelegate> delegate;
	IBOutlet UITextField *ipField;
}


@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
- (IBAction)done:(id)sender;
- (IBAction)changeIP:(id)sender;
@end


@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
- (void)setIP:(FlipsideViewController *)controller ipAddress:(NSString *)ipAddress;
@end

