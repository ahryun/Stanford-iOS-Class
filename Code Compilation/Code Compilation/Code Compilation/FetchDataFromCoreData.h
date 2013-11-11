//
//  FetchDataFromCoreData.h
//  Code Compilation
//
//  Created by Ahryun Moon on 11/7/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//
// This assumes the fetchedResultController set the delegate and tracks the changes in UIManagedObjectContext


#import <UIKit/UIKit.h>

@interface FetchDataFromCoreData : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultController;
@property (nonatomic) BOOL debug;

@end
