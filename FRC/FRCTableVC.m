//
//  FRCTableVC.m
//  FRC
//
//  Copyright (c) 2014 SampleFRC. All rights reserved.
//

#import "FRCTableVC.h"
#import "AppDelegate.h"
#import "Meeting.h"

@interface FRCTableVC () <NSFetchedResultsControllerDelegate>

@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic) NSFetchedResultsController *sectionTodayFRC;
@property (nonatomic) NSFetchedResultsController *sectionUpcomingFRC;
@property (nonatomic) NSFetchedResultsController *sectionPastFRC;

@property (nonatomic) NSUInteger numberOfSectionsInTV;


@end

@implementation FRCTableVC

-(NSManagedObjectContext *)getManagedObjectContext
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    return self.managedObjectContext;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!self.managedObjectContext) [self getManagedObjectContext];
    [self fetchData];

}

-(void)fetchData
{
    [self.sectionUpcomingFRC performFetch:nil];
    if ([[self.sectionUpcomingFRC fetchedObjects]count] > 0)
    {
        self.numberOfSectionsInTV = self.numberOfSectionsInTV + 1;
    }
    
    [self.sectionTodayFRC performFetch:nil];
    
    if ([[self.sectionTodayFRC fetchedObjects]count] > 0)
    {
        self.numberOfSectionsInTV = self.numberOfSectionsInTV + 1;
    }
    
    [self.sectionPastFRC performFetch:nil];
    if ([[self.sectionPastFRC fetchedObjects]count] > 0)
    {
        self.numberOfSectionsInTV = self.numberOfSectionsInTV + 1;
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    self.numberOfSectionsInTV =0;
    if (([[self.sectionTodayFRC fetchedObjects]count]>0) && ([[self.sectionUpcomingFRC fetchedObjects]count]>0) && ([[self.sectionPastFRC fetchedObjects]count]>0))
    {
        self.numberOfSectionsInTV = 3;
    }
    else if ((([[self.sectionTodayFRC fetchedObjects]count]>0) && ([[self.sectionUpcomingFRC fetchedObjects]count]>0) && ([[self.sectionPastFRC fetchedObjects]count]== 0)) ||
             (([[self.sectionTodayFRC fetchedObjects]count]>0) && ([[self.sectionUpcomingFRC fetchedObjects]count]==0) && ([[self.sectionPastFRC fetchedObjects]count]> 0)) ||
             (([[self.sectionTodayFRC fetchedObjects]count]==0) && ([[self.sectionUpcomingFRC  fetchedObjects]count]>0) && ([[self.sectionUpcomingFRC fetchedObjects]count]>0)))
    {
         self.numberOfSectionsInTV = 2;
    }
    else if ((([[self.sectionTodayFRC fetchedObjects]count]>0) && ([[self.sectionUpcomingFRC fetchedObjects]count]==0) && ([[self.sectionPastFRC fetchedObjects]count]== 0)) ||
             (([[self.sectionTodayFRC fetchedObjects]count]==0) && ([[self.sectionUpcomingFRC fetchedObjects]count]==0) && ([[self.sectionPastFRC fetchedObjects]count]> 0)) ||
             (([[self.sectionTodayFRC fetchedObjects]count]==0) && ([[self.sectionUpcomingFRC  fetchedObjects]count]>0) && ([[self.sectionUpcomingFRC fetchedObjects]count]==0)))
    {
       self.numberOfSectionsInTV = 1;
    }
    return self.numberOfSectionsInTV;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    switch (section) {
        case 0:
        {
            if ([[self.sectionTodayFRC fetchedObjects]count]>0)
            {
                rows = [[self.sectionTodayFRC fetchedObjects]count];
                break;
            }
            else if ([[self.sectionUpcomingFRC fetchedObjects]count]>0)
            {
                rows = [[self.sectionUpcomingFRC fetchedObjects]count];
                break;
            }
            else if ([[self.sectionPastFRC fetchedObjects]count]>0)
            {
                rows = [[self.sectionPastFRC fetchedObjects]count];
                break;
            }
        }
        case 1:
        {
            if ([[self.sectionUpcomingFRC fetchedObjects]count]>0)
            {
                rows = [[self.sectionUpcomingFRC fetchedObjects]count];
                break;
            }
            else if ([[self.sectionPastFRC fetchedObjects]count]>0)
            {
                rows = [[self.sectionPastFRC fetchedObjects]count];
                break;
            }
        }
        case 2:
        {
            if ([[self.sectionPastFRC fetchedObjects]count]>0)
            {
                rows = [[self.sectionPastFRC fetchedObjects]count];
                break;
            }
        }
    }
    NSLog(@"Section Number: %i Number Of Rows: %i", section,rows);
    return rows;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog (@"inside commiting changesyes");
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier];
    }
    Meeting *meeting;
    switch (indexPath.section) {
        case 0:
            if ([[self.sectionTodayFRC fetchedObjects]count] > 0)
            {
                meeting = [[self.sectionTodayFRC fetchedObjects] objectAtIndex:indexPath.row];            }
            else if ([[self.sectionUpcomingFRC fetchedObjects]count] > 0)
            {
                meeting = [[self.sectionUpcomingFRC fetchedObjects] objectAtIndex:indexPath.row];
            }
            else if ([[self.sectionPastFRC fetchedObjects]count] > 0)
            {
                meeting = [[self.sectionPastFRC fetchedObjects] objectAtIndex:indexPath.row];
            }
        break;

        case 1:
            if ([[self.sectionUpcomingFRC fetchedObjects]count] > 0)
            {
                meeting = [[self.sectionUpcomingFRC fetchedObjects] objectAtIndex:indexPath.row];
            }
            else if ([[self.sectionPastFRC fetchedObjects]count] > 0)
            {
                meeting = [[self.sectionPastFRC fetchedObjects] objectAtIndex:indexPath.row];
            }
        break;
            
        case 2:
            if ([[self.sectionPastFRC fetchedObjects]count] > 0)
            {
                meeting = [[self.sectionPastFRC fetchedObjects] objectAtIndex:indexPath.row];
            }
        break;
    }
    
    cell.textLabel.text = meeting.title;
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *header;
    switch (section) {
        case 0:
        {
            if ([[self.sectionTodayFRC fetchedObjects]count] >0)
            {
                header = @"Today";
            }
            else if ([[self.sectionUpcomingFRC fetchedObjects]count] >0)
            {
                header = @"Upcoming";
            }
            else if ([[self.sectionPastFRC fetchedObjects]count] >0)
            {
                header = @"Past";
            }
            break;
        }
        case 1:
        {
            if ([[self.sectionTodayFRC fetchedObjects]count] >0)
            {
                header = @"Upcoming";
            }
            else if ([[self.sectionUpcomingFRC fetchedObjects]count] >0)
            {
                header = @"Past";
            }
            break;
        }
        case 2:
        {
            if ([[self.sectionPastFRC fetchedObjects]count] >0)
            {
                header = @"Past";
            }
            break;
        }

    }
    
    return  header;
}


- (NSFetchedResultsController *)sectionTodayFRC
{
    if(_sectionTodayFRC!=nil)
    {
        return  _sectionTodayFRC;
    }
    
    if (!self.managedObjectContext)
    {
        self.managedObjectContext = [self getManagedObjectContext];
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Meeting"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *firstSort = [[NSSortDescriptor alloc] initWithKey:@"startDate"
                                                              ascending:YES];
    
    
    [fetchRequest setSortDescriptors:@[firstSort]];
    
    NSPredicate *subPredToday = [NSPredicate predicateWithFormat:@"(startDate >= %@) AND (startDate <= %@)", [self beginningOfDay], [self endOfDay]];
    [fetchRequest setPredicate:subPredToday];
    
    _sectionTodayFRC = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest
                                                                   managedObjectContext:self.managedObjectContext
                                                                     sectionNameKeyPath:nil
                                                                              cacheName:nil];
    _sectionTodayFRC.delegate = self;
    return _sectionTodayFRC;
}

- (NSFetchedResultsController *)sectionUpcomingFRC
{
    if(_sectionUpcomingFRC!=nil)
    {
        return  _sectionUpcomingFRC;
    }
    
    if (!self.managedObjectContext)
    {
        self.managedObjectContext = [self getManagedObjectContext];
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Meeting"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *firstSort = [[NSSortDescriptor alloc] initWithKey:@"startDate"
                                                              ascending:YES];

    
    [fetchRequest setSortDescriptors:@[firstSort]];

    NSPredicate *subPredFuture = [NSPredicate predicateWithFormat:@"startDate > %@", [self endOfDay]];
    [fetchRequest setPredicate:subPredFuture];
    
    _sectionUpcomingFRC = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest
                                                                   managedObjectContext:self.managedObjectContext
                                                                     sectionNameKeyPath:nil
                                                                              cacheName:nil];
    _sectionUpcomingFRC.delegate = self;
    return _sectionUpcomingFRC;
}
- (NSFetchedResultsController *)sectionPastFRC
{
    if(_sectionPastFRC!=nil)
    {
        return  _sectionPastFRC;
    }
    
    if (!self.managedObjectContext)
    {
        self.managedObjectContext = [self getManagedObjectContext];
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Meeting"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *firstSort = [[NSSortDescriptor alloc] initWithKey:@"startDate"
                                                              ascending:YES];
    
    
    [fetchRequest setSortDescriptors:@[firstSort]];
    NSPredicate *subPredPast = [NSPredicate predicateWithFormat:@"startDate < %@", [self beginningOfDay]];
    [fetchRequest setPredicate:subPredPast];
    
    _sectionPastFRC = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest
                                                         managedObjectContext:self.managedObjectContext
                                                           sectionNameKeyPath:nil
                                                                    cacheName:nil];
    _sectionPastFRC.delegate = self;
    return _sectionPastFRC;
}

- (NSDate *)beginningOfDay
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:now];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    int timeZoneOffset = [destinationTimeZone secondsFromGMTForDate:now] / 3600;
    [components setHour:timeZoneOffset];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *beginningOfDay = [calendar dateFromComponents:components];

    return beginningOfDay;
}

- (NSDate *)endOfDay
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [NSDateComponents new];
    components.day = 1;
    
    NSDate *endOfDay = [calendar dateByAddingComponents:components
                                             toDate:[self beginningOfDay]
                                            options:0];
    
    endOfDay = [endOfDay dateByAddingTimeInterval:-1];
    return endOfDay;
}


- (IBAction)buttonAddData:(UIButton *)sender
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDate *date = [NSDate date];
    NSDateComponents *comps = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                     fromDate:date];
    NSDate *today = [cal dateFromComponents:comps];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    NSDate *startDate;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    
    for (int i = -30; i<30; i++)
    {
        Meeting *meeting = [NSEntityDescription
                            insertNewObjectForEntityForName:@"Meeting"
                            inManagedObjectContext:self.managedObjectContext];
        
        [components setDay:-i];
        startDate = [cal dateByAddingComponents:components toDate:today options:0];
        meeting.startDate = startDate;
        meeting.title = [formatter stringFromDate:startDate];

    }
    BOOL save = [self.managedObjectContext save:nil];
    if (!save) NSLog(@"There was an Error saving to Core Data in RootVC");
    if (save) NSLog(@"New Datasaved");

}

#pragma mark - NSFetchedControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    NSLog(@"controllerWillChangeContent: self.numberOfSectionsInTV before change %i", self.numberOfSectionsInTV);
    NSLog(@"Controller %@", controller);
    NSLog(@"todayFRC %@", self.sectionTodayFRC);
    NSLog(@"UpcomingFRC %@", self.sectionUpcomingFRC);
    NSLog(@"PastFRC %@", self.sectionPastFRC);

    [self.tableView beginUpdates];


}



- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    NSLog(@"Inside controllerDidChangeContent:");

    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    NSLog(@"Inside didChangeObject:");
    
    NSIndexPath *modifiedIndexPath;
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
        {

            if (controller == self.sectionTodayFRC)
            {
                modifiedIndexPath = [NSIndexPath indexPathForRow:newIndexPath.row inSection:0];
            }
            else if (controller == self.sectionUpcomingFRC)
            {
                if (self.numberOfSectionsInTV == 1)
                {
                    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationTop];

                    NSLog(@"||self.numberOfSectionsInTV old == 1: New: %i", self.numberOfSectionsInTV);
                }
                modifiedIndexPath = [NSIndexPath indexPathForRow:newIndexPath.row inSection:1];
            }
            else if (controller == self.sectionPastFRC)
            {
                if (self.numberOfSectionsInTV == 2)
                {
                    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationTop];
                    NSLog(@"|||self.numberOfSectionsInTV old == 2: New: %i", self.numberOfSectionsInTV);
                    
                }
                modifiedIndexPath = [NSIndexPath indexPathForRow:newIndexPath.row inSection:2];
            }
        }

           [self.tableView insertRowsAtIndexPaths:@[modifiedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

            break;
        
        case NSFetchedResultsChangeDelete:
            NSLog(@"frcChangeDelete");
            if (controller == self.sectionTodayFRC)
            {
                modifiedIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
            }
            else if (controller == self.sectionUpcomingFRC)
            {
                modifiedIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:1];
                
            }
            else if (controller == self.sectionPastFRC)
            {
                modifiedIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:2];
                
            }
            [self.tableView deleteRowsAtIndexPaths:@[modifiedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeUpdate:
            NSLog(@"frcChangeUpdate");
            if (controller == self.sectionTodayFRC)
            {
                modifiedIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
            }
            else if (controller == self.sectionUpcomingFRC)
            {
                modifiedIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:1];
                
            }
            else if (controller == self.sectionPastFRC)
            {
                modifiedIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:2];
                
            }
            [self.tableView reloadRowsAtIndexPaths:@[modifiedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeMove:
            NSLog(@"frcChangeDelete");
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
    
}

//Since section for all three FRC's is 0 and never changes, this delegate is not called
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}



@end
