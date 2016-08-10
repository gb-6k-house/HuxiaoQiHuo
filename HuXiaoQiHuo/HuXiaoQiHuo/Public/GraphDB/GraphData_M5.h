//
//  GraphData_M5.h
//  
//
//  Created by EasyFly on 15/5/19.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface GraphData_M5 : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSNumber * closeprice;
@property (nonatomic, retain) NSString * datetime;
@property (nonatomic, retain) NSNumber * highestprice;
@property (nonatomic, retain) NSNumber * lowestprice;
@property (nonatomic, retain) NSNumber * openprice;
@property (nonatomic, retain) NSNumber * time;
@property (nonatomic, retain) NSNumber * volume;
@property (nonatomic, retain) NSNumber * status;

@end
