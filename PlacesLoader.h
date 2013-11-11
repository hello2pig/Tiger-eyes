//
//  PlacesLoader.h
//  tiger eyes
//
//  Created by ted lee on 11.10.13.
//  Copyright (c) 2013 ted lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;

typedef void (^SuccessHandler)(NSDictionary *responseDict);
typedef void (^ErrorHandler)(NSError *error);

@class Place;

@interface PlacesLoader : NSObject

+ (PlacesLoader *)sharedInstance;
- (void)loadPOIsForLocation:(CLLocation *)location radius:(int)radius successHanlder:(SuccessHandler)handler errorHandler:(ErrorHandler)errorHandler;
- (void)loadDetailInformation:(Place *)location successHanlder:(SuccessHandler)handler errorHandler:(ErrorHandler)errorHandler;

@end
