//
//  ActionSheet.m
//  Code Compilation
//
//  Created by Ahryun Moon on 11/13/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "ActionSheet.h"

@interface ActionSheet () <UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIView *surroundingView;
@property (weak, nonatomic) UIActionSheet *actionSheet;

@end

@implementation ActionSheet

- (IBAction)buttonAction:(UIBarButtonItem *)sender {
    UIActionSheet *actionSheetDefault;
    if (!self.actionSheet) {
        actionSheetDefault = [[UIActionSheet alloc] initWithTitle:<#Action Sheet Title#>
                                                         delegate:self
                                                cancelButtonTitle:<#Cancel Button Title#>
                                           destructiveButtonTitle:<#Destruct Button Title#>
                                                otherButtonTitles:<#Other Buttons Titles#>, nil];
        }
    self.actionSheet = actionSheetDefault;
    [self.actionSheet showFromBarButtonItem:sender animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        [self.surroundingView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    } else {
        NSString *choice = [actionSheet buttonTitleAtIndex:buttonIndex];
        if ([choice isEqualToString:<#Other Button Title#>]) {
            // Do something
        } else if ([choice isEqualToString:<#Yet Another Button Title#>]) {
            // Do something
        }
    }
}
@end
