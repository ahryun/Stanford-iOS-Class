//
//  FeaturedTVController.m
//  Flickr
//
//  Created by Ahryun Moon on 10/24/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "FeaturedTVController.h"
#import "FlickrFetcher.h"
#import "ImageViewController.h"
#import "RecentlyViewedPhotos.h"

@interface FeaturedTVController ()

@property (nonatomic, strong) NSArray *photos; // of NSDictionary's
@property (nonatomic, strong) NSMutableArray *viewedPhotos;

@end

@implementation FeaturedTVController

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    [self.tableView reloadData];
}

- (NSMutableArray *)viewedPhotos
{
    if (!_viewedPhotos) {
        NSData *viewedPhotosData = [[NSUserDefaults standardUserDefaults] objectForKey:VIEWED_PHOTOS];
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:viewedPhotosData];
        if (array != nil) {
            _viewedPhotos = (NSMutableArray *)array;
        } else {
            _viewedPhotos = [[NSMutableArray alloc] init];
        }
    }
    return _viewedPhotos;
}

- (void)addPhotoArchive:(NSUInteger)row
{
    NSDictionary *photo = self.photos[row];
    RecentlyViewedPhotos *photoArchive = [[RecentlyViewedPhotos alloc] init];
    photoArchive.photoURL = [FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatLarge];
    photoArchive.lastViewed = [NSDate date];
    photoArchive.photoTitle = [self titleForRow:row];
    photoArchive.photoDescription = [self subtitleForRow:row];
    
    BOOL duplicate = NO;
    for (RecentlyViewedPhotos *viewedPhoto in self.viewedPhotos) {
        if ([photoArchive.photoURL isEqual:viewedPhoto.photoURL]) duplicate = YES;
    }
    
    if (!duplicate) {
        [self.viewedPhotos addObject:photoArchive];
        NSLog(@"This photo is not a duplicate");
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Show Image"]) {
                if ([segue.destinationViewController respondsToSelector:@selector(setImageURL:)]) {
                    NSDictionary *photo = self.photos[indexPath.row];
                    NSURL *url = [FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatLarge];
                    [segue.destinationViewController performSelector:@selector(setImageURL:) withObject:url];
                    [segue.destinationViewController setTitle:[self titleForRow:indexPath.row]];
                    
                    [self addPhotoArchive:indexPath.row];
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.viewedPhotos];
                    [[NSUserDefaults standardUserDefaults] setObject:data forKey:VIEWED_PHOTOS];
                }
            }
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Flickr Photo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.textLabel.text = [self titleForRow:indexPath.row];
    cell.detailTextLabel.text = [self subtitleForRow:indexPath.row];
    
    return cell;
}

- (NSString *)titleForRow:(NSUInteger)row
{
    return [self.photos[row][FLICKR_PHOTO_TITLE] description];
}

- (NSString *)subtitleForRow:(NSUInteger)row
{
    return [[self.photos[row] valueForKeyPath:FLICKR_PHOTO_DESCRIPTION] description];
}


@end
