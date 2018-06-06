#import <cocoa/cocoa.h>
#import <CoreLocation/CoreLocation.h>

@interface NSObject(CB)
    - (void)logLonLat:(CLLocation*)location;
    - (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;
    - (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;
@end

@implementation NSObject(CB)
    - (void)logLonLat:(CLLocation*)location
{
    CLLocationCoordinate2D coordinate = location.coordinate;
    printf("{ \"lat\": \"%f\", \"long\": \"%f\" }\n", coordinate.latitude, coordinate.longitude);
    CFRunLoopStop(CFRunLoopGetCurrent());
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        [self logLonLat:newLocation];
        [pool drain];
    }

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
          NSLog(@"Error: %@", error);
}
@end

int main(int ac,char *av[])
{
    id obj = [[NSObject alloc] init];
    id lm = nil;
    if ([CLLocationManager locationServicesEnabled]) {
        lm = [[CLLocationManager alloc] init];
        [lm setDelegate:obj];
        [lm startUpdatingLocation];
    }

    CFRunLoopRun();
    [lm release];
    [obj release];
    return 0;
}
