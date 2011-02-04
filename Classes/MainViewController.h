//
//  MainViewController.h
//  AcceliMegameter
//
//  Created by Oliver Farago on 07/11/2010.
//  Copyright Rumex IT 2010. All rights reserved.
//

#import "FlipsideViewController.h"
#import "AsyncUdpSocket.h"
#import <CoreLocation/CoreLocation.h>

extern NSString * const kNotification;
extern NSString * const kNotificationMessage;

@class AsyncUdpSocket;

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, UIAccelerometerDelegate, CLLocationManagerDelegate> {
	AsyncUdpSocket *socket;
	BOOL isRunning;
    NSNotificationCenter* notificationCenter;
	IBOutlet UILabel *lblConnectionStatus;
	IBOutlet UILabel *lblX;
	IBOutlet UILabel *lblY;
	IBOutlet UILabel *lblZ;
	IBOutlet UILabel *lblHeading;
	IBOutlet UINavigationItem *navItem;
	
	IBOutlet UIButton *buttonA;
	IBOutlet UIButton *buttonB;
	
	CLLocationManager *locationManager;

	NSString *UDPservIPAddress;
	int serverPort;
	
	float accelerationX;
    float accelerationY;
	float accelerationZ;
}

- (IBAction)showInfo:(id)sender;
- (IBAction)fireButtonPressed:(id)sender;
- (IBAction)resetButtonPressed:(id)sender;

@property (readwrite, assign) BOOL isRunning;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) NSString *UDPservIPAddress;
@property (nonatomic, retain) AsyncUdpSocket *socket;

- (void)sendAccelData:(float)x y:(float)y z:(float)z;
- (void)connectToHost:(NSString *)hostName onPort:(int)port;
- (void)sendMessage:(NSString *)message;
- (void)sendHeadingData:(float)angle;
- (void)disconnect;

@end
