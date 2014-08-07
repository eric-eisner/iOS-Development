//
//  MonthViewController.m
//  BudgIt
//
//  Created by Eric L Eisner on 4/3/14.
//  Copyright (c) 2014 Eric L Eisner. All rights reserved.
//

#import "AppDelegate.h"
#import "MonthViewController.h"
#import "AddEditEventViewController.h"
#import "YearViewController.h"
#import "DayEventsTableViewController.h"
#import "Day.h"
#import "Month.h"
#import "Year.h"
#import "Event.h"
#import "Bill.h"
#import "Deposit.h"
#import "WeekTotal.h"
#import "CalendarView.h"
#import "SettingsTableViewController.h"

@interface MonthViewController ()
@property(nonatomic, strong) UIButton* todayButton;
@property(nonatomic, strong) NSMutableArray* bills;
@property(nonatomic, strong) NSMutableArray* deposits;
@property(nonatomic, strong) NSMutableArray* weekBalances;
@property(nonatomic, strong) NSDate* todayDate;
@property(nonatomic) int todayInt;
@property(nonatomic, strong) NSString* todayDayOfWeek;
@property(nonatomic, strong) NSDate* firstDayOfMonthDate;
@property(nonatomic, strong) NSDate* lastDayOfMonthDate;
@property(nonatomic, strong) NSString* firstDayName;
@property(nonatomic, strong) NSString* lastDayName;
@end

@implementation MonthViewController

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
    self.bills = [[NSMutableArray alloc] init];
    self.deposits = [[NSMutableArray alloc] init];
    
    UIBarButtonItem* settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(settings)];
    NSString* settingsButtonImagePath = [[NSBundle mainBundle] pathForResource:@"gears" ofType:@"png"];
    [settingsButton setImage:[UIImage imageWithContentsOfFile:settingsButtonImagePath]];
    self.navigationItem.rightBarButtonItems = @[self.addItemButton,settingsButton];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:[NSDate date]];
    self.currentDay = [[Day alloc] initWithNumber:[components day]];
    self.day = [[Day alloc] initWithNumber:[components day]];
    self.currentMonth = [[Month alloc] initWithNumber:[components month]];
    self.month = [[Month alloc] initWithNumber:[components month]];
    self.currentYear = [[Year alloc] initWithNumber:[components year]];
    self.year = [[Year alloc] initWithNumber:[components year]];
    
    self.todayCircle = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
    NSString* todayCirclePath = [[NSBundle mainBundle] pathForResource:@"todaycircle" ofType:@"png"];
    [self.todayCircle setImage:[[UIImage alloc] initWithContentsOfFile:todayCirclePath]];
    [self.calendarView addSubview:self.todayCircle];
    
    NSString* balancesBackgroundImagePath = [[NSBundle mainBundle] pathForResource:@"iosgrid" ofType:@"png"];
    UIColor* background = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:balancesBackgroundImagePath]];
    [self.balanceView setBackgroundColor:background];
    
    NSString* str = [NSString stringWithFormat:@"%u %i %i",self.month.name,self.day.number,self.year.number];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM dd yyyy"];
    NSTimeZone* timeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:timeZone];
    NSDate *date = [dateFormatter dateFromString:str];
    
    NSCalendar* gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    
    self.todayDate = [gregorian dateFromComponents:comp];
    
    [dateFormatter setDateFormat:@"EEEE"];
    self.todayDayOfWeek = [dateFormatter stringFromDate:self.todayDate];
    [dateFormatter setDateFormat:@"dd"];
    self.todayInt = [[dateFormatter stringFromDate:self.todayDate] intValue];
    
    [self drawCalendar];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.bills = [self getEventsForMonth:self.month EventType:YES];
    self.deposits = [self getEventsForMonth:self.month EventType:NO];
    self.weekBalances = [self getWeekBalance];
    
    [self getWeekData];
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

-(IBAction)monthClicked
{
    [self performSegueWithIdentifier:@"YearSegue" sender:self];
}

-(BOOL)isCurrentMonth{
    if(self.day.number == self.currentDay.number && self.month.name == self.currentMonth.name && self.year.number == self.currentYear.number) {
        return true;
    }
    return false;
}

-(IBAction)todayClicked
{
    if((self.year.number > self.currentYear.number) || (self.month.name > self.currentMonth.name)){
        [self flipFromLeft];
    } else if((self.year.number < self.currentYear.number) || (self.month.name < self.currentMonth.name)) {
        [self flipFromRight];
    }
    
    if([self isCurrentMonth]) {
        self.todayCircle.hidden = NO;
    } else {
        self.month.name = self.currentMonth.name;
        self.day.number = self.currentDay.number;
        self.year.number = self.currentYear.number;
        self.todayCircle.hidden = NO;
    }
    [self drawCalendar];
}

-(IBAction)dayClicked:(UIButton*)sender
{
    if([[sender restorationIdentifier] isEqualToString:@"disabled"]) {
        if([sender.titleLabel.text integerValue] > 15) {
            [self decrementMonth];
        } else {
            [self incrementMonth];
        }
    } else {
        self.day.number = [sender.titleLabel.text intValue];
        [self performSegueWithIdentifier:@"DayEventsSegue" sender:sender];
    }
}

-(IBAction)weeklyBalancesTapped:(id)sender
{
    UIView* myView = (UIView*)sender;
    myView.layer.borderWidth = 1.0;
    myView.layer.borderColor = [UIColor blackColor].CGColor;
}

-(void)settings
{
    [self performSegueWithIdentifier:@"SettingsSegue" sender:self];
}

// Set the title and todayCircle if the month of the view is the same as the current month
-(void)drawCalendar
{
    [self getDaysOfTheMonth];
    
    if(self.month.name != self.currentMonth.name || self.year.number != self.currentYear.number) {
        self.todayCircle.hidden = YES;
    } else {
        self.todayCircle.hidden = NO;
        int x = self.todayButton.frame.origin.x + 5;
        int y = self.todayButton.frame.origin.y + 5;
        //NSLog(@"%f, %f", self.todayButton.frame.origin.x, self.todayButton.frame.origin.y);
        self.todayCircle.frame = CGRectMake(x, y, self.todayCircle.frame.size.width, self.todayCircle.frame.size.height);
        //NSLog(@"%f, %f", self.todayCircle.frame.origin.x, self.todayCircle.frame.origin.y);
    }
    [self.monthYearTitle setTitle:[NSString stringWithFormat:@"%@ %i", [self.month getStringName], (int)[self.year number]] forState:UIControlStateNormal];
}

-(void)getWeekData
{
    NSMutableArray* dates = [self getWeekDatesForDate:self.todayDate];
    NSDate* startDate = [dates objectAtIndex:0];
    //NSDate* endDate = [dates objectAtIndex:1];
    
    NSLog(@"The weekly balances:");
    for(WeekTotal* total in self.weekBalances) {
        NSLog(@"\t %@ - %@, begin = %f, change = %f, end = %f", total.begin, total.end, [total.beginBalance doubleValue], [total.netChanges doubleValue], [total.endBalance doubleValue]);
    }
    
    if(self.weekBalances.count == 0) {
        self.previousBalanceLabel.text = @"$0.00";
        self.weekNetChangesLabel.text = @"$0.00";
        self.thisWeekBalanceLabel.text = @"$0.00";
        return;
    }
    
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    BOOL weekFound = NO;
    for(int i = 0; i < self.weekBalances.count; i++) {
        WeekTotal* weekTotal = [self.weekBalances objectAtIndex:i];
        if([weekTotal.begin isEqualToDate:startDate]) {
            weekFound = YES;
            self.previousBalanceLabel.text = [formatter stringFromNumber:weekTotal.beginBalance];
            if([weekTotal.beginBalance doubleValue] < 0) {
                [self.previousBalanceLabel setTextColor:[UIColor redColor]];
            } else {
                [self.previousBalanceLabel setTextColor:[UIColor blackColor]];
            }
            self.weekNetChangesLabel.text = [formatter stringFromNumber:weekTotal.netChanges];
            if([weekTotal.netChanges doubleValue] < 0) {
                [self.weekNetChangesLabel setTextColor:[UIColor redColor]];
            } else {
                [self.weekNetChangesLabel setTextColor:[UIColor blackColor]];
            }
            self.thisWeekBalanceLabel.text = [formatter stringFromNumber:weekTotal.endBalance];
            if([weekTotal.endBalance doubleValue] < 0) {
                [self.thisWeekBalanceLabel setTextColor:[UIColor redColor]];
            } else {
                [self.thisWeekBalanceLabel setTextColor:[UIColor blackColor]];
            }
            return;
        }
    }
    
    if(!weekFound) {
        AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext* moc = [appDelegate managedObjectContext];
        Event* event = [NSEntityDescription insertNewObjectForEntityForName:@"Bill" inManagedObjectContext:moc];
        event.date = self.todayDate;
        event.amount = 0;
        event.name = @"";
        [self eventAdded:NO WithNullEvent:YES WithEvent:event WithWeekTotal:nil];
        [moc deleteObject:event];
        [self getWeekData];
    }
}

-(IBAction)incrementMonth
{
    [self flipFromRight];
    if(self.month.name != 12) {
        self.month.name = self.month.name + 1;
        [self drawCalendar];
    } else {
        self.year.number = self.year.number + 1;
        self.month.name = 1;
        [self drawCalendar];
    }
}

-(IBAction)decrementMonth
{
    [self flipFromLeft];
    if(self.month.name != 1) {
        self.month.name = self.month.name - 1;
        [self drawCalendar];
    } else {
        self.year.number = self.year.number - 1;
        self.month.name = 12;
        [self drawCalendar];
    }
}

-(void)doTransitionWithType:(UIViewAnimationOptions)animationTransitionType
{
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"CalendarView" owner:self options:nil];
    CalendarView *mainView = [subviewArray objectAtIndex:0];
    mainView.frame = self.calendarView.frame;

    [UIView transitionFromView:self.calendarView toView:mainView duration:0.5 options:animationTransitionType completion:^(BOOL finished){/*[self.calendarView removeFromSuperview];*/}];
    [self.view addSubview:mainView];
    //[self.view sendSubviewToBack:self.calendarView];
    self.calendarView = mainView;
    [self.calendarView addSubview:self.todayCircle];
}


-(void)flipFromLeft
{
    [self doTransitionWithType:UIViewAnimationOptionTransitionFlipFromLeft];
    
}
-(void)flipFromRight
{
    [self doTransitionWithType:UIViewAnimationOptionTransitionFlipFromRight];
    
}
                 
-(void)getDaysOfTheMonth
{
    NSString* str = [NSString stringWithFormat:@"%u %i %i",self.month.name,1,(int)self.year.number];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM dd yyyy"];
    NSTimeZone* timeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:timeZone];
    NSDate *date = [dateFormatter dateFromString:str];
    
    NSCalendar* gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    
    [dateFormatter setDateFormat:@"dd"];
    
    [comp setDay:1];
    
    self.firstDayOfMonthDate = [gregorian dateFromComponents:comp];
    //int firstDayOfMonth = [[dateFormatter stringFromDate:firstDayOfMonthDate] intValue];
    //NSLog(@"First day of this month is %i", firstDayOfMonth);
    
    [comp setDay:0];
    
    NSDate* lastDayOfPreviousMonthDate = [gregorian dateFromComponents:comp];
    int lastDayOfPreviousMonth = [[dateFormatter stringFromDate:lastDayOfPreviousMonthDate] intValue];
    //NSLog(@"Last day of previous month is %i", lastDayOfPreviousMonth);
    
    [comp setMonth:[comp month]+1];
    
    self.lastDayOfMonthDate = [gregorian dateFromComponents:comp];
    int lastDayOfMonth = [[dateFormatter stringFromDate:self.lastDayOfMonthDate] intValue];
    //NSLog(@"Last day of this month is %i", lastDayOfMonth);
    
    [comp setDay:1];
    
    //NSDate* firstDayOfNextMonthDate = [gregorian dateFromComponents:comp];
    //int firstDayOfNextMonth = [[dateFormatter stringFromDate:firstDayOfNextMonthDate] intValue];
    //NSLog(@"First day of next month is %i", firstDayOfNextMonth);
    
    comp = [gregorian components:NSDayCalendarUnit fromDate:self.firstDayOfMonthDate toDate:self.lastDayOfMonthDate options:0];
    //NSLog(@"Days between first day of this month and the last day is %i", [comp day]);
    
    [dateFormatter setDateFormat:@"EEEE"];
    
    self.firstDayName = [dateFormatter stringFromDate:self.firstDayOfMonthDate];
    //NSLog(@"First day lies on a %@", self.firstDayName);
    self.lastDayName = [dateFormatter stringFromDate:self.lastDayOfMonthDate];
    //NSLog(@"Last day lies on a %@", self.lastDayName);
    
    [dateFormatter setDateFormat:@"dd"];
    UIButton* button;
    int buttonIndex = 0;
    int daysInPreviousMonth = -1;
    if([self.firstDayName isEqualToString:@"Sunday"]) {
        
    } else if([self.firstDayName isEqualToString:@"Monday"]) {
        daysInPreviousMonth = 0;
    } else if([self.firstDayName isEqualToString:@"Tuesday"]) {
        daysInPreviousMonth = 1;
    } else if([self.firstDayName isEqualToString:@"Wednesday"]) {
        daysInPreviousMonth = 2;
    } else if([self.firstDayName isEqualToString:@"Thursday"]) {
        daysInPreviousMonth = 3;
    } else if([self.firstDayName isEqualToString:@"Friday"]) {
        daysInPreviousMonth = 4;
    } else if([self.firstDayName isEqualToString:@"Saturday"]) {
        daysInPreviousMonth = 5;
    } else {
        NSLog(@"An error occured in drawing the calendar.");
        abort();
    }
    for(int i = lastDayOfPreviousMonth-daysInPreviousMonth; i<=lastDayOfPreviousMonth; i++) {
        button = [self.days objectAtIndex:buttonIndex];
        [button setTitle:[NSString stringWithFormat:@"%i", i] forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0xCDCDCD) forState:UIControlStateNormal];
        [button setRestorationIdentifier:@"disabled"];
        buttonIndex++;
    }
    for(int day = 1; day<=lastDayOfMonth; day++) {
        button = [self.days objectAtIndex:buttonIndex];
        [button setTitle:[NSString stringWithFormat:@"%i", day] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setRestorationIdentifier:@""];
        if(self.todayInt == day && [self isCurrentMonth]) {
            self.todayButton = button;
            //NSLog(@"button frame: %f, %f", button.frame.origin.x, button.frame.origin.y);
        }
        buttonIndex++;
    }
    for(int i = 1; buttonIndex<self.days.count; i++) {
        button = [self.days objectAtIndex:buttonIndex];
        [button setTitle:[NSString stringWithFormat:@"%i", i] forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0xCDCDCD) forState:UIControlStateNormal];
        [button setRestorationIdentifier:@"disabled"];
        buttonIndex++;
    }
}

-(NSMutableArray *)getEventsForMonth:(Month *)month EventType:(BOOL)isBill
{
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* moc = [appDelegate managedObjectContext];
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription* entity;
    if(isBill) {
        entity = [NSEntityDescription entityForName:@"Bill" inManagedObjectContext:moc];
    } else {
        entity = [NSEntityDescription entityForName:@"Deposit" inManagedObjectContext:moc];
    }
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor* sortByDate = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortByDate]];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"date >= %@ AND date <= %@", self.firstDayOfMonthDate, self.lastDayOfMonthDate];
    [fetchRequest setPredicate:predicate];
    
    NSError* error = nil;
    NSMutableArray* fetchResults = [NSMutableArray arrayWithArray:[moc executeFetchRequest:fetchRequest error:&error]];
    
    if(!fetchResults) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    return fetchResults;
}

-(NSMutableArray *)getEventsForDay:(Day *)day EventType:(BOOL)isBill
{
    NSString* str = [NSString stringWithFormat:@"%u %i %i",self.month.name,(int)self.day.number,(int)self.year.number];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM dd yyyy"];
    NSTimeZone* timeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:timeZone];
    NSDate* date = [dateFormatter dateFromString:str];
    
    NSCalendar* gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    
    [comp setDay:[comp day]-1];
    NSDate* previousDay = [gregorian dateFromComponents:comp];
    [comp setDay:[comp day]+2];
    NSDate* nextDay = [gregorian dateFromComponents:comp];
    
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* moc = [appDelegate managedObjectContext];
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription* entity;
    if(isBill) {
        entity = [NSEntityDescription entityForName:@"Bill" inManagedObjectContext:moc];
    } else {
        entity = [NSEntityDescription entityForName:@"Deposit" inManagedObjectContext:moc];
    }
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor* sortByDate = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortByDate]];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"date > %@ AND date < %@", previousDay, nextDay];
    [fetchRequest setPredicate:predicate];
    
    NSError* error = nil;
    NSMutableArray* fetchResults = [NSMutableArray arrayWithArray:[moc executeFetchRequest:fetchRequest error:&error]];
    
    if(!fetchResults) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    return fetchResults;
}

-(NSMutableArray *)getWeekBalance
{
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* moc = [appDelegate managedObjectContext];
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription* entity;
    
    entity = [NSEntityDescription entityForName:@"WeekTotal" inManagedObjectContext:moc];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor* sortByDate = [[NSSortDescriptor alloc] initWithKey:@"begin" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortByDate]];
    
    NSError* error = nil;
    NSMutableArray* fetchResults = [NSMutableArray arrayWithArray:[moc executeFetchRequest:fetchRequest error:&error]];
    
    if(!fetchResults) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    return fetchResults;
}

// Returns the Sunday start date and Saturday end date for the week which the date is included in
-(NSMutableArray *)getWeekDatesForDate:(NSDate *)date
{
    NSCalendar* gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"EEEE"];
    NSString* dateDayOfWeek = [dateFormatter stringFromDate:date];
    
    int startDay;
    int endDay;
    if([dateDayOfWeek isEqualToString:@"Sunday"]) {
        startDay = 0;
        endDay = 6;
    } else if([dateDayOfWeek isEqualToString:@"Monday"]) {
        startDay = 1;
        endDay = 5;
    } else if([dateDayOfWeek isEqualToString:@"Tuesday"]) {
        startDay = 2;
        endDay = 4;
    } else if([dateDayOfWeek isEqualToString:@"Wednesday"]) {
        startDay = 3;
        endDay = 3;
    } else if([dateDayOfWeek isEqualToString:@"Thursday"]) {
        startDay = 4;
        endDay = 2;
    } else if([dateDayOfWeek isEqualToString:@"Friday"]) {
        startDay = 5;
        endDay = 1;
    } else {
        startDay = 6;
        endDay = 0;
    }
    
    [comp setDay:[comp day] - startDay];
    NSDate* sunday = [gregorian dateFromComponents:comp];
    //NSLog(@"First day of the week is %@", sunday);
    
    comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    
    [comp setDay:[comp day] + endDay];
    NSDate* saturday = [gregorian dateFromComponents:comp];
    //NSLog(@"Last day of the week is %@", saturday);
    
    NSMutableArray* weekDates = [NSMutableArray arrayWithObjects:sunday, saturday, nil];
    return weekDates;
}

#pragma mark - YearViewControllerDelegate
-(void)selectedDate
{
    [self drawCalendar];
}

#pragma mark - AddEventsDelegate

-(void)eventAdded:(BOOL)isBill WithNullEvent:(BOOL)null WithEvent:(Event *)event WithWeekTotal:(WeekTotal *)weekTotal;
{
    if(!null) {
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
    }
    
    NSMutableArray* weekDays = [self getWeekDatesForDate:event.date];
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

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"AddEditEventSegue"]) {
        AddEditEventViewController* dest = [segue destinationViewController];
        dest.addDelegate = self;
        dest.weekBalances = self.weekBalances;
        dest.navigationItem.title = @"Add Event";
    } else if([segue.identifier isEqualToString:@"YearSegue"]) {
        YearViewController* dest = [segue destinationViewController];
        dest.month = self.month;
        dest.year = self.year;
        dest.delegate = self;
    } else if([segue.identifier isEqualToString:@"DayEventsSegue"]) {
        DayEventsTableViewController* dest = [segue destinationViewController];
        dest.day = self.day;
        dest.month = self.month;
        dest.year = self.year;
        dest.bills = [self getEventsForDay:self.day EventType:YES];
        dest.deposits = [self getEventsForDay:self.day EventType:NO];
        dest.weekBalances = self.weekBalances;
        dest.navigationItem.title = [NSString stringWithFormat:@"%@ %i, %i", self.month.getStringName, (int)self.day.number, (int)self.year.number];
    } else if([segue.identifier isEqualToString:@"SettingsSegue"]) {
        SettingsTableViewController* dest = [segue destinationViewController];
        dest.navigationItem.title = @"Settings";
    }
}

@end
