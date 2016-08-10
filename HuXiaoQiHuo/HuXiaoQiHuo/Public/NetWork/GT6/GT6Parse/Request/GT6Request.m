//
//  Request.m
//  Test
//
//  Created by wenbo.fan on 12-10-11.
//  Copyright (c) 2012年 wenbo.fan. All rights reserved.
//

#import "GT6Request.h"
#include "aes.h"
#define AES_BLOCK_SIZE 16
@implementation GT6Request
-(GT6Request *)initWithBc:(NSString *)bc AndTag:(NSString *)tag
{
    if (self = [super init]) {
         dicHead = [[NSMutableDictionary alloc] init];
        [dicHead setValue:bc forKey:@"Bc"];
        [dicHead setValue:tag forKey:@"Tag"];
         dicPara = [[NSMutableDictionary alloc] init];

    }
    return self;
}

-(NSString *)getCheckString:(NSString *)str
{
    return  [GT6Request getCheck:str];
}

-(NSString *)getJSONString
{
    NSString * para = [self getParaString];
    [dicHead setValue:[self getCheckString:para] forKey:@"check"];
    [dicHead setValue:[NSNumber numberWithInteger:[para length]] forKey:@"Len"];
    int len = [para length];
	if (len<=0)
	{
		return nil;
	}
    
	if(len%AES_BLOCK_SIZE != 0) {
		len = ((len/AES_BLOCK_SIZE)+1)*AES_BLOCK_SIZE;
	}
    
	unsigned char * inputString = (unsigned char *)malloc(len+1);
	if(inputString == NULL) {
		return nil;
	}
	memset(inputString, 0, len+1);
    
	unsigned char * encryptString = (unsigned char*)malloc(len+1);
	if(encryptString == NULL) {
		return nil;
	}
	memset(encryptString, 0, len+1);
    
	memcpy(inputString, [para UTF8String], [para length]);
    
	aes_context aes;
	unsigned char iv[AES_BLOCK_SIZE]={0};
	unsigned char key[AES_BLOCK_SIZE];
	for(int i=0; i<AES_BLOCK_SIZE; i++) {
		key[i] = 32+i;
	}
	memset(&aes, 0, sizeof(aes));
	aes_setkey_enc(&aes, key, AES_BLOCK_SIZE);
	aes_crypt_cbc(&aes, AES_ENCRYPT, len, iv, inputString, encryptString);
    
	int len2 = 0;
	if (len%3!=0)
	{
		len2 = (len/3+1) * 4;
	}else{
		len2 = len/3 * 4;
	}
    
	unsigned char * encodeBase64String = (unsigned char*)malloc(len2+1);
	if(encodeBase64String == NULL) {
		printf("encodeBase64String malloc\nerror!\n");
		return nil;
	}
	memset(encodeBase64String,0, len2+1);
	int base64len = base64encode(encryptString, len, encodeBase64String, len2);
	encodeBase64String[base64len] = 0;
	//NSString *  = QString((const char*)encodeBase64String);
    [dicHead setValue:[NSString stringWithCString:(const char *)encodeBase64String encoding:NSASCIIStringEncoding] forKey:@"para"];
    
	free(encodeBase64String);
	free(inputString);
	free(encryptString);
    NSString *jsonStr = [NetWorkManager getJSONString:dicHead];
    jsonStr = [ self handleJsonString:jsonStr];
    return jsonStr;

}
@end
