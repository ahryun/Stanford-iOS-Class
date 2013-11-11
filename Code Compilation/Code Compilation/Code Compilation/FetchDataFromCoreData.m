//
//  FetchDataFromCoreData.m
//  Code Compilation
//
//  Created by Ahryun Moon on 11/7/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "FetchDataFromCoreData.h"

@interface FetchDataFromCoreData ()

@end

@implementation FetchDataFromCoreData

#pragma mark - Fetching

- (void)setFetchedResultController:(NSFetchedResultsController *)newController
{
    NSFetchedResultsController *oldController = _fetchedResultController;
    if (oldController != newController) {
        _fetchedResultController = newController;
        
        // This assumes the fetchedResultController set the delegate and tracks the changes in UIManagedObjectContext
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

@end
