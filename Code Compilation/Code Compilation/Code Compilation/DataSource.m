//
//  DataSource.m
//  Code Compilation
//
//  Created by Ahryun Moon on 11/7/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "DataSource.h"

@interface DataSource ()

@end

// Define Cell identifier in Storyboard

@implementation DataSource

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

// May want to put this in a subclass as it has specific information
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"<#Cell Identifier Name#>"];
    <#Core Data Entity#> *<#Core Data Entity#> = [self.fetchedResultController objectAtIndexPath:indexPath];
    cell.textLabel.text = <#Title#>;
    cell.detailTextLabel.text = <#Description#>;
    return cell;
}


@end
