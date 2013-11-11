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
@property (nonatomic) NSFileManager *fileManager;

@end

@implementation FeaturedTVController

- (NSFileManager *)fileManager
{
    if (!_fileManager) {
        _fileManager = [[NSFileManager alloc] init];
    }
    return _fileManager;
}

- (void)setPhotos:(NSArray *)photos
{
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"photoTitle" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:descriptor];
    NSArray *sortedPhotos = [photos sortedArrayUsingDescriptors:descriptors];
    _photos = sortedPhotos;
    [self.tableView reloadData];
}

- (NSMutableArray *)viewedPhotos
{
    if (!_viewedPhotos) {
        // Get Document path
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath =[documentPaths objectAtIndex:0];
        
        // Creat a sub directory
        NSString *subDir = [documentPath stringByAppendingPathComponent:VIEWED_PHOTOS];
        if (![self.fileManager fileExistsAtPath:subDir]) {
            [self.fileManager createDirectoryAtPath:subDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        // Create a file path inside sub directory
        NSString *filePath = [subDir stringByAppendingPathComponent:@"test.txt"];
        
        if ([self.fileManager isReadableFileAtPath:filePath]) {
            NSData *data = [self.fileManager contentsAtPath:filePath];
            NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            if (array != nil) {
                _viewedPhotos = (NSMutableArray *)array;
            } else {
                _viewedPhotos = [[NSMutableArray alloc] init];
            }
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
    photoArchive.photoID = [photo[FLICKR_PHOTO_ID] description];
    
    BOOL duplicate = NO;
    for (RecentlyViewedPhotos *viewedPhoto in self.viewedPhotos) {
        if ([photoArchive.photoURL isEqual:viewedPhoto.photoURL]) duplicate = YES;
    }
    
    if (!duplicate) {
        [self.viewedPhotos addObject:photoArchive];
        
        if ([self.viewedPhotos count] > 10) {
            NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"lastViewed" ascending:NO];
            NSArray *descriptors = [NSArray arrayWithObject:descriptor];
            NSMutableArray *sortedPhotos = [NSMutableArray arrayWithArray:[self.viewedPhotos sortedArrayUsingDescriptors:descriptors]];
            
            NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentPath =[documentPaths objectAtIndex:0];
            NSString *subDir = [documentPath stringByAppendingPathComponent:VIEWED_PHOTOS];
            NSString *imgDir = [subDir stringByAppendingPathComponent:@"image"];
            
            NSString *imagePath = [imgDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpeg", [[sortedPhotos lastObject] photoID]]];
            [self.fileManager removeItemAtPath:imagePath error:nil];
            
            [((NSMutableArray *)sortedPhotos) removeLastObject];
            self.viewedPhotos = sortedPhotos;
        }
        
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
                    if ([segue.destinationViewController respondsToSelector:@selector(setImageID:)]) {
                        [segue.destinationViewController performSelector:@selector(setImageID:) withObject:(NSString *)photo[FLICKR_PHOTO_ID]];
                        NSLog(@"Image ID is %@", [segue.destinationViewController imageID]);
                    }
                    [segue.destinationViewController setTitle:[self titleForRow:indexPath.row]];
                    
                    [self addPhotoArchive:indexPath.row];
                    
                    // Get serialized data
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.viewedPhotos];
                    
                    // Get Document path
                    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentPath =[documentPaths objectAtIndex:0];
                    
                    // Creat a sub directory
                    NSString *subDir = [documentPath stringByAppendingPathComponent:VIEWED_PHOTOS];
                    if (![self.fileManager fileExistsAtPath:subDir]) {
                        [self.fileManager createDirectoryAtPath:subDir withIntermediateDirectories:YES attributes:nil error:nil];
                    }
                    
                    // Create a file path inside sub directory
                    NSString *filePath = [subDir stringByAppendingPathComponent:@"test.txt"];

                    // Write the data to that file
                    BOOL success = [data writeToFile:filePath atomically:YES];
                    
                    // Save image files
                    NSString *imgDir = [subDir stringByAppendingPathComponent:@"image"];
                    if (![self.fileManager fileExistsAtPath:imgDir]) {
                        [self.fileManager createDirectoryAtPath:imgDir withIntermediateDirectories:YES attributes:nil error:nil];
                    }
                    
                    NSData *imageData = [[NSData alloc] initWithContentsOfURL:url];
                    UIImage *image = [[UIImage alloc] initWithData:imageData];
                    NSString *imagePath = [imgDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpeg", photo[FLICKR_PHOTO_ID]]];
                    BOOL imageSaved = [UIImageJPEGRepresentation(image, 1.0) writeToFile:imagePath atomically:YES];
                    
                    if (success) {
                        NSLog(@"Data successfully written to file");
                    } else {
                        NSLog(@"Writing to file failed!");
                    }
                    
                    if (imageSaved) {
                        NSLog(@"Image successfully written to file");
                        NSLog(@"Image ID is %@", [segue.destinationViewController imageID]);
                    } else {
                        NSLog(@"Saving image failed!");
                    }
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
