//
//  PCCameraViewController.m
//  PikCha
//
//  Created by Micah Lanier on 4/7/15.
//  Copyright (c) 2015 Micah Lanier Design and Illustration. All rights reserved.
//

#import "PCCameraViewController.h"
#import "PCFeedViewController.h"
#import "PCUser.h"
#import "PCPhoto.h"
#import <CoreLocation/CoreLocation.h>

@interface PCCameraViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property UIToolbar *toolBar;
@property UIImagePickerController *imagePickerController;
@property CLLocationManager *locationManager;
@property CLLocation *userLocation;
@property PCFeedViewController *feedViewController;

@end

@implementation PCCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.locationManager = [CLLocationManager new];
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];


    self.toolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-54, self.view.frame.size.width, 55)];

    self.toolBar.barStyle = UIBarStyleBlackOpaque;
    NSArray *items=[NSArray arrayWithObjects:
                    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel  target:self action:@selector(cancelPicture)],
                    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace  target:nil action:nil],
                    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera  target:self action:@selector(snapPicture)],
                    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace  target:nil action:nil],
                    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction  target:self action:@selector(displayPhotoLibrary:)],
                    nil];


//    for (UIBarButtonItem *button in items) {
//        button.
//    }

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


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    for (CLLocation *location in locations) {
        if (location.horizontalAccuracy < 10000 && location.verticalAccuracy < 10000) {
            NSLog(@"Location Found!");
            [self.locationManager stopUpdatingLocation];
            self.userLocation = location;
            break;
        }
    }

}

-(IBAction)takePicture:(id)sender{


    PCUser *user = (PCUser *)[PFUser currentUser];
    PCPhoto *photo = [PCPhoto new];

    UIImage *myIcon2 = [PCPhoto imageWithImage:self.imageView.image scaledToSize:CGSizeMake(225.0, 300.0)];

    NSData *imageData2 = UIImagePNGRepresentation(myIcon2);
    PFFile *imageFile2 = [PFFile fileWithName:@"image2.png" data:imageData2];
    photo.originalImage = imageFile2;
    photo.photoID = @"3333";
    photo.comment = @"Nice waterfalls";
    photo.username = user.username;
    photo.user = user;
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        photo.photolocation = geoPoint;
    }];
//    photo.photolocation.latitude = self.userLocation.coordinate.latitude;
//    photo.photolocation.longitude = self.userLocation.coordinate.longitude; 
    [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Hooray! We're Saved a Photo");
        } else {
            NSLog(@"%@", error);
        }
    }];
    //Segue to Feed VC
    [self.tabBarController setSelectedIndex:0];


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

}




@end
