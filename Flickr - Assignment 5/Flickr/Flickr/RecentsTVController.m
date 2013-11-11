//
//  RecentsTVController.m
//  Flickr
//
//  Created by Ahryun Moon on 10/24/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "RecentsTVController.h"
#import "FlickrFetcher.h"
#import "ImageViewController.h"
#import "RecentlyViewedPhotos.h"

@interface RecentsTVController ()

@property (nonatomic, strong) NSArray *viewedPhotos;

@end

@implementation RecentsTVController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self getLatestPhotosList];
    [self.tableView reloadData];
    
    //Uncomment when you want to empty cached photos
    //[self emptyUserDefaults];
}

- (void)emptyUserDefaults
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:VIEWED_PHOTOS];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)getLatestPhotosList
{
    NSData *viewedPhotosData = [[NSUserDefaults standardUserDefaults] objectForKey:VIEWED_PHOTOS];
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:viewedPhotosData];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastViewed" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedViewedPhotos = [array sortedArrayUsingDescriptors:sortDescriptors];
    self.viewedPhotos = sortedViewedPhotos;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Show Recently Viewed"]) {
                if ([segue.destinationViewController respondsToSelector:@selector(setImageURL:)]) {
                    NSURL *url = [self.viewedPhotos[indexPath.row] photoURL];
                    [segue.destinationViewController performSelector:@selector(setImageURL:) withObject:url];
                    [segue.destinationViewController setTitle:[self titleForRow:indexPath.row]];
                }
            }
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%i", [self.viewedPhotos count]);
    return [self.viewedPhotos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Recently Viewed";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.textLabel.text = [self titleForRow:indexPath.row];
    cell.detailTextLabel.text = [self subtitleForRow:indexPath.row];
    
    return cell;
}

- (NSString *)titleForRow:(NSUInteger)row
{
    return [[self.viewedPhotos[row] photoTitle] description];
}

- (NSString *)subtitleForRow:(NSUInteger)row
{
    return [[self.viewedPhotos[row] photoDescription] description];
}



@end
