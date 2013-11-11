//
//  FlickrCDViewController.m
//  FlickrCD
//
//  Created by Ahryun Moon on 11/4/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "CoreDataTableViewController.h"

@interface CoreDataTableViewController ()

@property (nonatomic) BOOL suspendAutomaticTrackingOfChangesInManagedObjectContext;
@property (nonatomic) BOOL beganUpdates;

@end

@implementation CoreDataTableViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.fetchedResultController sections] objectAtIndex:section] numberOfObjects];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [self.fetchedResultController sectionForSectionIndexTitle:title atIndex:index];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[[self.fetchedResultController sections] objectAtIndex:section] name];
}

#pragma mark - Fetching

- (void)setFetchedResultController:(NSFetchedResultsController *)newController
{
    NSLog(@"I'm in setFetchedResultController");
    NSFetchedResultsController *oldController = _fetchedResultController;
    if (oldController != newController) {
        _fetchedResultController = newController;
        newController.delegate = self;
        if ((!self.title || [self.title isEqualToString:oldController.fetchRequest.entityName]) && (!self.navigationController || !self.navigationItem.title)) {
            self.title = newController.fetchRequest.entity.name;
        }
        if (newController) {
            if (self.debug) NSLog(@"[%@, %@] %@",
                                  NSStringFromClass([self class]),
                                  NSStringFromSelector(_cmd),
                                  oldController ? @"updated": @"set");
            [self performFetch];
        } else {
            if (self.debug) NSLog(@"[%@, %@] reset to nil",
                                  NSStringFromClass([self class]),
                                  NSStringFromSelector(_cmd));
            [self.tableView reloadData];
        }
    }
}

- (void)performFetch
{
    if (self.fetchedResultController) {
        if (self.fetchedResultController.fetchRequest.predicate) {
            if (self.debug) NSLog(@"[%@, %@] fetching %@ with predicate: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.fetchedResultController.fetchRequest.entityName, self.fetchedResultController.fetchRequest.predicate);
        } else {
            if (self.debug) NSLog(@"[%@, %@] fetching %@ with no predicate", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.fetchedResultController.fetchRequest.entityName);
        }
        NSError *error = nil;
        [self.fetchedResultController performFetch:&error];
        if (error) {
            NSLog(@"[%@, %@] %@ (%@)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [error localizedDescription], [error localizedFailureReason]);
        }
    } else {
        if (self.debug) NSLog(@"[%@, %@] no fetched result controller yet", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    }
    [self.tableView reloadData];
}

#pragma mark - delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext) {
        [self.tableView beginUpdates];
        self.beganUpdates = YES;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext) {
        switch (type) {
            case NSFetchedResultsChangeInsert:
                [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                              withRowAnimation:UITableViewRowAnimationFade];
                break;
            case NSFetchedResultsChangeDelete:
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                              withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext) {
        switch (type) {
            case NSFetchedResultsChangeInsert:
                [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
            case NSFetchedResultsChangeDelete:
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
            case NSFetchedResultsChangeUpdate:
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
            case NSFetchedResultsChangeMove:
                [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
                break;
        }
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if (self.beganUpdates) [self.tableView endUpdates];
}

- (void)endSuspensionOfUpdatesDueToContextChanges
{
    self.suspendAutomaticTrackingOfChangesInManagedObjectContext = NO;
}

- (void)setSuspendAutomaticTrackingOfChangesInManagedObjectContext:(BOOL)suspendAutomaticTrackingOfChangesInManagedObjectContext
{
    if (suspendAutomaticTrackingOfChangesInManagedObjectContext) {
        _suspendAutomaticTrackingOfChangesInManagedObjectContext = suspendAutomaticTrackingOfChangesInManagedObjectContext;
    } else {
        [self performSelector:@selector(endSuspensionOfUpdatesDueToContextChanges) withObject:0 afterDelay:0];
    }
    
}

- (BOOL)shouldAutorotate
{
    return YES;
}

@end
