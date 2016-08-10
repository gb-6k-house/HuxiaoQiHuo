//
//  NetUtility.h
//  TFBClient-MM
//
//  Created by easyfly on 13-10-9.
//  Copyright (c) 2013年 Easyfly. All rights reserved.
//

#ifndef TFBClient_MM_NetUtility_h
#define TFBClient_MM_NetUtility_h

#define ResponseType_Heart 0x10  // 心跳
#define ResponseType_Price02    0x02
#define ResponseType_Price03    0x03
#define ResponseType_Price04    0x04

#define ResponseType_Price01    0x01
#define ResponseType_Price05    0x05

#define ResponseType_Price06    0x06


#define ProductInfo_st_ID 1
#define Broadcast_st_ID 2

#define GraphDataHeader_st_ID 3
#define GraphDataBody_st_ID 4
#define GraphDataBody2_st_ID 5

#define OpenCloseTimeHeader_st_ID 6
#define OpenCloseTimeBody_st_ID 7

#define Symbol_st_ID 0x0a0d

//#define State_MsgError 808 //数据没有获取完成，需要等待。
#define State_MsgNone 0    //
//#define State_MsgHead   101
//#define State_MsgHeadBegin 102
//#define State_MsgHeadOver  103



#define State_Msg01   1   //开始处理0x01类型的消息
#define State_Msg05   5   //开始处理0x05类型的消息

/*****************GT6*****************/

#define GT6ProductInfo_st_ID 1
#define GT6Broadcast_st_ID 2
#define GT6GraphDataHeader_st_ID 3
#define GT6GraphDataBody_st_ID 4
#define GT6GraphDataBody2_st_ID 5
#define GT6OpenCloseTime_st_ID 6
#define GT6Symbol_st_ID 0x0a0d

/**************************************/

#pragma pack(1)

typedef struct {
    char type;
    int  count;
    
}Head_st;

typedef struct {
    char type;
    unsigned short mapID;
    int  count;
    
}GraphHead_st;

typedef struct {
    char type;
    char graphType;
    unsigned short mapID;
    int  count;
    
}GraphHead7005_st;

typedef struct
{
    unsigned short structID;
    unsigned short structID2;
    
}Symbol_st;

typedef struct
{
	//header
	unsigned short structID;
	unsigned short size;
	//1
	//body
	unsigned short marketID;
	unsigned short mapID;
	char productcode[24];
}ProductInfo_st;

typedef struct
{
	//header
	unsigned short structID;
	unsigned short size;
	//2
	//body
	unsigned short marketID;
	unsigned short mapID;
	union
    {
		float lastprice;
		float sellprice;
	};
	float buyprice;
	float maxprice;
	float minprice;
	float openprice;
	float closeprice;
	int allTrannumber;
	float allTranPrice;
	int buynumber1;
	float buyprice1;
	int buynumber2;
	float buyprice2;
	int buynumber3;
	float buyprice3;
	int sellnumber1;
	float sellprice1;
	int sellnumber2;
	float sellprice2;
	int sellnumber3;
	float sellprice3;
    
	__int64_t	time;
}Broadcast_st;


typedef struct
{
	//header
	//3
	unsigned short structID;
	unsigned short size;
	//body
	int marketID;
	char productcode[24];
	unsigned short count;
	//1-9 M1 M5 M15 M30 H1 H4 D1 WN MN
	unsigned short graphtype;
}GraphDataHeader_st;

typedef struct
{
	//header
	unsigned short structID;
	unsigned short size;
	//4
	//body
	float firstprice;
	float lastprice;
	float maxprice;
	float minprice;
	int allTranNum;
	__int64_t	time;
}GraphDataBody_st;

typedef struct
{
	//header
	unsigned short structID;
	unsigned short size;
	//5
	//body
	float avgprice;
	float nowprice;
	int allTranNum;
	float maxprice;
	float minprice;
	__int64_t	time;
}GraphDataBody2_st;

typedef struct
{
	//header
	unsigned short structID;
	unsigned short size;
	//6
	//body
	int count;
}OpenCloseTimeHeader_st;

typedef struct
{
	//header
	unsigned short structID;
	unsigned short size;
	//7
	//body
	__int64_t	opentime;
	__int64_t	closetime;
	int wday; //0~6 sun~
	int marketID;
}OpenCloseTimeBody_st;

/***********GT6**********************/

typedef struct{
    unsigned short structID;
    unsigned short structID2;
    
}GT6Symbol_st;

typedef struct{
    //header
    unsigned short structID;
    //6
    //body
    unsigned short mapID;
    //reserve
    int nTemp;
    
    __int64_t	opentime;
    __int64_t	closetime;
    
}GT6OpenCloseTime_st;

typedef struct{
    //header
    unsigned short structID;
    //1
    //body
    unsigned short mapID;
    char productcode[24];
}GT6ProductInfo_st;

typedef struct{
    //header
    unsigned short structID;
    //2
    //body
    unsigned short mapID;
    float lastprice;
    float maxprice;
    float minprice;
    float openprice;
    float closeprice;
    int allTrannumber;
    float allTranPrice;
    int buynumber1;
    float buyprice1;
    int buynumber2;
    float buyprice2;
    int buynumber3;
    float buyprice3;
    int sellnumber1;
    float sellprice1;
    int sellnumber2;
    float sellprice2;
    int sellnumber3;
    float sellprice3;
    __int64_t time;
    
    //time_t	time;
}GT6Broadcast_st; //7003

typedef struct{
    //header
    //3
    unsigned short structID;
    //body
    unsigned short mapID;
    char productcode[24];
    unsigned short count;
    //1-10 M1 M5 M15 M30 H1 H4 D1 WN MN S1
    unsigned short graphtype;
}GT6GraphDataHeader_st;  //7002

typedef struct{
    //header
    unsigned short structID;
    //4
    //body
    unsigned short mapID;
    float firstprice;
    float lastprice;
    float maxprice;
    float minprice;
    int allTranNum;
    __int64_t	time;
}GT6GraphDataBody_st;

typedef struct{
    //header
    unsigned short structID;
    //5
    //body
    unsigned short mapID;
    
    float avgprice;
    float nowprice;
    int allTranNum;
    
    float maxprice;
    float minprice;
    __int64_t	time;
}GT6GraphDataBody2_st;

/**************************************/

#pragma pack()

#endif
