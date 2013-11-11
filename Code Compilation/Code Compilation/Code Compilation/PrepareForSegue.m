//
//  PrepareForSegue.m
//  Code Compilation
//
//  Created by Ahryun Moon on 11/7/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "PrepareForSegue.h"

@interface PrepareForSegue ()

@end

@implementation PrepareForSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = nil;
    
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        indexPath = [self.tableView indexPathForCell:sender];
    }
    // Define segue identifier in story board
    if (indexPath) {
        if ([segue.identifier isEqualToString:@"<#Segue Identifier#>:"]) {
            <#Core Data Entity Name#> *<#Core Data Entity Name#> = [self.fetchedResultController objectAtIndexPath:indexPath];
            if ([segue.destinationViewController respondsToSelector:@selector(<#Call Entity's Setter Method#>)]) {
                [segue.destinationViewController performSelector:@selector(<#Call Entity's Setter Method#>) withObject:<#Core Data Entity Name#>];
            }
            
        }
    }
}

@end
