//
//  PlaceAnnotation.m
//  tiger eyes
//
//  Created by ted lee on 11.10.13.
//  Copyright (c) 2013 ted lee. All rights reserved.
//

#import "PlaceAnnotation.h"

#import "Place.h"

@interface PlaceAnnotation ()

@property (nonatomic, strong) Place *place;

@end


@implementation PlaceAnnotation

- (id)initWithPlace:(Place *)place {
	if((self = [super init])) {
		_place = place;
	}
	return self;
}

- (CLLocationCoordinate2D)coordinate {
	return [_place location].coordinate;
}

- (NSString *)title {
	return [_place placeName];
}

@end
