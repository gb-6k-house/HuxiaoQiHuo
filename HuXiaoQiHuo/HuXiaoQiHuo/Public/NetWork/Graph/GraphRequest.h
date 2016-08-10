//
//  GraphRequest.h
//  Trader
//
//  Created by easyfly on 2/17/14.
//  Copyright (c) 2014 easyfly. All rights reserved.
//

#import <Foundation/Foundation.h>





@interface GraphRequest : NSObject
//{"cmdCode":"7002","marketID":2,"mpCode":"Tfbsliver","mpName":"mpName","time":"M1"}

@property(nonatomic, copy) NSString * cmdCode;
@property(nonatomic, copy) NSString * marketID;
@property(nonatomic, copy) NSString * mpCode;
@property(nonatomic, copy) NSString * mpName;
@property(nonatomic, copy) NSString * time;

@end
