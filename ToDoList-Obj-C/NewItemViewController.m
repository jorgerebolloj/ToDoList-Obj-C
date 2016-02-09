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
    
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    ToDoBusinessController *toDoBusiness = [ToDoBusinessController sharedInstance];
    if ([[toDoBusiness.existingPlaningItem allKeys] count] != 0 || [[toDoBusiness.existingCompletedItem allKeys] count] != 0) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:nil action:@selector(backAction)];
        self.navigationItem.title = @"Edit TODO";
    }
}

- (void)viewDidAppear:(BOOL)animated {
    //reuse NewItemView to editItemView function
    ToDoBusinessController *toDoBusiness = [ToDoBusinessController sharedInstance];
    if ([[toDoBusiness.existingPlaningItem allKeys] count] != 0 || [[toDoBusiness.existingCompletedItem allKeys] count] != 0) {
        if ([toDoBusiness.originList isEqualToString:@"PlaningList"]) {
            self.toDoExistingPlaningItem = [toDoBusiness.existingPlaningItem mutableCopy];
            [self.toDoTitleTextField setText:[[self.toDoExistingPlaningItem valueForKeyPath:@"title"] description]];
            [self.toDoDescriptionTextField setText:[[self.toDoExistingPlaningItem valueForKeyPath:@"description"] description] ? [[self.toDoExistingPlaningItem valueForKeyPath:@"description"] description] : @""];
            if (self.tempImage)
                [self.toDoAddImageBtn setImage:self.tempImage forState:UIControlStateNormal];
            else {
                NSData* imageData = [self.toDoExistingPlaningItem valueForKeyPath:@"image"];
                [self.toDoAddImageBtn setImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
            }
        } else {
            self.toDoExistingCompletedItem = [toDoBusiness.existingCompletedItem mutableCopy];
            [self.toDoTitleTextField setText:[[self.toDoExistingCompletedItem valueForKeyPath:@"title"] description]];
            [self.toDoDescriptionTextField setText:[[self.toDoExistingCompletedItem valueForKeyPath:@"description"] description] ? [[self.toDoExistingCompletedItem valueForKeyPath:@"description"] description] : @""];
            if (self.tempImage)
                [self.toDoAddImageBtn setImage:self.tempImage forState:UIControlStateNormal];
            else {
                NSData* imageData = [self.toDoExistingCompletedItem valueForKeyPath:@"image"];
                [self.toDoAddImageBtn setImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
            }
        }
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
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Photo source"
                                      message:@"Please select your photo source method"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* cameraRoll = [UIAlertAction
                             actionWithTitle:@"Choose photo"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 self.imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                                 [self presentViewController:self.imagePicker animated:YES completion:nil];
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        UIAlertAction* camera = [UIAlertAction
                             actionWithTitle:@"Take photo"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                 [self presentViewController:self.imagePicker animated:YES completion:nil];
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                 }];
        
        [alert addAction:cameraRoll];
        [alert addAction:camera];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
    } else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    } else
        [self callAlertViewWithTitle:@"Error" andMessage:@"Camera is not available in this device"];
    
}

#pragma mark UIImagePickerControllerdelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [self.toDoAddImageBtn setImage:image forState:UIControlStateNormal];
    self.tempImage = image;
    if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera)
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel: (UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error)
        [self callAlertViewWithTitle:@"Save failed" andMessage:@"Failed to save image to Photo Album"];
    /*else
        [self callAlertViewWithTitle:@"Success" andMessage:@"Image saved to Photo Album"];*/
}

- (IBAction)toDoStoreNewItemBtn:(id)sender {
    ToDoBusinessController *toDoBusiness = [ToDoBusinessController sharedInstance];
    [self.toDoNewItem setObject:self.toDoTitleTextField.text forKey:@"title"];
    [self.toDoNewItem setObject:self.toDoDescriptionTextField.text forKey:@"description"];
    [self.toDoNewItem setObject:self.dateString forKey:@"modifiedDate"];
    [self.toDoNewItem setObject:UIImagePNGRepresentation(self.toDoAddImageBtn.imageView.image) forKey:@"image"];
    if (![self.toDoTitleTextField.text isEqualToString:@""] && ![self.dateString isEqualToString:@""]) {
        if ([toDoBusiness.originList isEqualToString:@"CompletedList"]) {
            if ([[toDoBusiness.existingCompletedItem allKeys] count] != 0)
                [self.toDoNewItem setObject:[self.toDoExistingCompletedItem valueForKeyPath:@"status"] forKey:@"status"];
                [toDoBusiness editExistingCompletedItem:self.toDoNewItem];
        } else {
            if ([[toDoBusiness.existingPlaningItem allKeys] count] != 0){
                [self.toDoNewItem setObject:[self.toDoExistingPlaningItem valueForKeyPath:@"status"] forKey:@"status"];
                [toDoBusiness editExistingPlaningItem:self.toDoNewItem];
            }
            else {
                [self.toDoNewItem setObject:@0 forKey:@"status"];
                [toDoBusiness storeNewItem:self.toDoNewItem];
            }
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

- (void)callAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alert animated:YES completion:nil];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                         }];
    [alert addAction:ok];
}

@end
