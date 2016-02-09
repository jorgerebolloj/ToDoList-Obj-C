//
//  ToDoInfoViewController.m
//  ToDoList-Obj-C
//
//  Created by Jorge Rebollo J on 08/02/16.
//  Copyright © 2016 Regall. All rights reserved.
//

#import "ToDoInfoViewController.h"
#import "ToDoBusinessController.h"

@interface ToDoInfoViewController ()

@end

@implementation ToDoInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"ToDo info";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    ToDoBusinessController *toDoBusiness = [ToDoBusinessController sharedInstance];
    if ([[toDoBusiness.existingPlaningItem allKeys] count] != 0 || [[toDoBusiness.existingCompletedItem allKeys] count] != 0) {
        if ([toDoBusiness.originList isEqualToString:@"PlaningList"]) {
            self.toDoExistingPlaningItem = [toDoBusiness.existingPlaningItem mutableCopy];
            [self.titleLabel setText:[[self.toDoExistingPlaningItem valueForKeyPath:@"title"] description]];
            [self.descriptionTextView setText:[[self.toDoExistingPlaningItem valueForKeyPath:@"description"] description] ? [[self.toDoExistingPlaningItem valueForKeyPath:@"description"] description] : @""];
            NSData* imageData = [self.toDoExistingPlaningItem valueForKeyPath:@"image"];
            self.imagetView.image = [UIImage imageWithData:imageData];
        } else {
            self.toDoExistingCompletedItem = [toDoBusiness.existingCompletedItem mutableCopy];
            [self.titleLabel setText:[[self.toDoExistingCompletedItem valueForKeyPath:@"title"] description]];
            [self.descriptionTextView setText:[[self.toDoExistingCompletedItem valueForKeyPath:@"description"] description] ? [[self.toDoExistingCompletedItem valueForKeyPath:@"description"] description] : @""];
            NSData* imageData = [self.toDoExistingCompletedItem valueForKeyPath:@"image"];
            self.imagetView.image = [UIImage imageWithData:imageData];
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    ToDoBusinessController *toDoBusiness = [ToDoBusinessController sharedInstance];
    [self.titleLabel setText:@""];
    [self.descriptionTextView setText:@""];
    self.imagetView.image = nil;
    if ([toDoBusiness.originList isEqualToString:@"PlaningList"]) {
        [self.toDoExistingPlaningItem removeAllObjects];
        [toDoBusiness.existingPlaningItem removeAllObjects];
    } else {
        [self.toDoExistingCompletedItem removeAllObjects];
        [toDoBusiness.existingCompletedItem removeAllObjects];
    }
}

@end
