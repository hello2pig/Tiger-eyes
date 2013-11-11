//
//  MainViewController.m
//  tiger eyes
//
//  Created by ted lee on 11.10.13.
//  Copyright (c) 2013 ted lee. All rights reserved.
//

#import "MainViewController.h"

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "PlacesLoader.h"
#import "Place.h"
#import "PlaceAnnotation.h"

NSString * const kNameKey = @"name";
NSString * const kReferenceKey = @"reference";
NSString * const kAddressKey = @"vicinity";
NSString * const kLatiudeKeypath = @"geometry.location.lat";
NSString * const kLongitudeKeypath = @"geometry.location.lng";

@interface MainViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSArray *locations;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	_locationManager = [[CLLocationManager alloc] init];
	[_locationManager setDelegate:self];
	[_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
	[_locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CLLocationManager Delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
	CLLocation *lastLocation = [locations lastObject];
	
	CLLocationAccuracy accuracy = [lastLocation horizontalAccuracy];
	
	NSLog(@"Received location %@ with accuracy %f", lastLocation, accuracy);
	
	if(accuracy < 100.0) {
		MKCoordinateSpan span = MKCoordinateSpanMake(0.014, 0.014);
		MKCoordinateRegion region = MKCoordinateRegionMake([lastLocation coordinate], span);
		
		[_mapView setRegion:region animated:YES];

		[[PlacesLoader sharedInstance] loadPOIsForLocation:[locations lastObject] radius:5000 successHanlder:^(NSDictionary *response) {
			NSLog(@"Response: %@", response);
			if([[response objectForKey:@"status"] isEqualToString:@"OK"]) {
				id places = [response objectForKey:@"results"];
				NSMutableArray *temp = [NSMutableArray array];
				
				if([places isKindOfClass:[NSArray class]]) {
					for(NSDictionary *resultsDict in places) {
						CLLocation *location = [[CLLocation alloc] initWithLatitude:[[resultsDict valueForKeyPath:kLatiudeKeypath] floatValue] longitude:[[resultsDict valueForKeyPath:kLongitudeKeypath] floatValue]];
						Place *currentPlace = [[Place alloc] initWithLocation:location reference:[resultsDict objectForKey:kReferenceKey] name:[resultsDict objectForKey:kNameKey] address:[resultsDict objectForKey:kAddressKey]];
						[temp addObject:currentPlace];
						
						PlaceAnnotation *annotation = [[PlaceAnnotation alloc] initWithPlace:currentPlace];
						[_mapView addAnnotation:annotation];
					}
				}

				_locations = [temp copy];
				
				NSLog(@"Locations: %@", _locations);
			}
		} errorHandler:^(NSError *error) {
			NSLog(@"Error: %@", error);
		}];
		
		[manager stopUpdatingLocation];
	}
}






@end
