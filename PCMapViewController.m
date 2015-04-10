//
//  PCMapViewController.m
//  PikCha
//
//  Created by Mick Lerche on 4/10/15.
//  Copyright (c) 2015 Micah Lanier Design and Illustration. All rights reserved.
//

#import "PCMapViewController.h"
#import "PCPhotoAnnotation.h"
#import <Parse/Parse.h>

@import MapKit;

@interface PCMapViewController () <MKMapViewDelegate>


@end

@implementation PCMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;

    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        PFQuery *query = [PFQuery queryWithClassName: @"PCPhoto"];
        [query whereKey:@"photolocation" nearGeoPoint:geoPoint withinKilometers:1000];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                 double latitude;
                 double longitude;
                for (PFObject *object in objects) {
                    PFGeoPoint *thePoint = [object objectForKey:@"photolocation"];
                    latitude = thePoint.latitude;
                    longitude = thePoint.longitude;

                    NSLog(@" Hej %f, %f", latitude, longitude);
                    CLLocationCoordinate2D annotationCoordinate = CLLocationCoordinate2DMake(latitude, longitude);

                    PCPhotoAnnotation *annotation = [[PCPhotoAnnotation alloc] init];
                    annotation.coordinate = annotationCoordinate;
                    annotation.title = [object objectForKey:@"user"];
                    annotation.objectID = object.objectId;
                    [self.mapView addAnnotation:annotation];
                }
            }
        }];
    }];

}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *identifier = @"theLocation";
    if ([annotation isKindOfClass:[PCPhotoAnnotation class]]) {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];

        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        annotationView.enabled = YES;
        //annotationView.canShowCallout = YES;

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(-40, -100, 100, 100)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;

        NSString *id = [(PCPhotoAnnotation *)annotationView.annotation objectID];

        PFQuery *query = [PFQuery queryWithClassName:@"HomePopulation"];
        [query getObjectInBackgroundWithId:[NSString stringWithFormat:@"%@", id] block:^(PFObject *object, NSError *error) {
            PFFile *file = [object objectForKey:@"imageFile"];
            [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                imageView.image = [UIImage imageWithData:data];
            }];
        }];
        annotationView.image = [UIImage imageNamed:@"pointer"];
        [annotationView addSubview:imageView];

        return annotationView;
    }
    return nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
