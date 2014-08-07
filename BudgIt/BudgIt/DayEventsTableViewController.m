//
//  DayEventsViewController.m
//  BudgIt
//
//  Created by Eric L Eisner on 4/3/14.
//  Copyright (c) 2014 Eric L Eisner. All rights reserved.
//

#import "DayEventsTableViewController.h"
#import "AddEditEventViewController.h"
#import "Event.h"
#import "Deposit.h"
#import "Bill.h"
#import "Month.h"
#import "Day.h"
#import "Year.h"
#import "WeekTotal.h"
#import "MonthViewController.h"
#import "AppDelegate.h"

@interface DayEventsTableViewController ()

@end

@implementation DayEventsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)addEvent
{
    [self performSegueWithIdentifier:@"AddEditEventSegue" sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(section == 0) {
        return self.bills.count;
    } else {
        return self.deposits.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    if(indexPath.section == 0) {
        static NSString *CellIdentifier = @"Bill";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        Bill* bill= [self.bills objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",bill.name];
        cell.detailTextLabel.text = [formatter stringFromNumber:bill.amount];
        cell.detailTextLabel.textColor = [UIColor redColor];
        cell.textLabel.textColor = [UIColor lightGrayColor];
    } else {
        static NSString *CellIdentifier = @"Deposit";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        Deposit* deposit = [self.deposits objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",deposit.name];
        cell.detailTextLabel.text = [formatter stringFromNumber:deposit.amount];
        cell.textLabel.textColor = [UIColor lightGrayColor];
    }
    
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0) {
        return @"Bills";
    } else {
        return @"Payments";
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if(indexPath.section == 0) {
        for(int i = 0; i < self.bills.count; i++) {
            Bill* bill = [self.bills objectAtIndex:i];
            if([bill.name isEqualToString:cell.textLabel.text] && indexPath.row == i) {
                self.event = bill;
                [self performSegueWithIdentifier:@"EditEventSegue" sender:self];
                return;
            }
        }
    } else {
        for(int i = 0; i < self.deposits.count; i++) {
            Deposit* deposit = [self.deposits objectAtIndex:i];
            if([deposit.name isEqualToString:cell.textLabel.text] && indexPath.row == i) {
                self.event = deposit;
                [self performSegueWithIdentifier:@"EditEventSegue" sender:self];
                return;
            }
        }
    }
}

#pragma mark - AddEventsDelegate

-(void)eventAdded:(BOOL)isBill WithNullEvent:(BOOL)null WithEvent:(Event *)event WithWeekTotal:(WeekTotal *)weekTotal;
{
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray* sortedArray;
    if(isBill) {
        [self.bills addObject:event];
        sortedArray = [self.bills sortedArrayUsingDescriptors:@[sortDescriptor]];
        self.bills = [NSMutableArray arrayWithArray:sortedArray];
    } else {
        [self.deposits addObject:event];
        sortedArray = [self.deposits sortedArrayUsingDescriptors:@[sortDescriptor]];
        self.deposits = [NSMutableArray arrayWithArray:sortedArray];
    }
    
    MonthViewController* mvc = [[MonthViewController alloc] init];
    NSMutableArray* weekDays = [mvc getWeekDatesForDate:event.date];
    NSDate* startDate = [weekDays objectAtIndex:0];
    NSDate* endDate = [weekDays objectAtIndex:1];
    
    BOOL inserted = NO;
    int index = 0;
    WeekTotal* previousWeek;
    WeekTotal* nextWeek;
    int nextWeekIndex;
    for(int i = 0; i < self.weekBalances.count; i++) {
        WeekTotal* thisWeekTotal = [self.weekBalances objectAtIndex:i];
        if(i == self.weekBalances.count - 1) {
            nextWeek = nil;
        } else {
            nextWeek = [self.weekBalances objectAtIndex:i+1];
            nextWeekIndex = i+1;
        }
        // thisWeekTotal is earlier than the date to be inserted
        if([thisWeekTotal.begin compare:startDate] == NSOrderedDescending) {
            index = i;
            nextWeek = thisWeekTotal;
            nextWeekIndex = i+1;
            break;
            // dates are equal (no need to insert)
        } else if([thisWeekTotal.begin isEqualToDate:startDate]) {
            inserted = YES;
            if(isBill) {
                thisWeekTotal.netChanges = [NSNumber numberWithDouble:([thisWeekTotal.netChanges doubleValue] - [event.amount doubleValue])];
                thisWeekTotal.endBalance = [NSNumber numberWithDouble:([thisWeekTotal.endBalance doubleValue] - [event.amount doubleValue])];
            } else {
                thisWeekTotal.netChanges = [NSNumber numberWithDouble:([thisWeekTotal.netChanges doubleValue] + [event.amount doubleValue])];
                thisWeekTotal.endBalance = [NSNumber numberWithDouble:([thisWeekTotal.endBalance doubleValue] + [event.amount doubleValue])];
            }
            if(i == self.weekBalances.count - 1) {
                return;
            } else {
                previousWeek = thisWeekTotal;
                for(int j = nextWeekIndex; j < self.weekBalances.count; j++) {
                    WeekTotal* newThisWeekTotal = [self.weekBalances objectAtIndex:j];
                    if(previousWeek != nil) {
                        newThisWeekTotal.beginBalance = previousWeek.endBalance;
                    }
                    if(isBill) {
                        newThisWeekTotal.endBalance = [NSNumber numberWithDouble:([newThisWeekTotal.endBalance doubleValue] - [event.amount doubleValue])];
                    } else {
                        newThisWeekTotal.endBalance = [NSNumber numberWithDouble:([newThisWeekTotal.endBalance doubleValue] + [event.amount doubleValue])];
                    }
                    previousWeek = newThisWeekTotal;
                }
                return;
            }
        }
        // thisWeekTotal is later than the date to be inserted
        previousWeek = thisWeekTotal;
        index = i+1;
    }
    
    // insert the new object if it was greater than any objects in the weekBalances array
    // object will be inserted into array at index
    if(!inserted) {
        AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext* moc = [appDelegate managedObjectContext];
        
        WeekTotal* newWeek = [NSEntityDescription insertNewObjectForEntityForName:@"WeekTotal" inManagedObjectContext:moc];
        newWeek.begin = startDate;
        newWeek.end = endDate;
        if(previousWeek != nil) {
            newWeek.beginBalance = previousWeek.endBalance;
        } else {
            newWeek.beginBalance = 0;
        }
        newWeek.endBalance = newWeek.beginBalance;
        if(isBill) {
            newWeek.netChanges = [NSNumber numberWithDouble:-([event.amount doubleValue])];
            newWeek.endBalance = [NSNumber numberWithDouble:([newWeek.endBalance doubleValue]-[event.amount doubleValue])];
        } else {
            newWeek.netChanges = [NSNumber numberWithDouble:([event.amount doubleValue])];
            newWeek.endBalance = [NSNumber numberWithDouble:([newWeek.endBalance doubleValue]+[event.amount doubleValue])];
        }
        [self.weekBalances insertObject:newWeek atIndex:index];
        if(nextWeek != nil) {
            previousWeek = newWeek;
            for(int i = nextWeekIndex; i < self.weekBalances.count; i++) {
                WeekTotal* thisWeekTotal = [self.weekBalances objectAtIndex:i];
                if(previousWeek != nil) {
                    thisWeekTotal.beginBalance = previousWeek.endBalance;
                }
                if(isBill) {
                    thisWeekTotal.endBalance = [NSNumber numberWithDouble:([thisWeekTotal.endBalance doubleValue] - [event.amount doubleValue])];
                } else {
                    thisWeekTotal.endBalance = [NSNumber numberWithDouble:([thisWeekTotal.endBalance doubleValue] + [event.amount doubleValue])];
                }
                previousWeek = thisWeekTotal;
            }
        }
    }
    
    //    NSLog(@"Bills array:");
    //    for(Event* event in self.bills) {
    //        NSLog(@"\t%@", event);
    //    }
    //
    //    NSLog(@"Deposits array:");
    //    for(Event* event in self.deposits) {
    //        NSLog(@"\t%@", event);
    //    }
}

#pragma mark - EditEventsDelegate

-(void)eventEditted:(BOOL)isBill WithEvent:(Event *)event WithNetChange:(NSNumber *)change
{
    [self.tableView reloadData];
    MonthViewController* mvc = [[MonthViewController alloc] init];
    NSMutableArray* weekDays = [mvc getWeekDatesForDate:event.date];
    NSDate* startDate = [weekDays objectAtIndex:0];
    //NSDate* endDate = [weekDays objectAtIndex:1];
    
    NSLog(@"Event repeats (DayEventsTVC)? %hhd", [event.repeat boolValue]);
    
    WeekTotal* thisWeekTotal;
    int prevWeekIndex = 0;
    WeekTotal* previousWeek;
    WeekTotal* nextWeek;
    int nextWeekIndex;
    for(int i = 0; i < self.weekBalances.count; i++) {
        thisWeekTotal = [self.weekBalances objectAtIndex:i];
        if(i == self.weekBalances.count - 1) {
            nextWeek = nil;
        } else {
            nextWeek = [self.weekBalances objectAtIndex:i+1];
            nextWeekIndex = i+1;
        }
        // dates are equal (must be true to delete
        if([thisWeekTotal.begin isEqualToDate:startDate]) {
            thisWeekTotal.netChanges = [NSNumber numberWithDouble:([thisWeekTotal.netChanges doubleValue] + [change doubleValue])];
            thisWeekTotal.endBalance = [NSNumber numberWithDouble:([thisWeekTotal.endBalance doubleValue] + [change doubleValue])];
            if(i == self.weekBalances.count - 1) {
                break;
            } else {
                previousWeek = thisWeekTotal;
                for(int j = nextWeekIndex; j < self.weekBalances.count; j++) {
                    WeekTotal* newThisWeekTotal = [self.weekBalances objectAtIndex:j];
                    if(previousWeek != nil) {
                        newThisWeekTotal.beginBalance = previousWeek.endBalance;
                    }
                    newThisWeekTotal.endBalance = [NSNumber numberWithDouble:([newThisWeekTotal.endBalance doubleValue] + [change doubleValue])];
                    previousWeek = newThisWeekTotal;
                }
                break;
            }
        }
        // thisWeekTotal is later than the date to be inserted
        previousWeek = thisWeekTotal;
        prevWeekIndex += 1;
    }
}

#pragma mark - DeleteEventsDelegate

-(void)eventDeleted:(BOOL)isBill WithEvent:(Event *)event
{
    if(isBill) {
        for(Event* myEvent in self.bills) {
            if(myEvent == event) {
                [self.bills removeObject:event];
                break;
            }
        }
    } else {
        for(Event* myEvent in self.deposits) {
            if(myEvent == event) {
                [self.deposits removeObject:event];
                break;
            }
        }
    }
    
    [self.tableView reloadData];
    
    MonthViewController* mvc = [[MonthViewController alloc] init];
    NSMutableArray* weekDays = [mvc getWeekDatesForDate:event.date];
    NSDate* startDate = [weekDays objectAtIndex:0];
    //NSDate* endDate = [weekDays objectAtIndex:1];
    
    WeekTotal* thisWeekTotal;
    BOOL inserted = NO;
    int prevWeekIndex = 0;
    WeekTotal* previousWeek;
    WeekTotal* nextWeek;
    int nextWeekIndex;
    for(int i = 0; i < self.weekBalances.count; i++) {
        thisWeekTotal = [self.weekBalances objectAtIndex:i];
        if(i == self.weekBalances.count - 1) {
            nextWeek = nil;
        } else {
            nextWeek = [self.weekBalances objectAtIndex:i+1];
            nextWeekIndex = i+1;
        }
        // dates are equal (must be true to delete
        if([thisWeekTotal.begin isEqualToDate:startDate]) {
            inserted = YES;
            if(isBill) {
                thisWeekTotal.netChanges = [NSNumber numberWithDouble:([thisWeekTotal.netChanges doubleValue] + [event.amount doubleValue])];
                thisWeekTotal.endBalance = [NSNumber numberWithDouble:([thisWeekTotal.endBalance doubleValue] + [event.amount doubleValue])];
            } else {
                thisWeekTotal.netChanges = [NSNumber numberWithDouble:([thisWeekTotal.netChanges doubleValue] - [event.amount doubleValue])];
                thisWeekTotal.endBalance = [NSNumber numberWithDouble:([thisWeekTotal.endBalance doubleValue] - [event.amount doubleValue])];
            }
            if(i == self.weekBalances.count - 1) {
                break;
            } else {
                previousWeek = thisWeekTotal;
                for(int j = nextWeekIndex; j < self.weekBalances.count; j++) {
                    WeekTotal* newThisWeekTotal = [self.weekBalances objectAtIndex:j];
                    if(previousWeek != nil) {
                        newThisWeekTotal.beginBalance = previousWeek.endBalance;
                    }
                    if(isBill) {
                        newThisWeekTotal.endBalance = [NSNumber numberWithDouble:([newThisWeekTotal.endBalance doubleValue] + [event.amount doubleValue])];
                    } else {
                        newThisWeekTotal.endBalance = [NSNumber numberWithDouble:([newThisWeekTotal.endBalance doubleValue] - [event.amount doubleValue])];
                    }
                    previousWeek = newThisWeekTotal;
                }
                break;
            }
        }
        // thisWeekTotal is later than the date to be inserted
        previousWeek = thisWeekTotal;
        prevWeekIndex += 1;
    }
    
//    if(thisWeekTotal.netChanges == [NSNumber numberWithInt:0]) {
//        WeekTotal* prevWeek;
//        if(prevWeekIndex > 0) {
//            prevWeek = [self.weekBalances objectAtIndex:prevWeekIndex-1];
//        }
//    }
    
//    WeekTotal* prevWeek = [self.weekBalances objectAtIndex:prevWeekIndex-1];
//    NSLog(@"Prev week:\t %@ - %@, begin = %f, change = %f, end = %f", prevWeek.begin, prevWeek.end, [prevWeek.beginBalance doubleValue], [prevWeek.netChanges doubleValue], [prevWeek.endBalance doubleValue]);
//    NSLog(@"This week: \t %@ - %@, begin = %f, change = %f, end = %f", thisWeekTotal.begin, thisWeekTotal.end, [thisWeekTotal.beginBalance doubleValue], [thisWeekTotal.netChanges doubleValue], [thisWeekTotal.endBalance doubleValue]);
//    NSLog(@"Next week\t %@ - %@, begin = %f, change = %f, end = %f", nextWeek.begin, nextWeek.end, [nextWeek.beginBalance doubleValue], [nextWeek.netChanges doubleValue], [nextWeek.endBalance doubleValue]);
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"AddEditEventSegue"]) {
        AddEditEventViewController* dest = [segue destinationViewController];
        dest.addDelegate = self;
        dest.navigationItem.title = @"Add Event";
        
        NSString* str = [NSString stringWithFormat:@"%u %i %i",self.month.name,(int)self.day.number,(int)self.year.number];
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM dd yyyy"];
        NSTimeZone* timeZone = [NSTimeZone localTimeZone];
        [dateFormatter setTimeZone:timeZone];
        NSDate *date = [dateFormatter dateFromString:str];
        
        NSCalendar* gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents* comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
        
        dest.dateFromVC = [gregorian dateFromComponents:comp];
    } else if([segue.identifier isEqualToString:@"EditEventSegue"]) {
        AddEditEventViewController* dest = [segue destinationViewController];
        dest.editDelegate = self;
        dest.deleteDelegate = self;
        dest.event = self.event;
        NSLog(@"Event repeats? %@", dest.event.repeat);
        dest.navigationItem.title = @"Edit Event";
        dest.isEdit = YES;
    }
}

@end
