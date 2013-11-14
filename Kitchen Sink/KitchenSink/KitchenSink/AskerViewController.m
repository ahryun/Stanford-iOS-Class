//
//  AskerViewController.m
//  KitchenSink
//
//  Created by Ahryun Moon on 11/13/13.
//  Copyright (c) 2013 Ahryun Moon. All rights reserved.
//

#import "AskerViewController.h"

@interface AskerViewController ()

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UITextField *answerText;

@end

@implementation AskerViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.questionLabel.text = self.question;
    self.answerText.text = nil;
    [self.answerText becomeFirstResponder];
}

- (NSString *)answer
{
    return self.answerText.text;
}

@end
