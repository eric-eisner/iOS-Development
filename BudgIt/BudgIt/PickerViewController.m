//
//  PickerViewController.m
//  BudgIt
//
//  Created by Eric Eisner on 6/19/14.
//  Copyright (c) 2014 Eric L Eisner. All rights reserved.
//

#import "PickerViewController.h"

@interface PickerViewController ()
@property(nonatomic, strong) NSArray* frequencyValues;
@property(nonatomic, strong) NSArray* reminderValues;
@end

@implementation PickerViewController

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
    
    self.frequencyValues = [[NSArray alloc] initWithObjects:@"Weekly", @"Bi-Weekly", @"Monthly", @"Bi-Monthly", @"Yearly", nil];
    self.reminderValues = [[NSArray alloc] initWithObjects:@"1 day", @"2 days", @"1 week", @"2 weeks", @"1 month", nil];
    
    NSString* closeButtonPath = [[NSBundle mainBundle] pathForResource:@"closebutton" ofType:@"png"];
    NSString* closeButtonHighlightedPath = [[NSBundle mainBundle] pathForResource:@"closebutton-highlighted" ofType:@"png"];
    
    [self.closeButton setImage:[UIImage imageWithContentsOfFile:closeButtonPath] forState:UIControlStateNormal];
    [self.closeButton setImage:[UIImage imageWithContentsOfFile:closeButtonHighlightedPath] forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)closeWindow
{
    [[self pickerDelegate] pickerValueChoosen:self.isReminder WithValue:self.value];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIPickerViewDataSource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(!self.isReminder) {
        return self.frequencyValues.count;
    } else {
        return self.reminderValues.count;
    }
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(!self.isReminder) {
        return self.frequencyValues[row];
    } else {
        return self.reminderValues[row];
    }
}

#pragma mark - UIPickerViewDelegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(!self.isReminder) {
        self.value = self.frequencyValues[row];
    } else {
        self.value = self.reminderValues[row];
    }
    [[self pickerDelegate] pickerValueChoosen:self.isReminder WithValue:self.value];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
