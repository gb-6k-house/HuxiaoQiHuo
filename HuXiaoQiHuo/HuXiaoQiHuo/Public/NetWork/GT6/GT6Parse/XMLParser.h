//
//  XMLParser.h
//  Test
//
//  Created by wenbo.fan on 12-10-10.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

@interface Actual : NSObject{
    NSString * Ip;
    NSInteger Port;
    NSString * AcName;
    NSInteger RespAvg;
    
    NSString * G_Ip;
    NSInteger G_Port;
    NSString * P_Ip;
    NSInteger P_Port;
}
@property (nonatomic, retain) NSString * AcName;
@property (nonatomic, retain) NSString * Ip;
@property (nonatomic) NSInteger Port;
@property (nonatomic) NSInteger RespAvg;

@property (nonatomic, retain) NSString * G_Ip;
@property (nonatomic) NSInteger G_Port;

@property (nonatomic, retain) NSString * P_Ip;
@property (nonatomic) NSInteger P_Port;


- (NSString *)description;
@end

@interface XMLParser : NSObject<NSXMLParserDelegate>
{
    Actual * tempActual;
    Actual * currentActual;
    NSMutableArray * actualList;
    NSString * SpecialList;
    NSString * CheckSpeed;
    NSString * sParentSection;
    NSInteger  ModeType;
    
	NSMutableString *currentElementValue;
    
}

@property (nonatomic) Actual * currentActual;
@property (strong, nonatomic)NSMutableArray * actualList;

- (XMLParser *)initXMLParser;
- (NSString *)description;
@end

