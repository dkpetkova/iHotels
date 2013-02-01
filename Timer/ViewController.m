//
//  ViewController.m
//  Timer
//
//  Created by Desislava on 11/30/12.
//  Copyright (c) 2012 Student15. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@property (strong, nonatomic) IBOutlet UILabel *labelTimer;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property NSDate *startDate;
@property NSTimer *myTimer;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;

//three UIView-s for animation

@property (weak, nonatomic) IBOutlet UIView *blueView;
@property (weak, nonatomic) IBOutlet UIView *redView;
@property (weak, nonatomic) IBOutlet UIView *greenView;


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.stopButton.hidden = YES;
    
    //set the font of the labelTimer to Arial-41
    [self.labelTimer setFont:[UIFont fontWithName:@"Arial" size:41]];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)setInfo:(id)sender
{
    UIAlertView *infoAlert = [[UIAlertView alloc] initWithTitle:@"Timer App" message:@"Desislava Petkova" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [infoAlert show];
}

- (IBAction)clearTheLabel:(id)sender
{
    self.labelTimer.text = @"00:00:00.000";
}

- (void)updateTimer
{
    static int count = 0;
	count++;
    
    //NSDate *currentDate = [NSDate date];
    NSDate *currentDate = [[NSDate alloc]init];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:self.startDate];
    
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss.SSS"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    
    NSString *timeString=[dateFormatter stringFromDate:timerDate];
    self.labelTimer.text = timeString;
    
    self.redView.hidden = YES;
	self.greenView.hidden = YES;
	self.blueView.hidden = YES;
    
    //animation with the three UIView-s
	
    //the animation with blocks
    switch (count & 0x03) {
		case 0: self.redView.hidden = NO; break;
		case 2: self.greenView.hidden = NO; break;
		case 4: self.blueView.hidden = NO; break;
	}
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView animateWithDuration:1.0f animations:^{
                                        [self.redView setAlpha:(float)((count & 0x07) == 0)];
                                        [self.greenView setAlpha:(float)((count & 0x07) == 2)];
                                        [self.blueView setAlpha:(float)((count & 0x07) == 4)];
        
    }];
     
    
    //the same animation without blocks
    /*
     switch (count & 0x03) {
     case 0: self.redView.hidden = NO; break;
     case 2: self.greenView.hidden = NO; break;
     case 4: self.blueView.hidden = NO; break;
     }
     
     CGContextRef context = UIGraphicsGetCurrentContext();
     
     [UIView beginAnimations:nil context:context];
     [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
     [UIView setAnimationDuration:1.0f];
     
     [self.redView setAlpha:(float)((count & 0x07) == 0)];
     [self.greenView setAlpha:(float)((count & 0x07) == 2)];
     [self.blueView setAlpha:(float)((count & 0x07) == 4)];
     
     [UIView commitAnimations];
     */
}

- (IBAction)startOnPressed:(id)sender
{
    self.labelTimer.backgroundColor = [UIColor redColor];
    self.startDate = [[NSDate alloc]init];
    // the timer fires every 10 ms
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/10.0
                                                      target:self
                                                    selector:@selector(updateTimer)
                                                    userInfo:nil
                                                     repeats:YES];
    self.playButton.hidden = YES;
    self.stopButton.hidden = NO;
    self.clearButton.enabled = NO;

    
}

- (IBAction)stopOnPressed:(id)sender
{
    self.labelTimer.backgroundColor = [UIColor blackColor];
    [self.myTimer invalidate];
    self.myTimer = nil;
    [self updateTimer];
    self.playButton.hidden = NO;
    self.stopButton.hidden = YES;
    
    self.redView.hidden = YES;
	self.greenView.hidden = YES;
	self.blueView.hidden = YES;
    self.clearButton.enabled = YES;
}

@end
