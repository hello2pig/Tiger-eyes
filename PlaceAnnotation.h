//
//  PlaceAnnotation.h
//  tiger eyes
//
//  Created by ted lee on 11.10.13.
//  Copyright (c) 2013 ted lee. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>

@class Place;

@interface PlaceAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;

- (id)initWithPlace:(Place *)place;

@end
