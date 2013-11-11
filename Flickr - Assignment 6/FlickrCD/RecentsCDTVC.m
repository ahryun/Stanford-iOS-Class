//
//  RecentsCDTVC.m
//  FlickrCD
//
//  Created by Ahryun Moon on 11/10/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "RecentsCDTVC.h"
#import "SharedManagedDocument.h"
#import "Photo.h"
#import "ImageVC.h"

@interface RecentsCDTVC ()

@end

@implementation RecentsCDTVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.managedObjectContext) [self useDemoDocument];
}

- (void)useDemoDocument
{
    [[SharedManagedDocument sharedInstance] performWithDocument:^(UIManagedDocument *document){
        self.managedObjectContext = document.managedObjectContext;
    }];
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    if (managedObjectContext) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"lastViewed" ascending:NO]];
        request.predicate = [NSPredicate predicateWithFormat:@"lastViewed != nil"];
        self.fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    } else {
        self.fetchedResultController = nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Recent Photo"];
    Photo *photo = [self.fetchedResultController objectAtIndexPath:indexPath];
    cell.textLabel.text = photo.title;
    cell.detailTextLabel.text = photo.subtitle;
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = nil;
    
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        indexPath = [self.tableView indexPathForCell:sender];
    }
    if (indexPath) {
        if ([segue.identifier isEqualToString:@"Flickr Photo"]) {
            Photo *photo = [self.fetchedResultController objectAtIndexPath:indexPath];
            if ([segue.destinationViewController respondsToSelector:@selector(setPhoto:)]) {
                [segue.destinationViewController performSelector:@selector(setPhoto:) withObject:photo];
            }
            
        }
    }
}



@end
