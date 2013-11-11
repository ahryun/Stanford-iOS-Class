//
//  FeaturedTagTVController.m
//  Flickr
//
//  Created by Ahryun Moon on 10/25/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "FeaturedTagTVController.h"
#import "FlickrFetcher.h"

@interface FeaturedTagTVController ()

@property (nonatomic) NSMutableDictionary *tagsToPhotoCount; // key: tag, value: array of photo (dictionary)
@property (nonatomic) NSMutableArray *tags; // Needed as dictionary doesn't retain order
@property (nonatomic, strong) NSArray *photos; // of NSDictionary's

@end

@implementation FeaturedTagTVController

- (NSMutableDictionary *)tagsToPhotoCount
{
    if (!_tagsToPhotoCount) {
        _tagsToPhotoCount = [[NSMutableDictionary alloc] init];
    }
    return _tagsToPhotoCount;
}

- (NSMutableArray *)tags
{
    if (!_tags) {
        _tags = [[NSMutableArray alloc] init];
    }
    return _tags;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setPhotoTags];
    [self.refreshControl addTarget:self
                            action:@selector(setPhotoTags)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)setPhotoTags
{
    [self.refreshControl beginRefreshing];
    dispatch_queue_t flickrPhotoLoad = dispatch_queue_create("Flickr Photo Load", NULL);
    dispatch_async(flickrPhotoLoad, ^{
        NSArray *flickrPhotos = [FlickrFetcher stanfordPhotos];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photos = flickrPhotos;
            for (NSDictionary *photo in self.photos) {
                NSArray *tags = [photo[FLICKR_TAGS] componentsSeparatedByString:@" "];
                for (NSString *tag in tags) {
                    if (!([tag isEqualToString:@"cs193pspot"] || [tag isEqualToString:@"portrait"] || [tag isEqualToString:@"landscape"])) {
                        if ([self.tags containsObject:tag]) {
                            [self.tagsToPhotoCount[tag] addObject:photo];
                        } else {
                            [self.tags addObject:tag];
                            NSMutableArray *photoArray = [[NSMutableArray alloc] initWithObjects:photo, nil];
                            [self.tagsToPhotoCount setObject:photoArray forKey:tag];
                        }
                    }
                }
            }
            [self.tags sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        });
    });
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Show Photos"]) {
                if ([segue.destinationViewController respondsToSelector:@selector(setPhotos:)]) {
                    NSArray *photos = self.tagsToPhotoCount[self.tags[indexPath.row]];
                    [segue.destinationViewController performSelector:@selector(setPhotos:) withObject:photos];
                    [segue.destinationViewController setTitle:[self titleForRow:indexPath.row]];
                }
            }
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tags count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Flickr Tag";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.textLabel.text = [self titleForRow:indexPath.row];
    cell.detailTextLabel.text = [self subtitleForRow:indexPath.row];
    
    return cell;
}

- (NSString *)titleForRow:(NSUInteger)row
{
    NSString *tag = self.tags[row];
    return [tag description];
}

- (NSString *)subtitleForRow:(NSUInteger)row
{
    NSString *tag = self.tags[row];
    return [[NSString alloc] initWithFormat:@"%i photos", [self.tagsToPhotoCount[tag] count]];
}


@end
