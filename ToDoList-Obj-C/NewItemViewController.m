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
    self.toDoNewItem = [[NSMutableDictionary alloc]init];
    self.gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackground)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    self.toDoTitleTextField.delegate=self;
    self.toDoDescriptionTextField.delegate=self;
    [self.toDoTitleTextField becomeFirstResponder];
    self.navigationItem.title = @"Add new TODO";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    //reuse NewItemView to editItemView function
    ToDoBusinessController *toDoBusiness = [ToDoBusinessController sharedInstance];
    if ([[toDoBusiness.existingItem allKeys] count] != 0) {
        self.toDoExistingItem = [toDoBusiness.existingItem mutableCopy];
        self.navigationItem.title = @"Edit TODO";
        [self.toDoTitleTextField setText: [[self.toDoExistingItem valueForKeyPath:@"title"] description]];
        [self.toDoDescriptionTextField setText: [[self.toDoExistingItem valueForKeyPath:@"description"] description] ? [[self.toDoExistingItem valueForKeyPath:@"description"] description]:@""];
        UIImage *btnImage = [UIImage imageNamed:[[self.toDoExistingItem valueForKeyPath:@"image"] description]];
        [self.toDoAddImageBtn setImage:btnImage forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonSystemItemCancel target:nil action:@selector(backAction)];
    }
}

- (void)backAction {
    [self.toDoTitleTextField resignFirstResponder];
    [self.toDoDescriptionTextField resignFirstResponder];
    [self.toDoTitleTextField setText: @""];
    [self.toDoDescriptionTextField setText: @""];
    self.navigationItem.title = @"Add new TODO";
    [self.toDoAddImageBtn setImage:[UIImage imageNamed:@"image512x512.png"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonSystemItemFastForward target:nil action:@selector(backAction)];
    [self.navigationController popViewControllerAnimated:YES];
    [self.toDoExistingItem removeAllObjects];
    ToDoBusinessController *toDoBusiness = [ToDoBusinessController sharedInstance];
    [toDoBusiness.existingItem removeAllObjects];
}

- (IBAction)toDoAddImageBtn:(id)sender {
    
}

- (IBAction)toDoStoreNewItemBtn:(id)sender {
    [self.toDoNewItem setObject:self.toDoTitleTextField.text forKey:@"title"];
    [self.toDoNewItem setObject:self.toDoDescriptionTextField.text forKey:@"description"];
    [self.toDoNewItem setObject:self.dateString forKey:@"modifiedDate"];
    [self.toDoNewItem setObject:@0 forKey:@"status"];
    [self.toDoNewItem setObject:@"image512x512.png" forKey:@"image"];
    if (![self.toDoTitleTextField.text isEqualToString:@""] && ![self.dateString isEqualToString:@""]) {
        ToDoBusinessController *toDoBusiness = [ToDoBusinessController sharedInstance];
        if ([[toDoBusiness.existingItem allKeys] count] == 0)
            [toDoBusiness storeNewItem:self.toDoNewItem];
        else
            [toDoBusiness editExistingItem:self.toDoNewItem];
        [self.toDoTitleTextField resignFirstResponder];
        [self.toDoDescriptionTextField resignFirstResponder];
        [self.toDoTitleTextField setText: @""];
        [self.toDoDescriptionTextField setText: @""];
        [self.navigationController popViewControllerAnimated:YES];
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
