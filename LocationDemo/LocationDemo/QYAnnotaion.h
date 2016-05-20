//
//  QYAnnotaion.h
//  LocationDemo
//
//  Created by qingyun on 16/5/16.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface QYAnnotaion : NSObject<MKAnnotation>

//协议中表示位置的属性
@property (nonatomic) CLLocationCoordinate2D coordinate;

//title
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *subtitle;

@end
