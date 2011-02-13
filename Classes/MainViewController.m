//
//  MainViewController.m
//  AcceliMegameter
//
//  Created by Oliver Farago on 07/11/2010.
//  Copyright Rumex IT 2010. All rights reserved.
//

#import "MainViewController.h"
#import "AsyncUdpSocket.h"

NSString * const kNotification = @"kNotification";
NSString * const kNotificationMessage = @"kNotificationMessage";

#define kFilteringFactor 0.05

@implementation MainViewController

@synthesize locationManager;
@synthesize isRunning;
@synthesize UDPservIPAddress;
@synthesize socket;

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[NSUserDefaults resetStandardUserDefaults];
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

	self.socket = [[[AsyncUdpSocket alloc] initWithDelegate:self] autorelease];
    [self setIsRunning:NO];
    notificationCenter = [NSNotificationCenter defaultCenter];
	
	double accelRefresh = [prefs doubleForKey:@"accel_preference"];
	float compassRefresh = [prefs floatForKey:@"compass_preference"] ;
	
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / accelRefresh)];
	[[UIAccelerometer sharedAccelerometer] setDelegate:self];
	
	NSString *strTitle = [prefs stringForKey:@"title_preference"];
	NSString *strButtonA = [prefs stringForKey:@"buttona_preference"];
	NSString *strButtonB = [prefs stringForKey:@"buttonb_preference"];
	
	[navItem setTitle:strTitle];
	[buttonA setTitle:strButtonA forState:UIControlStateNormal];
	[buttonB setTitle:strButtonB forState:UIControlStateNormal];
	
	UDPservIPAddress = [prefs stringForKey:@"ipaddress_preference"];
    serverPort=1001;
	
	NSLog(@"%@",UDPservIPAddress);
	
	self.locationManager=[[[CLLocationManager alloc] init] autorelease];
	
	locationManager.desiredAccuracy = kCLLocationAccuracyBest;

	
	if ([CLLocationManager headingAvailable] == NO) {
		// No compass is available. This application cannot function without a compass, 
        // so a dialog will be displayed and no magnetic data will be measured.
        self.locationManager = nil;
        UIAlertView *noCompassAlert = [[UIAlertView alloc] initWithTitle:@"No Compass!" message:@"This device does not have the ability to measure magnetic fields." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[noCompassAlert release];
	} else {
		locationManager.delegate = self; // Set the delegate as self.
		locationManager.headingFilter = compassRefresh;
		[locationManager startUpdatingHeading];
	}
}


- (void)dealloc {
    [socket close];
    [socket release];
	[locationManager stopUpdatingHeading];
	[locationManager release];
	[UDPservIPAddress release];
	[super dealloc];
  
}

-(void)sendAccelData:(float)x y:(float)y z:(float)z {
	NSLog(@"%c001A%0.4f%c%0.4f%c%0.4f%c",2,x,9,y,9,z,3);
	[self sendMessage:[NSString stringWithFormat:@"%c001A%0.4f%c%0.4f%c%0.4f%c",2,x,9,y,9,z,3]];	
}

-(void)sendHeadingData:(float)angle {
	NSLog(@"%c001D%0.2f%c",2,angle,3);
	[self sendMessage:[NSString stringWithFormat:@"%c001D%0.2f%c",2,angle,3]];
	
}

- (IBAction)fireButtonPressed:(id)sender {
	NSLog(@"%c001B%c",2,3);
	[self sendMessage:[NSString stringWithFormat:@"%c001B%c",2,3]];		
}

- (IBAction)resetButtonPressed:(id)sender {
	NSLog(@"%c001C%c",2,3);
	[self sendMessage:[NSString stringWithFormat:@"%c001C%c",2,3]];		
}

//Public Action to begin connection
-(IBAction)startConnection{
	//NSLog(@"connection started");	
}

-(IBAction)stopConnection{
	//NOT IMPLEMENTED	
}

- (void)connectToHost:(NSString *)hostName onPort:(int)port {
    if (![self isRunning]) {
        if (port < 0 || port > 65535)
			port = 0;
		
        NSError *error = nil;
		
		NSLog(@"connecting...");
		[lblConnectionStatus setText:[NSString stringWithFormat:@"Port Bound"]];
		BOOL bl = [socket connectToHost:hostName onPort:port error:&error];
		
        if (!bl) {
			NSLog(@"Error connecting to server: %@", error);
			[lblConnectionStatus setText:[NSString stringWithFormat:@"Error Binding Port"]];
			return;
        }
	
        [self setIsRunning:YES];
    } else {
        //[socket disconnect];
        //[self setIsRunning:false];
		NSLog(@"already connected");
    }
}

- (void)disconnect {
	[self setIsRunning:NO];
    [socket close];
	[lblConnectionStatus setText:[NSString stringWithFormat:@"Port Closed"]];
}



- (void)sendMessage:(NSString *)message {
    NSString *terminatedMessage = [message stringByAppendingString:@"\r\n"];
    NSData *terminatedMessageData = [terminatedMessage dataUsingEncoding:NSASCIIStringEncoding];
    [socket sendData:terminatedMessageData toHost:UDPservIPAddress port:serverPort withTimeout:-1 tag:0];
}


- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    //accelerationX = acceleration.x;
	//accelerationY = acceleration.y;
	//accelerationZ = acceleration.z;
	
	accelerationX = acceleration.x * kFilteringFactor + accelerationX * (1.0 - kFilteringFactor);
	accelerationY = acceleration.y * kFilteringFactor + accelerationY * (1.0 - kFilteringFactor);
	accelerationZ = acceleration.z * kFilteringFactor + accelerationZ * (1.0 - kFilteringFactor);
		
	[lblX setText:[NSString stringWithFormat:@"X: %0.4f", accelerationX]];
	[lblY setText:[NSString stringWithFormat:@"Y: %0.4f", accelerationY]];
	[lblZ setText:[NSString stringWithFormat:@"Z: %0.4f", accelerationZ]];
	
	[self sendAccelData:accelerationX y:accelerationY z:accelerationZ];
}


- (void)setIP:(FlipsideViewController *)controller ipAddress:(NSString *)ipAddress {
	UDPservIPAddress = ipAddress;
}


- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {    
	[self dismissModalViewControllerAnimated:YES];
}


- (IBAction)showInfo:(id)sender {    
	
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
	CLLocationDirection headingTrue = newHeading.trueHeading;
	[lblHeading setText:[NSString stringWithFormat:@"Heading: %0.1f",headingTrue]];
	[self sendHeadingData:headingTrue];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([error code] == kCLErrorDenied) {
        // This error indicates that the user has denied the application's request to use location services.
    } else if ([error code] == kCLErrorHeadingFailure) {
        // This error indicates that the heading could not be determined, most likely because of strong magnetic interference.
		NSLog(@"Error");
    }
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	self.socket = nil;
	self.locationManager = nil;
	self.UDPservIPAddress = nil;
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


@end
