//
//  AddEditEventViewController.m
//  BudgIt
//
//  Created by Eric L Eisner on 4/3/14.
//  Copyright (c) 2014 Eric L Eisner. All rights reserved.
//

#import "AppDelegate.h"
#import "AddEditEventViewController.h"
#import "BillViewController.h"
#import "DepositViewController.h"
#import "Bill.h"
#import "Deposit.h"
#import "WeekTotal.h"

@interface AddEditEventViewController ()
@property(nonatomic, strong) NSNumber* originalValue;
@property(nonatomic, strong) NSString* billButtonSelectedPath;
@property(nonatomic, strong) NSString* billButtonPath;
@property(nonatomic, strong) NSString* depositButtonSelectedPath;
@property(nonatomic, strong) NSString* depositButtonPath;
@property(nonatomic) BOOL isReminder;
@property(nonatomic) NSString* value;
@end

@implementation AddEditEventViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.isBill = YES;
    BillViewController* bvc = [[BillViewController alloc] init];
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, bvc.view.frame.size.height)];
    [self.view addSubview:self.scrollView];
    if([self.event isKindOfClass:[Deposit class]]) {
        [self performSegueWithIdentifier:@"DepositSegue" sender:self];
    } else {
        [self performSegueWithIdentifier:@"BillSegue" sender:self];
    }
    
    [self.deleteButton setHidden:YES];
    
    self.billButtonSelectedPath = [[NSBundle mainBundle] pathForResource:@"bill-selected" ofType:@"png"];
    self.billButtonPath = [[NSBundle mainBundle] pathForResource:@"bill" ofType:@"png"];
    self.depositButtonSelectedPath = [[NSBundle mainBundle] pathForResource:@"deposit-selected" ofType:@"png"];
    self.depositButtonPath = [[NSBundle mainBundle] pathForResource:@"deposit" ofType:@"png"];
    
    if(self.isEdit) {
        if([self.event isKindOfClass:[Deposit class]]) {
            [self.depositButton setEnabled:NO];
            [self.billButton setHidden:YES];
        } else {
            [self.depositButton setHidden:YES];
            [self.billButton setEnabled:NO];
        }
        [self.deleteButton setHidden:NO];
        self.originalValue = [[NSNumber alloc] initWithDouble:[self.event.amount doubleValue]];
        
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    if(self.isBill) {
        BillViewController* bvc = [[BillViewController alloc] init];
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, bvc.view.frame.size.height)];
        [self.billButton setImage:[UIImage imageWithContentsOfFile:self.billButtonSelectedPath] forState:UIControlStateNormal];
        [self.depositButton setImage:[UIImage imageWithContentsOfFile:self.depositButtonPath] forState:UIControlStateNormal];
    } else {
        DepositViewController* dvc = [[DepositViewController alloc] init];
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, dvc.view.frame.size.height)];
        [self.billButton setImage:[UIImage imageWithContentsOfFile:self.billButtonPath] forState:UIControlStateNormal];
        [self.depositButton setImage:[UIImage imageWithContentsOfFile:self.depositButtonSelectedPath] forState:UIControlStateNormal];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutomaticallyForwardRotationMethods
{
    return YES;
}

-(void)setPickerView
{
    [self performSegueWithIdentifier:@"PickerViewSegue" sender:self];
}

-(IBAction)cancelPressed
{
    if(!self.isEdit) {
        AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext* moc = [appDelegate managedObjectContext];
        
        [moc deleteObject:self.event];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)donePressed
{
    if(![[self checkInputDelegate] validName]) {
        UIAlertView* error = [[UIAlertView alloc] initWithTitle:@"Invalid Name" message:@"You must enter a name." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [error show];
        return;
    }
    if(![[self checkInputDelegate] validDate]) {
        UIAlertView* error = [[UIAlertView alloc] initWithTitle:@"Invalid Date" message:@"Date must be in the format:\n MM/DD/YYYY" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [error show];
        return;
    }
    if(![[self checkInputDelegate] validAmount]) {
        UIAlertView* error = [[UIAlertView alloc] initWithTitle:@"Invalid Amount" message:@"You must enter a non-zero number for the amount.  Do not include any currency symbols." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [error show];
        return;
    }
    
    if(!self.isEdit) {
        [[self addDelegate] eventAdded:self.isBill WithNullEvent:NO WithEvent:self.event WithWeekTotal:(WeekTotal *)self.weekTotal];
    } else {
        NSNumber* netChange = [NSNumber numberWithDouble:[self.originalValue doubleValue] - [self.event.amount doubleValue]];
        [[self editDelegate] eventEditted:self.isBill WithEvent:self.event WithNetChange:netChange];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)billPressed
{
    [self performSegueWithIdentifier:@"BillSegue" sender:self];
}

-(IBAction)depositPressed
{
    [self performSegueWithIdentifier:@"DepositSegue" sender:self];
}

-(IBAction)deletePressed
{
    UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure want to delete this event?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [dialog addButtonWithTitle:@"Okay"];
    dialog.tag = 1234;
    [dialog show];
}
                           
#pragma mark - UIAlertViewDelegate
                           
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1234 && buttonIndex == 1) {
        AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext* moc = [appDelegate managedObjectContext];
        
        [moc deleteObject:self.event];
        
        [[self deleteDelegate] eventDeleted:self.isBill WithEvent:self.event];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - ReminderPickerDelegate

-(void)setReminderWithValue:(NSString*)value
{
    self.value = value;
    self.isReminder = YES;
    [self performSegueWithIdentifier:@"PickerViewSegue" sender:self];
}

#pragma mark - FrequencyPickerDelegate

-(void)setFrequencyWithValue:(NSString*)value
{
    self.value = value;
    self.isReminder = NO;
    [self performSegueWithIdentifier:@"PickerViewSegue" sender:self];
}

#pragma mark - PickerViewDelegate

-(void)pickerValueChoosen:(BOOL)isReminder WithValue:(NSString *)value
{
    [[self pickerDelegate] pickerValueChoosen:isReminder WithValue:value];
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* moc = [appDelegate managedObjectContext];
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"BillSegue"]) {
        BillViewController* dest = [segue destinationViewController];
        [self addChildViewController:dest];
        [self.scrollView addSubview:dest.view];
        [self.scrollView setScrollEnabled:YES];
        [dest didMoveToParentViewController:self];
        if(self.event == nil) {
            self.event = [NSEntityDescription insertNewObjectForEntityForName:@"Bill" inManagedObjectContext:moc];
        } else if([self.event isKindOfClass:[Deposit class]]) {
            [moc deleteObject:self.event];
            self.event = [NSEntityDescription insertNewObjectForEntityForName:@"Bill" inManagedObjectContext:moc];
        }
        if(self.dateFromVC != nil) {
            self.event.date = self.dateFromVC;
        }
        dest.event = (Bill*)self.event;
        dest.frequencyDelegate = self;
        dest.reminderDelegate = self;
        self.checkInputDelegate = dest;
        self.pickerDelegate = dest;
        self.isBill = YES;
        [self.billButton setImage:[UIImage imageWithContentsOfFile:self.billButtonSelectedPath] forState:UIControlStateNormal];
        [self.depositButton setImage:[UIImage imageWithContentsOfFile:self.depositButtonPath] forState:UIControlStateNormal];
    } else if([segue.identifier isEqualToString:@"DepositSegue"]) {
        DepositViewController* dest = [segue destinationViewController];
        [self addChildViewController:dest];
        [self.scrollView addSubview:dest.view];
        [self.scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
        [self.scrollView setScrollEnabled:NO];
        [dest didMoveToParentViewController:self];
        if([self.event isKindOfClass:[Bill class]]) {
            [moc deleteObject:self.event];
            self.event = [NSEntityDescription insertNewObjectForEntityForName:@"Deposit" inManagedObjectContext:moc];
        }
        if(self.dateFromVC != nil) {
            self.event.date = self.dateFromVC;
        }
        dest.weekTotal = self.weekTotal;
        dest.event = (Deposit*)self.event;
        dest.frequencyDelegate = self;
        self.checkInputDelegate = dest;
        self.pickerDelegate = dest;
        self.isBill = NO;
        [self.billButton setImage:[UIImage imageWithContentsOfFile:self.billButtonPath] forState:UIControlStateNormal];
        [self.depositButton setImage:[UIImage imageWithContentsOfFile:self.depositButtonSelectedPath] forState:UIControlStateNormal];
    } else if([segue.identifier isEqualToString:@"PickerViewSegue"]) {
        PickerViewController* dest = [segue destinationViewController];
        dest.pickerDelegate = self;
        dest.value = self.value;
        dest.isReminder = self.isReminder;
    }
}


@end
