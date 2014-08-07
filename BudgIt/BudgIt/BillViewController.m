//
//  AddEditBillViewController.m
//  BudgIt
//
//  Created by Eric L Eisner on 4/6/14.
//  Copyright (c) 2014 Eric L Eisner. All rights reserved.
//

#import "BillViewController.h"
#import "Event.h"
#import "Bill.h"
#import "WeekTotal.h"

@interface BillViewController ()
@property(nonatomic) BOOL selectReminder1;
@end

@implementation BillViewController

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
    
    [self.reminder1Button setHidden:YES];
    [self.reminder1DeleteButton setHidden:YES];
    [self.reminder2Button setHidden:YES];
    [self.reminder2DeleteButton setHidden:YES];
    
    [self.frequencyLabel setHidden:YES];
    [self.frequencyButton setHidden:YES];
}

-(void)viewWillAppear:(BOOL)animated
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
        self.paymentTextField.text = [NSString stringWithFormat:@"$%@", self.event.amount];
    }
    
    if(self.event.repeat == [NSNumber numberWithInt:1]) {
        if(![[self.repeatButton restorationIdentifier] isEqualToString:@"checked"]) {
            [self repeatButtonPressed:self];
        }
        [self.frequencyButton setTitle:self.event.frequency forState:UIControlStateNormal];
        [self.frequencyButton setTitle:self.event.frequency forState:UIControlStateSelected];
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
    [self.view endEditing:YES];
    if([[self.repeatButton restorationIdentifier] isEqualToString:@"checked"]) {
        [self.frequencyLabel setHidden:YES];
        [self.frequencyButton setHidden:YES];
        [self.frequencyButton setTitle:@"Weekly" forState:UIControlStateNormal];
        [self.frequencyButton setTitle:@"Weekly" forState:UIControlStateSelected];
        [self changeButtonImage:NO button:self.repeatButton];
        [self.repeatButton setRestorationIdentifier:@""];
        [self.event setRepeat:[NSNumber numberWithBool:NO]];
        self.event.frequency = nil;
    } else {
        [self.frequencyLabel setHidden:NO];
        [self.frequencyButton setHidden:NO];
        [self changeButtonImage:YES button:self.repeatButton];
        [self.repeatButton setRestorationIdentifier:@"checked"];
        [self.event setRepeat:[NSNumber numberWithBool:YES]];
        self.event.frequency = @"Weekly";
    }
}

-(IBAction)frequencyButtonPressed:(id)sender
{
    [self.view endEditing:YES];
    [[self frequencyDelegate]setFrequencyWithValue:[self.frequencyButton.titleLabel text]];
}

-(IBAction)stepperChanged:(id)sender
{
    double val = [self.reminderStepper value];
    if (val == 0) {
        [self.reminder1Button setHidden:YES];
        [self.reminder1DeleteButton setHidden:YES];
        [self.reminder2Button setHidden:YES];
        [self.reminder2DeleteButton setHidden:YES];
        [self.reminder1Button setTitle:@"1 day" forState:UIControlStateNormal];
        [self.reminder1Button setTitle:@"1 day" forState:UIControlStateSelected];
        [self.reminder2Button setTitle:@"2 days" forState:UIControlStateNormal];
        [self.reminder2Button setTitle:@"2 days" forState:UIControlStateSelected];
    } else if (val == 1) {
        [self.reminder1Button setHidden:NO];
        [self.reminder1DeleteButton setHidden:NO];
        [self.reminder2Button setHidden:YES];
        [self.reminder2DeleteButton setHidden:YES];
        [self.reminder2Button setTitle:@"2 days" forState:UIControlStateNormal];
        [self.reminder2Button setTitle:@"2 days" forState:UIControlStateSelected];
    } else {
        [self.reminder2Button setHidden:NO];
        [self.reminder2DeleteButton setHidden:NO];
    }
}

-(IBAction)reminderButtonPressed:(id)sender
{
//    if(sender == self.reminder1Button) {
//        self.selectReminder1 = YES;
//        if([self.reminder1Button.titleLabel.text isEqualToString:@"1 day"]) {
//            [self.reminderPicker selectRow:0 inComponent:0 animated:YES];
//        } else if([self.reminder1Button.titleLabel.text isEqualToString:@"2 days"]) {
//            [self.reminderPicker selectRow:1 inComponent:0 animated:YES];
//        } else if([self.reminder1Button.titleLabel.text isEqualToString:@"1 week"]) {
//            [self.reminderPicker selectRow:2 inComponent:0 animated:YES];
//        } else if([self.reminder1Button.titleLabel.text isEqualToString:@"2 weeks"]) {
//            [self.reminderPicker selectRow:3 inComponent:0 animated:YES];
//        } else if([self.reminder1Button.titleLabel.text isEqualToString:@"1 month"]) {
//            [self.reminderPicker selectRow:4 inComponent:0 animated:YES];
//        }
//    } else {
//        self.selectReminder1 = NO;
//        if([self.reminder2Button.titleLabel.text isEqualToString:@"1 day"]) {
//            [self.reminderPicker selectRow:0 inComponent:0 animated:YES];
//        } else if([self.reminder2Button.titleLabel.text isEqualToString:@"2 days"]) {
//            [self.reminderPicker selectRow:1 inComponent:0 animated:YES];
//        } else if([self.reminder2Button.titleLabel.text isEqualToString:@"1 week"]) {
//            [self.reminderPicker selectRow:2 inComponent:0 animated:YES];
//        } else if([self.reminder2Button.titleLabel.text isEqualToString:@"2 weeks"]) {
//            [self.reminderPicker selectRow:3 inComponent:0 animated:YES];
//        } else if([self.reminder2Button.titleLabel.text isEqualToString:@"1 month"]) {
//            [self.reminderPicker selectRow:4 inComponent:0 animated:YES];
//        }
//    }
}

#pragma mark - CheckInputDelegate

-(BOOL)validAmount
{
    if([self.paymentTextField isEditing]) {
        [self.paymentTextField resignFirstResponder];
    }
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSNumber* number = [numberFormatter numberFromString:self.paymentTextField.text];
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
        [self.frequencyButton setTitle:value forState:UIControlStateNormal];
        [self.frequencyButton setTitle:value forState:UIControlStateSelected];
        self.event.frequency = value;
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
        
    } else if(textField == self.paymentTextField) {
        NSMutableString* string = [NSMutableString stringWithString:self.paymentTextField.text];
        if(string.length > 1) {
            [string replaceOccurrencesOfString:@"$"  withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0,2)];
            [self.paymentTextField setText:string];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
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
    } else if(textField == self.paymentTextField) {
        NSMutableString* string = [NSMutableString stringWithString:self.paymentTextField.text];
        if([string isEqualToString:@""] || string == nil) {
            [self.paymentTextField setText:@""];
        } else {
            self.event.amount = [[NSNumber alloc] initWithDouble:[string doubleValue]];
            [string insertString:@"$" atIndex:0];
            [self.paymentTextField setText:string];
        }
    }
}

@end
