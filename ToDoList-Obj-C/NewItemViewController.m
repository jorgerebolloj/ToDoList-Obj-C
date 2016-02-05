//
//  NewItemViewController.m
//  ToDoList-Obj-C
//
//  Created by Jorge Rebollo J on 04/02/16.
//  Copyright © 2016 Regall. All rights reserved.
//

#import "NewItemViewController.h"
#import "ToDoBusinessController.h"
#import "FirstViewController.h"

@interface NewItemViewController ()

@end

@implementation NewItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ToDoBusinessController *toDoBusiness = [ToDoBusinessController sharedInstance];
    self.dateString = [toDoBusiness dateTimeConfiguration];
    self.navigationItem.title = @"Add new TODO";
    self.toDoNewItem = [[NSMutableDictionary alloc]init];
    
    self.toDoTitleTextField.delegate=self;
    self.toDoDescriptionTextField.delegate=self;
    
    [self.toDoTitleTextField becomeFirstResponder];
    
    self.gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackground)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    //reuse NewItemView to editItemView function
    ToDoBusinessController *toDoBusiness = [ToDoBusinessController sharedInstance];
    if ([[toDoBusiness.existingPlaningItem allKeys] count] != 0 || [[toDoBusiness.existingCompletedItem allKeys] count] != 0) {
        self.navigationItem.title = @"Edit TODO";
        if ([toDoBusiness.originList isEqualToString:@"PlaningList"]) {
            self.toDoExistingPlaningItem = [toDoBusiness.existingPlaningItem mutableCopy];
            [self.toDoTitleTextField setText:[[self.toDoExistingPlaningItem valueForKeyPath:@"title"] description]];
            [self.toDoDescriptionTextField setText:[[self.toDoExistingPlaningItem valueForKeyPath:@"description"] description] ? [[self.toDoExistingPlaningItem valueForKeyPath:@"description"] description] : @""];
            UIImage *btnImage = [UIImage imageNamed:[[self.toDoExistingPlaningItem valueForKeyPath:@"image"] description]];
            [self.toDoAddImageBtn setImage:btnImage forState:UIControlStateNormal];
        } else {
            self.toDoExistingCompletedItem = [toDoBusiness.existingCompletedItem mutableCopy];
            [self.toDoTitleTextField setText:[[self.toDoExistingCompletedItem valueForKeyPath:@"title"] description]];
            [self.toDoDescriptionTextField setText:[[self.toDoExistingCompletedItem valueForKeyPath:@"description"] description] ? [[self.toDoExistingCompletedItem valueForKeyPath:@"description"] description] : @""];
            UIImage *btnImage = [UIImage imageNamed:[[self.toDoExistingCompletedItem valueForKeyPath:@"image"] description]];
            [self.toDoAddImageBtn setImage:btnImage forState:UIControlStateNormal];
        }
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:nil action:@selector(backAction)];
    }
}

- (void)backAction {
    ToDoBusinessController *toDoBusiness = [ToDoBusinessController sharedInstance];
    [self.toDoTitleTextField resignFirstResponder];
    [self.toDoDescriptionTextField resignFirstResponder];
    [self.toDoTitleTextField setText: @""];
    [self.toDoDescriptionTextField setText: @""];
    self.navigationItem.title = @"Add new TODO";
    [self.toDoAddImageBtn setImage:[UIImage imageNamed:@"image512x512.png"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonSystemItemFastForward target:nil action:@selector(backAction)];
    if ([toDoBusiness.originList isEqualToString:@"PlaningList"]) {
        [self.toDoExistingPlaningItem removeAllObjects];
        [toDoBusiness.existingPlaningItem removeAllObjects];
    } else {
        [self.toDoExistingCompletedItem removeAllObjects];
        [toDoBusiness.existingCompletedItem removeAllObjects];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)toDoAddImageBtn:(id)sender {
    
}

- (IBAction)toDoStoreNewItemBtn:(id)sender {
    ToDoBusinessController *toDoBusiness = [ToDoBusinessController sharedInstance];
    [self.toDoNewItem setObject:self.toDoTitleTextField.text forKey:@"title"];
    [self.toDoNewItem setObject:self.toDoDescriptionTextField.text forKey:@"description"];
    [self.toDoNewItem setObject:self.dateString forKey:@"modifiedDate"];
    [self.toDoNewItem setObject:@0 forKey:@"status"];
    [self.toDoNewItem setObject:@"image512x512.png" forKey:@"image"];
    if (![self.toDoTitleTextField.text isEqualToString:@""] && ![self.dateString isEqualToString:@""]) {
        if ([toDoBusiness.originList isEqualToString:@"CompletedList"]) {
            if ([[toDoBusiness.existingCompletedItem allKeys] count] != 0)
                [toDoBusiness editExistingCompletedItem:self.toDoNewItem];
        } else {
            if ([[toDoBusiness.existingPlaningItem allKeys] count] != 0)
                [toDoBusiness editExistingPlaningItem:self.toDoNewItem];
            else
                [toDoBusiness storeNewItem:self.toDoNewItem];
        }
        [self backAction];
    }
}

#pragma mark UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField*)textField {
    [UIView animateWithDuration:0.5 animations: ^{
        self.toDoNewItemView.frame = CGRectOffset(self.toDoNewItemView.frame, 0, -10);
    }];
    [self.view addGestureRecognizer:self.gestureRecognizer];
}

- (void)textFieldDidEndEditing:(UITextField*)textField {
    [UIView animateWithDuration:0.5 animations: ^{
        self.toDoNewItemView.frame = CGRectOffset(self.toDoNewItemView.frame, 0, 10);
    }];
    [self.view removeGestureRecognizer:self.gestureRecognizer];
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    if (textField == self.toDoTitleTextField) {
        [self.toDoTitleTextField resignFirstResponder];
        [self.toDoDescriptionTextField becomeFirstResponder];
    }
    else
        [self.toDoDescriptionTextField resignFirstResponder];
    return YES;
}

- (void)tapBackground {
    [self.toDoTitleTextField resignFirstResponder];
    [self.toDoDescriptionTextField resignFirstResponder];
}

- (void)keyboardDidShow:(NSNotification *)notification {
}

- (void)keyboardWillHide:(NSNotification *)notification {
}

@end
