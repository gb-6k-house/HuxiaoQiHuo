//
//  XMLParser.m
//  Test
//
//  Created by wenbo.fan on 12-10-10.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "XMLParser.h"

@implementation Actual
@synthesize AcName, Ip, RespAvg, Port;
@synthesize G_Ip, G_Port, P_Ip, P_Port;

- (NSString *)description
{
    return [NSString stringWithFormat:@"Ip:%@ Port %ld AcName %@ RespAvg %ld G_Ip:%@ G_Port:%ld P_Ip:%@ P_Port:%ld", Ip, (long)Port, AcName, (long)RespAvg, G_Ip, (long)G_Port, P_Ip, (long)P_Port];
}
@end

@implementation XMLParser

@synthesize currentActual,actualList;

- (XMLParser *)initXMLParser
{
    self = [super init];
    return self;
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:@"Actual"]) {
        sParentSection = elementName;
        tempActual = [[Actual alloc] init];
        if (actualList != nil) {
            [actualList addObject:tempActual];
        }else{
            currentActual = tempActual;
        }
    }else if ([elementName isEqualToString:@"ActualList"]){
        actualList = [[NSMutableArray alloc] init];
    }else{}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string2 {
    NSString *string = [string2 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (string == nil) {
        return;
    }
    if(!currentElementValue)
        currentElementValue = [[NSMutableString alloc] initWithString:string];
    else
        [currentElementValue appendString:string];
}

//XMLParser.m
- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"Svr"] || [elementName isEqualToString:@"Actual"] || [elementName isEqualToString:@"ActualList"]) {
        sParentSection = @"";
        return;
    }
    if([sParentSection isEqualToString:@"Actual"])
    {
		[tempActual setValue:currentElementValue forKey:elementName];
    }else
    {
        [self setValue:currentElementValue forKey:elementName];
    }
    currentElementValue = nil;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Actual %@ \nActualList %@\nSpecialList %@ \nChechSpeed %@ \nModeType %d\n", currentActual, actualList, SpecialList, CheckSpeed, ModeType];
}
@end

