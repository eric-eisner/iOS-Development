//
//  YearViewController.m
//  BudgIt
//
//  Created by Eric L Eisner on 4/3/14.
//  Copyright (c) 2014 Eric L Eisner. All rights reserved.
//

#import "YearViewController.h"
#import "Month.h"
#import "Year.h"
#import "YearView.h"

@interface YearViewController ()
@property(nonatomic, strong) Year* selectedYear;
@end

@implementation YearViewController

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
    
    self.navigationItem.hidesBackButton = NO;
    
    self.selectedYear = [[Year alloc] initWithNumber:[self.year number]];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItems = @[self.prevButton,backButton];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.yearButton setTitle:[NSString stringWithFormat:@"%i", (int)self.year.number] forState:UIControlStateNormal];
    [self.yearButton setTitle:[NSString stringWithFormat:@"%i", (int)self.year.number] forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)monthSelected:(id)sender
{
    if([sender isEqual:self.monthButtons[0]]) {
        // January
        self.month.name = 1;
    } else if([sender isEqual:self.monthButtons[1]]) {
        // February
        self.month.name = 2;
    } else if([sender isEqual:self.monthButtons[2]]) {
        // March
        self.month.name = 3;
    } else if([sender isEqual:self.monthButtons[3]]) {
        // April
        self.month.name = 4;
    } else if([sender isEqual:self.monthButtons[4]]) {
        // May
        self.month.name = 5;
    } else if([sender isEqual:self.monthButtons[5]]) {
        // June
        self.month.name = 6;
    } else if([sender isEqual:self.monthButtons[6]]) {
        // July
        self.month.name = 7;
    } else if([sender isEqual:self.monthButtons[7]]) {
        // August
        self.month.name = 8;
    } else if([sender isEqual:self.monthButtons[8]]) {
        // September
        self.month.name = 9;
    } else if([sender isEqual:self.monthButtons[9]]) {
        // October
        self.month.name = 10;
    } else if([sender isEqual:self.monthButtons[10]]) {
        // November
        self.month.name = 11;
    } else if([sender isEqual:self.monthButtons[11]]) {
        // December
        self.month.name = 12;
    }
    self.year.number = self.selectedYear.number;
    [[self delegate] selectedDate];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)previousYear
{
    [self flipFromLeft];
    self.selectedYear.number = self.selectedYear.number-1;
    [self.yearButton setTitle:[NSString stringWithFormat:@"%i", (int)self.selectedYear.number] forState:UIControlStateNormal];
}

-(IBAction)nextYear
{
    [self flipFromRight];
    self.selectedYear.number = self.selectedYear.number+1;
    [self.yearButton setTitle:[NSString stringWithFormat:@"%i", (int)self.selectedYear.number] forState:UIControlStateNormal];
    
}

-(void)doTransitionWithType:(UIViewAnimationOptions)animationTransitionType
{
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"YearView" owner:self options:nil];
    YearView *mainView = [subviewArray objectAtIndex:0];
    mainView.frame = self.yearView.frame;
    
    [UIView transitionFromView:self.yearView toView:mainView duration:0.5 options:animationTransitionType completion:^(BOOL finished){}];
    [self.view addSubview:mainView];
    self.yearView = mainView;
}


-(void)flipFromLeft
{
    [self doTransitionWithType:UIViewAnimationOptionTransitionFlipFromLeft];
    
}
-(void)flipFromRight
{
    [self doTransitionWithType:UIViewAnimationOptionTransitionFlipFromRight];
    
}

@end
