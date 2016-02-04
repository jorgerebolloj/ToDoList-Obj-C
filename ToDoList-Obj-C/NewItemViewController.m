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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toDoAddImageBtn:(id)sender {
    
}

- (IBAction)toDoStoreNewItemBtn:(id)sender {
    [self.toDoNewItem setObject:self.toDoTitleTextField.text forKey:@"title"];
    [self.toDoNewItem setObject:self.toDoDescriptionTextField.text forKey:@"description"];
    [self.toDoNewItem setObject:self.dateString forKey:@"modifiedDate"];
    [self.toDoNewItem setObject:@0 forKey:@"status"];
    [self.toDoNewItem setObject:@"" forKey:@"image"];
    if (![self.toDoTitleTextField.text isEqualToString:@""] && ![self.dateString isEqualToString:@""]) {
        ToDoBusinessController *toDoBusiness = [ToDoBusinessController sharedInstance];
        [toDoBusiness storeNewItem:self.toDoNewItem];
        [self.toDoTitleTextField resignFirstResponder];
        [self.toDoDescriptionTextField resignFirstResponder];
        self.toDoTitleTextField.text = @"";
        self.toDoDescriptionTextField.text = @"";
        [self dismissViewControllerAnimated:YES completion:nil];
        //[self.navigationController popViewControllerAnimated:YES];
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
