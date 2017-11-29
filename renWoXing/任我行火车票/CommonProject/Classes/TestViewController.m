//
//  TestViewController.m
//  CommonProject
//
//  Created by mac on 2017/1/3.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "TestViewController.h"

#import <MapKit/MapKit.h>

@interface TestViewController ()<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) MKPolyline *myPolyline;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置代理
    self.mapView.delegate = self;
    
    NSString *thePath = @"106.73293,10.79871|106.73229,10.79841|106.7318,10.79832|106.73164,10.79847|106.73156,10.7988|106.73106,10.79886|106.73057,10.79877|106.73002,10.79866|106.72959,10.79875|106.72935,10.7992|106.7293,10.79971|106.72925,10.80015|106.72942,10.80046|106.72981,10.80058|106.73037,10.8007|106.73067,10.80072|106.7311,10.80076|106.7315,10.80079|106.73194,10.80082|106.73237,10.80086|106.73265,10.80098|106.73269,10.80153|106.7327,10.80207|106.73257,10.80243|106.73718,10.79941|106.73445,10.79946|106.73144,10.79885|106.72987,10.8005|106.73192,10.79991|106.72383,10.79827|106.71543,10.80086|106.70957,10.80121|106.70507,10.79834|106.70121,10.79432|106.69603,10.79158|106.69322,10.78911|106.69196,10.78785|106.68768,10.78355|106.68539,10.7812|106.68336,10.7791|106.67048,10.78377|106.64864,10.78319|106.6499,10.77949|106.63697,10.77439|106.6447,10.77936|106.65804,10.76279|106.66792,10.76805|106.68191,10.77516|106.68336,10.77241|106.68319,10.77622|106.67482,10.78149|106.67095,10.78193|106.65217,10.78641|";
    
    NSArray *array = [thePath componentsSeparatedByString:@"|"];
    CLLocationCoordinate2D pointToUse[2];
    
    for (NSInteger i = 0; i < (array.count - 2); i++) {
        NSString *str = array[i];
        NSArray *temp = [str componentsSeparatedByString:@","];
        
        NSString *lon = temp[0];
        NSString *lat = temp[1];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([lat doubleValue], [lon doubleValue]);
        pointToUse[0] = coordinate;
        
        NSString *str2 = array[i + 1];
        NSArray *temp2 = [str2 componentsSeparatedByString:@","];
        NSString *lon2 = temp2[0];
        NSString *lat2 = temp2[1];
        CLLocationCoordinate2D coordinate2 = CLLocationCoordinate2DMake([lat2 doubleValue], [lon2 doubleValue]);
        pointToUse[1] = coordinate2;
        
        self.myPolyline = [MKPolyline polylineWithCoordinates:pointToUse count:2];
        [self.mapView addOverlay:self.myPolyline];
    }
    
}
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *render=[[MKPolylineRenderer alloc]initWithOverlay:overlay];
    render.strokeColor=[UIColor redColor];
    return render;
}


@end
