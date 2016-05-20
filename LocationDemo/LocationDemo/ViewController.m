//
//  ViewController.m
//  LocationDemo
//
//  Created by qingyun on 16/5/16.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "QYAnnotaion.h"

@interface ViewController ()<CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic, strong)CLLocationManager *locationManger;//定位位置管理器
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //初始化定位服务
    self.locationManger = [[CLLocationManager alloc] init];
    
    //设置定位的精确度和更新频率
    self.locationManger.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManger.distanceFilter = 10.f;
    
    self.locationManger.delegate = self;
    
    //授权状态是没有做过选择
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self.locationManger requestAlwaysAuthorization];
    }
    
//    self.mapView.mapType = MKMapTypeSatellite;
    
    //设置显示的区域
    
    CLLocationCoordinate2D centerConnrdinate;
    centerConnrdinate.longitude = -122.04;
    centerConnrdinate.latitude = 37.34;
    
    MKCoordinateSpan span;
    span = MKCoordinateSpanMake(0.05, 0.05);
    
    MKCoordinateRegion region = MKCoordinateRegionMake(centerConnrdinate, span);
    
    [self.mapView setRegion:region];
    self.mapView.delegate = self;
    
    
//    <wpt lat="37.33" lon="-122.03"></wpt>
//    <wpt lat="37.34" lon="-122.04"></wpt>
//    <wpt lat="37.35" lon="-122.05"></wpt>
//    <wpt lat="37.36" lon="-122.06"></wpt>
    
    //申请栈内存
    CLLocationCoordinate2D coordinates[4];
    coordinates[0] = CLLocationCoordinate2DMake(37.33, -122.03);
    coordinates[1] = CLLocationCoordinate2DMake(37.34, -122.04);
    coordinates[2] = CLLocationCoordinate2DMake(37.35, -122.05);
    coordinates[3] = CLLocationCoordinate2DMake(37.36, -122.06);
    
    //添加一个覆盖层模型数据
    MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coordinates count:4];
    //将模型数据添加到地图上
    [self.mapView addOverlay:polyline];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)beginLocaiton:(id)sender {
    //定位服务开启
    if ([CLLocationManager locationServicesEnabled]) {
        [self.locationManger startUpdatingLocation];
    }
    
}

#pragma mark - coreLocation
//定位到新的位置的回调方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    NSLog(@"%@",locations);
    
    CLLocation *location = locations.lastObject;
    CLLocationCoordinate2D centerConnrdinate;
    centerConnrdinate = location.coordinate;
    
    MKCoordinateSpan span;
    span = MKCoordinateSpanMake(0.005, 0.005);
    
    MKCoordinateRegion region = MKCoordinateRegionMake(centerConnrdinate, span);
    
    [self.mapView setRegion:region];
//    
//    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
//    point.coordinate = location.coordinate;
//    
//    [self.mapView addAnnotation:point];
    
    QYAnnotaion *annotation = [[QYAnnotaion alloc] init];
    annotation.coordinate = location.coordinate;
    annotation.title = @"这儿";
    annotation.subtitle = @"我在这儿";
    [self.mapView addAnnotation:annotation];
}

//定位失败的方法
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"%@", error);
}

//授权状态改变的方法
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    NSLog(@"%d", status);
}

#pragma mark - map view

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    MKCoordinateRegion region = mapView.region;
    
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[QYAnnotaion class]]) {
        NSString *identifier = @"qyannotaion";
        MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!view) {
            view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        
        view.image = [UIImage imageNamed:@"annotaion"];
        view.draggable = YES;
        return view;
    }
    return nil;
}
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState{
    if (newState ==  MKAnnotationViewDragStateEnding) {
        CLLocationCoordinate2D coordiante = [view.annotation coordinate];
    }
}

//返回覆盖层的视图
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    if ([overlay isKindOfClass:[MKPolyline class]] ) {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        renderer.lineWidth = 3.f;
        renderer.strokeColor = [UIColor redColor];
        return renderer;
    }
    return nil;
}

@end
