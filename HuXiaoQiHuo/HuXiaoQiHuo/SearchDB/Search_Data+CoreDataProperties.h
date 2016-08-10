//
//  Search_Data+CoreDataProperties.h
//  traderex
//
//  Created by XXJ on 15/11/19.
//  Copyright © 2015年 EasyFly. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Search_Data.h"

NS_ASSUME_NONNULL_BEGIN

@interface Search_Data (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *mapId;
@property (nullable, nonatomic, retain) NSString *indexString;

@end

NS_ASSUME_NONNULL_END
