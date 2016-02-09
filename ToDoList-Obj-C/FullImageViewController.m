//
//  FullImageViewController.m
//  ToDoList-Obj-C
//
//  Created by Jorge Rebollo J on 08/02/16.
//  Copyright © 2016 Regall. All rights reserved.
//

#import "FullImageViewController.h"
#import "ToDoBusinessController.h"

@interface FullImageViewController ()

@end

@implementation FullImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    //reuse NewItemView to editItemView function
    ToDoBusinessController *toDoBusiness = [ToDoBusinessController sharedInstance];
    if ([[toDoBusiness.existingPlaningItem allKeys] count] != 0 || [[toDoBusiness.existingCompletedItem allKeys] count] != 0) {
        if ([toDoBusiness.originList isEqualToString:@"PlaningList"]) {
            self.toDoExistingPlaningItem = [toDoBusiness.existingPlaningItem mutableCopy];
            NSData* imageData = [self.toDoExistingPlaningItem valueForKeyPath:@"image"];
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            self.fullImageView.image = image;
        } else {
            self.toDoExistingCompletedItem = [toDoBusiness.existingCompletedItem mutableCopy];
            NSData* imageData = [self.toDoExistingCompletedItem valueForKeyPath:@"image"];
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            self.fullImageView.image = image;
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    ToDoBusinessController *toDoBusiness = [ToDoBusinessController sharedInstance];
    self.fullImageView.image = nil;
    if ([toDoBusiness.originList isEqualToString:@"PlaningList"]) {
        [self.toDoExistingPlaningItem removeAllObjects];
        [toDoBusiness.existingPlaningItem removeAllObjects];
    } else {
        [self.toDoExistingCompletedItem removeAllObjects];
        [toDoBusiness.existingCompletedItem removeAllObjects];
    }
}

@end
