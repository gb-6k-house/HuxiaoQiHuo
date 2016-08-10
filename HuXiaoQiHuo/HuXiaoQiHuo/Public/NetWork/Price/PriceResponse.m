//
//  PriceResponse.m
//  Trader
//
//  Created by easyfly on 2/14/14.
//  Copyright (c) 2014 easyfly. All rights reserved.
//

#import "PriceResponse.h"

@implementation PriceResponse

- (id)init
{
	self = [super init];
    
    if (self)
    {
		[self reset];
    }
    
	return self;
}

-(void)reset
{
	self.strMarketID = @"";
    self.strProductCode = @"";
    self.strProductName = @"";
    
    self.strLastPrice = @""; // 撮合用
    self.strSellPrice = @"";
    self.strBuyPrice = @"";
    
    self.strAmplitude = @""; // 振幅
    self.strRiseFallRatio = @""; //涨跌幅
    self.strRiseFallPrice = @""; //涨跌幅值
    
    
    self.strMaxPrice = @"";
    self.strMinPrice = @"";
    
    self.strOpenPrice = @"";
    self.strClosePrice = @"";
    
    self.strAllTranNumber = @"";
    self.strAllTranPrice = @"";
    
    self.strBuyNumber1 = @"";
    self.strBuyPrice1 = @"";
    
    self.strBuyNumber2 = @"";
    self.strBuyPrice2 = @"";
    
    self.strBuyNumber3 = @"";
    self.strBuyPrice3 = @"";
    
    self.strSellNumber1 = @"";
    self.strSellPrice1 = @"";
    
    self.strSellNumber2 = @"";
    self.strSellPrice2 = @"";
    
    self.strSellNumber3 = @"";
    self.strSellPrice3 = @"";
    
    self.strTime = @"";

}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.strMarketID forKey:@"strMarketID"];
    [aCoder encodeObject:self.strProductCode forKey:@"strProductCode"];
    [aCoder encodeObject:self.strProductName forKey:@"strProductName"];
    
    [aCoder encodeObject:self.strLastPrice forKey:@"strLastPrice"];
    [aCoder encodeObject:self.strSellPrice forKey:@"strSellPrice"];
    [aCoder encodeObject:self.strBuyPrice forKey:@"strBuyPrice"];
    
    [aCoder encodeObject:self.strAmplitude forKey:@"strAmplitude"];
    [aCoder encodeObject:self.strRiseFallRatio forKey:@"strRiseFallRatio"];
    [aCoder encodeObject:self.strRiseFallPrice forKey:@"strRiseFallPrice"];
    
    [aCoder encodeObject:self.strMaxPrice forKey:@"strMaxPrice"];
    [aCoder encodeObject:self.strMinPrice forKey:@"strMinPrice"];
    
    [aCoder encodeObject:self.strOpenPrice forKey:@"strOpenPrice"];
    [aCoder encodeObject:self.strClosePrice forKey:@"strClosePrice"];
    
    [aCoder encodeObject:self.strAllTranNumber forKey:@"strAllTranNumber"];
    [aCoder encodeObject:self.strAllTranPrice forKey:@"strAllTranPrice"];
    
    [aCoder encodeObject:self.strAvgPrice forKey:@"strAvgPrice"];
    
    [aCoder encodeObject:self.strBuyNumber1 forKey:@"strBuyNumber1"];
    [aCoder encodeObject:self.strBuyPrice1 forKey:@"strBuyPrice1"];
    
    [aCoder encodeObject:self.strBuyNumber2 forKey:@"strBuyNumber2"];
    [aCoder encodeObject:self.strBuyPrice2 forKey:@"strBuyPrice2"];
    
    [aCoder encodeObject:self.strBuyNumber3 forKey:@"strBuyNumber3"];
    [aCoder encodeObject:self.strBuyPrice3 forKey:@"strBuyPrice3"];
    
    [aCoder encodeObject:self.strSellNumber1 forKey:@"strSellNumber1"];
    [aCoder encodeObject:self.strSellPrice1 forKey:@"strSellPrice1"];
    
    [aCoder encodeObject:self.strSellNumber2 forKey:@"strSellNumber2"];
    [aCoder encodeObject:self.strSellPrice2 forKey:@"strSellPrice2"];
    
    [aCoder encodeObject:self.strSellNumber3 forKey:@"strSellNumber3"];
    [aCoder encodeObject:self.strSellPrice3 forKey:@"strSellPrice3"];
    
    [aCoder encodeObject:self.strTime forKey:@"strTime"];
    
    
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        [self setStrMarketID:[aDecoder decodeObjectForKey:@"strMarketID"]];
        [self setStrMarketID:[aDecoder decodeObjectForKey:@"strProductCode"]];
        [self setStrMarketID:[aDecoder decodeObjectForKey:@"strProductName"]];
        
        [self setStrMarketID:[aDecoder decodeObjectForKey:@"strLastPrice"]];
        [self setStrMarketID:[aDecoder decodeObjectForKey:@"strSellPrice"]];
        [self setStrMarketID:[aDecoder decodeObjectForKey:@"strBuyPrice"]];
        
        [self setStrMarketID:[aDecoder decodeObjectForKey:@"strAmplitude"]];
        [self setStrMarketID:[aDecoder decodeObjectForKey:@"strRiseFallRatio"]];
        [self setStrMarketID:[aDecoder decodeObjectForKey:@"strRiseFallPrice"]];
        
        [self setStrMarketID:[aDecoder decodeObjectForKey:@"strMaxPrice"]];
        [self setStrMarketID:[aDecoder decodeObjectForKey:@"strMinPrice"]];
        
        [self setStrMarketID:[aDecoder decodeObjectForKey:@"strOpenPrice"]];
        [self setStrMarketID:[aDecoder decodeObjectForKey:@"strClosePrice"]];
        
        [self setStrMarketID:[aDecoder decodeObjectForKey:@"strAllTranNumber"]];
        [self setStrMarketID:[aDecoder decodeObjectForKey:@"strAllTranPrice"]];
        
        [self setStrMarketID:[aDecoder decodeObjectForKey:@"strAvgPrice"]];
        
        [self setStrMarketID:[aDecoder decodeObjectForKey:@"strBuyNumber1"]];
        [self setStrMarketID:[aDecoder decodeObjectForKey:@"strBuyPrice1"]];
        
        [self setStrMarketID:[aDecoder decodeObjectForKey:@"strBuyNumber2"]];
        [self setStrMarketID:[aDecoder decodeObjectForKey:@"strBuyPrice2"]];
        
        [self setStrMarketID:[aDecoder decodeObjectForKey:@"strBuyNumber3"]];
        [self setStrMarketID:[aDecoder decodeObjectForKey:@"strBuyPrice3"]];
        
        [self setStrMarketID:[aDecoder decodeObjectForKey:@"strSellNumber1"]];
        [self setStrMarketID:[aDecoder decodeObjectForKey:@"strSellPrice1"]];
        
        [self setStrMarketID:[aDecoder decodeObjectForKey:@"strSellNumber2"]];
        [self setStrMarketID:[aDecoder decodeObjectForKey:@"strSellPrice2"]];
        
        [self setStrMarketID:[aDecoder decodeObjectForKey:@"strSellNumber3"]];
        [self setStrMarketID:[aDecoder decodeObjectForKey:@"strSellPrice3"]];
        
        [self setStrMarketID:[aDecoder decodeObjectForKey:@"strTime"]];
    }
    
    return self;
}

@end
