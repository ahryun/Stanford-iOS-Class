//
//  PhotoCDTVC.m
//  FlickrCD
//
//  Created by Ahryun Moon on 11/6/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "PhotoCDTVC.h"
#import "Photo.h"
#import "Photo+Flickr.h"
#import "ImageVC.h"

@interface PhotoCDTVC ()

@end

@implementation PhotoCDTVC

- (void)setTag:(Tag *)tag
{
    _tag = tag;
    [self setUpFetchedResultController];
}

- (void)setUpFetchedResultController
{
    if (self.tag.managedObjectContext) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
        request.predicate = [NSPredicate predicateWithFormat:@"ANY tags = %@", self.tag];
        
        self.fetchedResultController = [[NSFetchedResultsController alloc]
                                        initWithFetchRequest:request
                                        managedObjectContext:self.tag.managedObjectContext
                                        sectionNameKeyPath:nil
                                        cacheName:nil];
    } else {
        self.fetchedResultController = nil;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Photo" forIndexPath:indexPath];
    Photo *photo = [self.fetchedResultController objectAtIndexPath:indexPath];
    cell.textLabel.text = [photo.title description];
    cell.detailTextLabel.text = [photo.subtitle description];
    
    // Thumbnail Image
    if (photo.thumbnailData) {
        UIImage *thumbnail = [UIImage imageWithData:photo.thumbnailData];
        cell.imageView.image = thumbnail;
    } else {
        cell.imageView.image = nil;
    }
    
    return cell;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSArray *photos = self.fetchedResultController.fetchedObjects;
    dispatch_queue_t fetchQ = dispatch_queue_create("Thumbnail Fetch", nil);
    dispatch_async(fetchQ, ^{
        for (Photo *photo in photos) {
            if (!photo.thumbnailData) {
                if (photo.thumbnailURL) {
                    NSURL *thumbnailURL = [NSURL URLWithString:photo.thumbnailURL];
                    NSData *thumbnailData = [NSData dataWithContentsOfURL:thumbnailURL];
                    [self.tag.managedObjectContext performBlock:^{
                        [Photo loadThumbnailDataForPhoto:photo withPhotoData:thumbnailData inManagedObjectContext:self.tag.managedObjectContext];
                    }];
                }
            }
        }
    });
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = nil;
    
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        indexPath = [self.tableView indexPathForCell:sender];
    }
    if (indexPath) {
        NSLog(@"%@", segue.identifier);
        if ([segue.identifier isEqualToString:@"setPhoto:"]) {
            Photo *photo = [self.fetchedResultController objectAtIndexPath:indexPath];
            [Photo logLastViewed:photo inManagedObjectContext:self.fetchedResultController.managedObjectContext];
            UIViewController *imageVC = segue.destinationViewController;
            if ([imageVC respondsToSelector:@selector(setPhoto:)]) {
                [segue.destinationViewController performSelector:@selector(setPhoto:) withObject:photo];
            }
        }
    }
}


@end
