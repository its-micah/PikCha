//
//  PCCameraViewController.m
//  PikCha
//
//  Created by Micah Lanier on 4/7/15.
//  Copyright (c) 2015 Micah Lanier Design and Illustration. All rights reserved.
//

#import "PCCameraViewController.h"

@interface PCCameraViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property UIToolbar *toolBar;
@property UIImagePickerController *imagePickerController;
@end

@implementation PCCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.toolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-54, self.view.frame.size.width, 55)];

    self.toolBar.barStyle = UIBarStyleBlackOpaque;
    NSArray *items=[NSArray arrayWithObjects:
                    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel  target:self action:@selector(cancelPicture)],
                    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace  target:nil action:nil],
                    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera  target:self action:@selector(snapPicture)],
                    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace  target:nil action:nil],
                    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction  target:self action:@selector(displayPhotoLibrary:)],
                    nil];
    [self.toolBar setItems:items];

    // create the overlay view
    UIView *newView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44)];

    // important - it needs to be transparent so the camera preview shows through!
    newView.opaque = NO;
    newView.backgroundColor = [UIColor clearColor];

    // parent view for our overlay
    UIView *cameraView = [[UIView alloc] initWithFrame:self.view.bounds];
    [cameraView addSubview:newView];
    [cameraView addSubview:self.toolBar];

    self.imagePickerController = [[UIImagePickerController alloc] init];

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO){
        NSLog(@"Camera not available");
        return;
    }

    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePickerController.delegate = self;
    self.imagePickerController.showsCameraControls = NO;
    self.imagePickerController.allowsEditing = YES;
    [self.imagePickerController setCameraOverlayView:cameraView];
    [self presentViewController:self.imagePickerController animated:YES completion:nil];

}

-(IBAction)takePicture:(id)sender{

//    self.imagePicker = [UIImagePickerController new];
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    } else {
//        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    }
//    self.imagePicker.delegate = self;
//
//    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

-(void)snapPicture{

    [self.imagePickerController takePicture];
}

- (void)displayPhotoLibrary:(id)sender {

    UIImagePickerController *imagePicker = [UIImagePickerController new];

    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    imagePicker.delegate = self;

    [self presentViewController:imagePicker animated:YES completion:nil];

}

- (IBAction)cancelPicture {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)calledPictureController:(id)sender {
//    self.toolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-54, self.view.frame.size.width, 55)];
//
//    self.toolBar.barStyle = UIBarStyleBlackOpaque;
//    NSArray *items=[NSArray arrayWithObjects:
//                    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel  target:self action:@selector(cancelPicture)],
//                    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace  target:nil action:nil],
//                    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera  target:self action:@selector(snapPicture)],
//                    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace  target:nil action:nil],
//                    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction  target:self action:@selector(displayPhotoLibrary:)],
//                    nil];
//    [self.toolBar setItems:items];
//
//    // create the overlay view
//    UIView *newView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44)];
//
//    // important - it needs to be transparent so the camera preview shows through!
//    newView.opaque = NO;
//    newView.backgroundColor = [UIColor clearColor];
//
//    // parent view for our overlay
//    UIView *cameraView = [[UIView alloc] initWithFrame:self.view.bounds];
//    [cameraView addSubview:newView];
//    [cameraView addSubview:self.toolBar];
//
//    self.imagePickerController = [[UIImagePickerController alloc] init];
//
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO){
//        NSLog(@"Camera not available");
//        return;
//    }
//
//    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//    self.imagePickerController.delegate = self;
//    self.imagePickerController.showsCameraControls = NO;
//    self.imagePickerController.allowsEditing = YES;
//    [self.imagePickerController setCameraOverlayView:cameraView];
//    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}




@end
