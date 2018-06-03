//
//  RunViewController.h
//  Intervals
//
//  Created by Adam Schor on 6/3/18.
//  Copyright © 2018 AandA Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "DataManager.h"
#import <AudioToolbox/AudioToolbox.h>


@interface RunViewController : UIViewController

@property NSString *keyForTimes;

@property AVAudioPlayer *player;

@property NSTimer *timer;
@property NSInteger startTime;
@property NSInteger round;

@property (strong, nonatomic) NSMutableArray *arrTimes;

@property (strong, nonatomic) IBOutlet UILabel *labelTimer;

@property (strong, nonatomic) IBOutlet UILabel *labelRoundNumber;

@property (strong, nonatomic) IBOutlet UIButton *btnStart;

- (IBAction)btnStartPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnPause;

- (IBAction)btnPausePressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnRestart;

- (IBAction)btnRestartPressed:(id)sender;


@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *ReButtonCollection;

@property (strong, nonatomic) IBOutlet UIButton *btnPrev;

- (IBAction)btnPrevPressed:(id)sender;

@property BOOL running;

@property (strong, nonatomic) IBOutlet UIButton *btnNext;

- (IBAction)btnNextPressed:(id)sender;

@end
