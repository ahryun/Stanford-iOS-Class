//
//  ManagedObjectContext.h
//  Code Compilation
//
//  Created by Ahryun Moon on 11/7/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManagedObjectContext : UITableViewController

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
