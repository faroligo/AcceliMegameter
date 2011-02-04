//
//  FlipsideViewController.m
//  AcceliMegameter
//
//  Created by Oliver Farago on 07/11/2010.
//  Copyright Rumex IT 2010. All rights reserved.
//

#import "FlipsideViewController.h"

@implementation FlipsideViewController
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];      
}

- (IBAction)done:(id)sender {
	[self.delegate flipsideViewControllerDidFinish:self];	
}

- (IBAction)changeIP:(id)sender {
	[self.delegate setIP:self ipAddress:ipField.text];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	// Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
}

@end
