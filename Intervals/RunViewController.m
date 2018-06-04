//
//  RunViewController.m
//  Intervals
//
//  Created by Adam Schor on 6/3/18.
//  Copyright © 2018 AandA Development. All rights reserved.
//

#import "RunViewController.h"

@interface RunViewController ()

@end

@implementation RunViewController

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:

    (id<UIViewControllerTransitionCoordinator>)coordinator {
    // will execute before rotation
    
    [coordinator animateAlongsideTransition:^(id  _Nonnull context) {
        
        // will execute during rotation
        
    } completion:^(id  _Nonnull context) {
        NSInteger height = self.labelTimer.frame.size.height;
        self.labelTimer.font = [UIFont fontWithName:@"Helvetica" size:height*0.75];
        // will execute after rotation
        
    }];
}


-(BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    
    for(UIViewController *tab in  self.tabBarController.viewControllers)
        
    {
        [tab.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                [UIFont fontWithName:@"Helvetica" size:24.0], NSFontAttributeName, nil]
                                      forState:UIControlStateNormal];
    }
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    
    NSInteger width = self.view.frame.size.width;
    NSInteger height = self.view.frame.size.height;
    
    _keyForTimes = @"keyForTimes";
    _labelTimer.frame = CGRectMake(0, height/3, width, height*.4);
    _labelTimer.layer.borderColor = [[UIColor blueColor] CGColor];
    _labelTimer.layer.borderWidth = 6;
    _labelTimer.textColor = [UIColor blueColor];
    _labelTimer.font = [UIFont fontWithName:@"Helvetica" size:240];
    _labelTimer.layer.cornerRadius = 25;
    
    _labelRoundNumber.font =  [UIFont fontWithName:@"Helvetica" size:32];
    _labelRoundNumber.textColor = [UIColor redColor];
    _labelRoundNumber.textAlignment = NSTextAlignmentCenter;
    
    _btnStart.frame = CGRectMake(10, height/5, width/3, height/10);
    _btnStart.backgroundColor = [UIColor greenColor];
    _btnStart.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:32];
    [_btnStart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnStart.layer.cornerRadius = 10;
    
    _btnPause.frame = CGRectMake(width-width/3-10, height/5, width/3, height/10);
    _btnPause.backgroundColor = [UIColor redColor];
    _btnPause.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:32];
    [_btnPause setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _btnPause.layer.cornerRadius = 10;
    
    _btnRestart.frame = CGRectMake(width/2-width/8, .8*height, width/4, height/12);
    _btnNext.frame = CGRectMake(width-width/4-10, .8*height, width/4, height/12);
    _btnPrev.frame  = CGRectMake(10, .8*height, width/4, height/12);
    
    for (UIButton *reButtons in _ReButtonCollection) {
        reButtons.backgroundColor = [UIColor cyanColor];
        reButtons.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:28];
        [reButtons setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        reButtons.layer.cornerRadius = 10;
        reButtons.layer.borderColor = [[UIColor blueColor] CGColor];
        reButtons.layer.borderWidth = 2;
        
        
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    
    NSInteger height = self.labelTimer.frame.size.height;
    self.labelTimer.font = [UIFont fontWithName:@"Helvetica" size:height*0.75];
    
    _running = NO;
    
    _arrTimes = [[NSMutableArray alloc] initWithArray:[DataManager getArrayForKey:_keyForTimes]];
    _round = 0;
    if (_arrTimes.count!=0) {
        _startTime = [_arrTimes[_round] integerValue];
        _labelTimer.text = [NSString stringWithFormat:@"%li",_startTime];
        [self setRoundLabel];}
    
    else {
        _labelTimer.text = @"";
        _labelRoundNumber.text = @"Go To Setup";
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [_timer invalidate];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)runTimer {
    if (_arrTimes.count != 0) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCountDown) userInfo:nil repeats:YES];
    }
}

-(void)timerSetUp{
    _startTime = [_arrTimes[_round] integerValue];
    
}

-(void)timerCountDown {
    _labelTimer.text = [NSString stringWithFormat:@"%li", _startTime];
    _startTime =_startTime - 1;
    
    if (_startTime < 0 && _round + 1<_arrTimes.count) {
        _round = _round + 1;
        _startTime = [_arrTimes[_round]integerValue];
        [self playSound];
        [self setRoundLabel];
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
    }
    if (_startTime < 0 && _round + 1 ==_arrTimes.count) {
        [self playSound];
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [_timer invalidate];
    }
    
}

-(void)setRoundLabel{
    _labelRoundNumber.text = [NSString stringWithFormat:@"Round %li",_round+1];
}
- (IBAction)btnStartPressed:(id)sender {
    if (!_running) {
        [self runTimer];
        _running = YES;
    }
}
- (IBAction)btnPausePressed:(id)sender {
    if (_running) {
        [_timer invalidate];
        _running = NO;}
    
}

- (IBAction)btnRestartPressed:(id)sender {
    if (_arrTimes.count != 0) {
        
        [_timer invalidate];
        _startTime = [_arrTimes[_round] integerValue];
        
        _labelTimer.text = [NSString stringWithFormat:@"%li",_startTime];
        _running = NO;
    }
    
}

- (IBAction)btnPrevPressed:(id)sender {
    if (_arrTimes.count != 0) {
        
        
        [_timer invalidate];
        if (_round>0) {
            _round = _round -1;}
        else {
            _round = 0;
        }
        [self setRoundLabel];
        _startTime = [_arrTimes[_round] integerValue];
        _labelTimer.text = [NSString stringWithFormat:@"%li",_startTime];
        _running = NO;
    }
}

- (IBAction)btnNextPressed:(id)sender {
    if (_arrTimes.count != 0) {
        
        [_timer invalidate];
        
        if (_round<_arrTimes.count-1) {
            _round = _round + 1;
        }
        
        else {
            (_round = _arrTimes.count-1);
        }
        
        [self setRoundLabel];
        _startTime = [_arrTimes[_round] integerValue];
        _labelTimer.text = [NSString stringWithFormat:@"%li",_startTime];
        _running = NO;
    }
    
}


-(void)playSound {
    
    NSString *songPath;
    NSString *soundName = @"beep";
    
    
    songPath =[[NSBundle mainBundle]pathForResource:soundName ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:songPath];
    
    NSError *error;
    
    _player= [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
    
    [_player setNumberOfLoops:0];
    [_player setVolume:10];
    [_player play];
}




@end
