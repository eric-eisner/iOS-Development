//
//  InitialViewController.m
//  BudgIt
//
//  Created by Eric L Eisner on 5/12/14.
//  Copyright (c) 2014 Eric L Eisner. All rights reserved.
//

#import "InitialViewController.h"

@interface InitialViewController ()
@property(nonatomic, strong) NSTimer* timer;
@end

@implementation InitialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateProgress
{
    static int count = 0;
    if (count <= 100) {
        self.loadingBar.progress = (float)count / 100.0f;
        count++;
    } else {
        [self.timer invalidate];
        self.timer = nil;
        [self performSegueWithIdentifier:@"HomeSegue" sender:self];
    }
}

@end
