//
//  DepositViewController.m
//  BudgIt
//
//  Created by Eric L Eisner on 4/6/14.
//  Copyright (c) 2014 Eric L Eisner. All rights reserved.
//

#import "DepositViewController.h"
#import "Deposit.h"
#import "WeekTotal.h"

@interface DepositViewController ()
@end

@implementation DepositViewController

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
    
    [self.frequencyLabel setHidden:YES];
    [self.frequencyButton setHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    if(self.event.name != nil) {
        self.nameTextField.text = self.event.name;
    }
    if(self.event.date != nil) {
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        NSString* date  = [dateFormatter stringFromDate:self.event.date];
        self.dateTextField.text = date;
    }
    if(self.event.amount != nil) {
        self.netAmountTextField.text = [NSString stringWithFormat:@"$%@", self.event.amount];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)changeButtonImage:(BOOL)checked button:(UIButton*)button
{
    NSString* checkedImagePath = [[NSBundle mainBundle] pathForResource:@"checked-box" ofType:@"png"];
    NSString* uncheckedImagePath = [[NSBundle mainBundle] pathForResource:@"empty-box" ofType:@"png"];
    if(checked) {
        [button setImage:[[UIImage alloc] initWithContentsOfFile:checkedImagePath] forState:UIControlStateNormal];
    } else {
        [button setImage:[[UIImage alloc] initWithContentsOfFile:uncheckedImagePath] forState:UIControlStateNormal];
    }
}

-(IBAction)viewTapped
{
    [self.view endEditing:YES];
}

-(IBAction)repeatButtonPressed:(id)sender
{
    if([[self.repeatButton restorationIdentifier] isEqualToString:@"checked"]) {
        [self.frequencyLabel setHidden:YES];
        [self.frequencyButton setHidden:YES];
        [self.frequencyButton setTitle:@"None" forState:UIControlStateNormal];
        [self.frequencyButton setTitle:@"None" forState:UIControlStateSelected];
        [self changeButtonImage:NO button:self.repeatButton];
        [self.repeatButton setRestorationIdentifier:@""];
    } else {
        [self.frequencyLabel setHidden:NO];
        [self.frequencyButton setHidden:NO];
        [self changeButtonImage:YES button:self.repeatButton];
        [self.repeatButton setRestorationIdentifier:@"checked"];
    }
}

-(IBAction)frequencyButtonPressed:(id)sender
{
    
}

#pragma mark - CheckInputDelegate

-(BOOL)validAmount
{
    if([self.netAmountTextField isEditing]) {
        [self.netAmountTextField resignFirstResponder];
    }
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSNumber* number = [numberFormatter numberFromString:self.netAmountTextField.text];
    if(self.event.amount == nil || number == nil || number == [NSNumber numberWithDouble:0.0]) {
        return false;
    }
    return true;
}

-(BOOL)validDate
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSDate* date  = [dateFormatter dateFromString:self.dateTextField.text];
    NSString* pattern = @"\\d{2}/\\d{2}/\\d{4}";
    NSError* err;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&err];
    if(date == nil || [regex numberOfMatchesInString:self.dateTextField.text options:0 range:NSMakeRange(0, self.dateTextField.text.length)] == 0) {
        return false;
    }
    return true;
}

-(BOOL)validName
{
    if([self.nameTextField isEditing]) {
        [self.nameTextField resignFirstResponder];
    }
    if(self.event.name == nil || self.nameTextField.text == nil || [self.nameTextField.text isEqualToString:@""]) {
        return false;
    }
    return true;
}

#pragma mark - PickerViewDelegate

-(void)pickerValueChoosen:(BOOL)isReminder WithValue:(NSString *)value
{
    if(isReminder) {
        
    } else {
        
    }
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == self.nameTextField) {
        
    } else if(textField == self.dateTextField) {
        
    } else if(textField == self.netAmountTextField) {
        NSMutableString* string = [NSMutableString stringWithString:self.netAmountTextField.text];
        if(string.length > 1) {
            [string replaceOccurrencesOfString:@"$"  withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0,2)];
            [self.netAmountTextField setText:string];
        }
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == self.nameTextField) {
        self.event.name = textField.text;
    } else if(textField == self.dateTextField) {
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        NSString* pattern = @"\\d{2}/\\d{2}/\\d{4}";
        NSError* err;
        NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&err];
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        NSDate* date  = [dateFormatter dateFromString:textField.text];
        if(date == nil || [regex numberOfMatchesInString:textField.text options:0 range:NSMakeRange(0, textField.text.length)] == 0) {
            UIAlertView* error = [[UIAlertView alloc] initWithTitle:@"Invalid Date" message:@"Date must be in the format:\n MM/DD/YYYY" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [error show];
            return;
        }
        self.event.date = date;
    } else if(textField == self.netAmountTextField) {
        NSMutableString* string = [NSMutableString stringWithString:self.netAmountTextField.text];
        if([string isEqualToString:@""] || string == nil) {
            [self.netAmountTextField setText:@""];
        } else {
            NSNumber* number = [[NSNumber alloc] initWithDouble:[string doubleValue]];
            self.event.amount = number;
            [string insertString:@"$" atIndex:0];
            [self.netAmountTextField setText:string];
        }
    }
}

@end
