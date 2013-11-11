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
    //[self emptyDirectory];
}

- (void)emptyDirectory
{
    // Get Document path
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath =[documentPaths objectAtIndex:0];
    
    // Creat a sub directory
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *subDir = [documentPath stringByAppendingPathComponent:VIEWED_PHOTOS];
    NSString *filePath = [subDir stringByAppendingPathComponent:@"test.txt"];
    [fileManager removeItemAtPath:filePath error:nil];
    
    NSString *imgDir = [subDir stringByAppendingPathComponent:@"image"];
    if ([fileManager contentsOfDirectoryAtPath:imgDir error:nil]) {
        NSArray *files = [fileManager contentsOfDirectoryAtPath:imgDir error:nil];
        for (NSString *file in files) {
            NSString *fullPath = [imgDir stringByAppendingPathComponent:file];
            if ([fileManager fileExistsAtPath:fullPath]) {
                NSLog(@"Full path is %@", fullPath);
                [fileManager removeItemAtPath:fullPath error:nil];
                NSLog(@"All items in this directory have been deleeted");
            }
        }
    }

}

- (void)getLatestPhotosList
{
    // Get Document path
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath =[documentPaths objectAtIndex:0];
    
    // Creat a sub directory
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *subDir = [documentPath stringByAppendingPathComponent:VIEWED_PHOTOS];
    if (![fileManager fileExistsAtPath:subDir]) {
        [fileManager createDirectoryAtPath:subDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    // Create a file path inside sub directory
    NSString *filePath = [subDir stringByAppendingPathComponent:@"test.txt"];
    
    if ([fileManager isReadableFileAtPath:filePath]) {
        NSData *viewedPhotosData = [fileManager contentsAtPath:filePath];
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:viewedPhotosData];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastViewed" ascending:NO];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        NSArray *sortedViewedPhotos = [array sortedArrayUsingDescriptors:sortDescriptors];
        self.viewedPhotos = sortedViewedPhotos;
    }
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
                    if ([segue.destinationViewController respondsToSelector:@selector(setImageID:)]) {
                        [segue.destinationViewController performSelector:@selector(setImageID:) withObject:[self.viewedPhotos[indexPath.row] photoID]];
                    }
                    [segue.destinationViewController setTitle:[self titleForRow:indexPath.row]];
                }
            }
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%lu", [self.viewedPhotos count]);
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
