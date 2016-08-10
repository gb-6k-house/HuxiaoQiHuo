//
//  CTradeClientSocket.m
//  HuXiaoQiHuo
//
//  Created by niupark on 16/5/19.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "CTradeClientSocket.h"
#import "LoginRequest.h"
#import "NetProtocol.h"
#import "CPriceClientSocket.h"
#import "HeartParaObj.h"
#import "MarketStatusObj.h"
#import "SearchDBManager.h"
#import "ChineseInclude.h"
#import "PinYinForObjc.h"
@interface CTradeClientSocket (){
    NSString *strUserName;
    NSString *strPassword;
    TTFileCache *fileCache;
}
@property(nonatomic, strong)LoginParaObj * objLoginPara; //登录返回的数据
@property (nonatomic, copy) NSString *stringVersion;//版本号

@property (nonatomic, strong) NSMutableDictionary * dicMarketTag;
@property (nonatomic, strong) NSMutableArray * arrayOrder;
@property (nonatomic, strong) NSMutableDictionary * dicMarketTag_Order;
@property (nonatomic, strong) NSMutableDictionary * dicMarketTag_ByParentID_SortOut;
@property (nonatomic, strong) NSMutableDictionary * dicMarketTagrelation;

@property (nonatomic, strong) NSMutableDictionary * dicMarketMenus;
@property (nonatomic, strong) NSMutableDictionary * dicMarketMenus_Order;
@property (nonatomic, strong) NSMutableArray * arrayMenusOrder;
@property (nonatomic, strong) NSMutableDictionary * dicMessageCenterJsonfile;
@property (nonatomic, strong) NSMutableDictionary * dicOCTDic;

@property (nonatomic, strong) NSMutableDictionary * dicMarketName;
//内部数据 @{marketID:NSDictionary(@{mpcode:MerpList_Obj})}
@property (nonatomic, strong) NSMutableDictionary * dicMarket;
//内部数据 @{marketID:NSDictionary(@{mpIndex:MerpList_Obj})}
@property (nonatomic, strong) NSMutableDictionary *dic_All_obj_MerpList;

@property (nonatomic, strong) NSMutableDictionary * dicMarketIndex;//index索引(mpindex:marketIndex_Obj)
@property (nonatomic, strong) NSMutableArray *arrayMarkrtList;
@property (nonatomic, strong) NSMutableArray *arrayMarkrtListName;
@property (nonatomic, strong) NSMutableArray *array_QuoteServerObj;// QuoteServerObj
//K线图，服务器地址信息
@property (nonatomic, strong) NSMutableDictionary * dicMarketServer_Graph;//(marketID:GraphServerObj)
//市场是否过期的dic，市场ID为key，obj
@property (nonatomic, retain) NSMutableDictionary * dicMarketStatus;


//市场ID 和 行情服务器的索引表
@property (nonatomic, strong) NSMutableDictionary * dicMarketQuoteServerObj;//(marketID:QuoteServerObj)
@end
@implementation CTradeClientSocket


-(void) loginWithUsername:(NSString *)username AndPassword:(NSString *)password{
    strUserName = username;
    strPassword = password;
    [self login];
}
-(instancetype)init{
    self = [super init];
    if (self) {
        fileCache = [[TTFileCache alloc] initWithNamespace:@"Trade" maxCount:10];
        _dicPriceData = [NSMutableDictionary dictionary];
        _dicMarketServer_Graph = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void)logout{
    [self disconnect];
    [self disConnectQuoteServerWithMarketID:const_MarketID];//行情服务
    
    _dicPriceData = [NSMutableDictionary dictionary];
    _dicMarketServer_Graph = [NSMutableDictionary dictionary];

    self.objLoginPara = nil;
    self.stringVersion =nil;
    
    self.dicMarketTag = nil;
    self.arrayOrder = nil;;
    self.dicMarketTag_Order = nil;;
    self.dicMarketTag_ByParentID_SortOut = nil;
    self.dicMarketTagrelation = nil;
    
    self.dicMarketMenus = nil;
    self.dicMarketMenus_Order = nil;
    self.arrayMenusOrder = nil;
    self.dicMessageCenterJsonfile = nil;
    self.dicOCTDic = nil;
    
    self.dicMarketName = nil;
    //内部数据 @{marketID:NSDictionary(@{mpcode:MerpList_Obj})}
    self.dicMarket = nil;
    //内部数据 @{marketID:NSDictionary(@{mpIndex:MerpList_Obj})}
    self.dic_All_obj_MerpList = nil;
    
    self.dicMarketIndex = nil;
    self.arrayMarkrtList = nil;
    self.arrayMarkrtListName = nil;
    self.array_QuoteServerObj = nil;
    //K线图，服务器地址信息
    //市场是否过期的dic，市场ID为key，obj
    self.dicMarketStatus = nil;
    
    
    //市场ID 和 行情服务器的索引表
}
//-(void)socketDidDisconnect:(GCDAsyncSocket*)socket withError:(NSError *)err{
//    
//}
-(void) login
{
    
    LoginRequest * objLoginRequest = [[LoginRequest alloc] initWithUsername:strUserName AndPassword:strPassword];
    
    [self sendData:[objLoginRequest getJSONString]];
    
}

-(void) handelSocketJSON:(NSString *)tradeMsg{
    
    if ([tradeMsg isEqualToString:[self symbolString]])
        return;
    
    if (tradeMsg.length < 20)
        return;
    
    NSError * error = nil;
    NSData * dataMsg = [tradeMsg dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary * dicResponse = [NSJSONSerialization JSONObjectWithData:dataMsg options:NSJSONReadingAllowFragments error:&error];
    
    TraderResponse * objTraderResponse = [[TraderResponse alloc] init];
    
    [objTraderResponse setValuesForKeysWithDictionary:dicResponse];
    
    switch (objTraderResponse.cmd)
    {
        case MsgCode_Heart:
            
            [self parseHeartResponse:objTraderResponse];
            
            break;
            
        case MsgCode_Login:
            
            [self parseLoginResponse:objTraderResponse];
            
            break;
            
        case MsgCode_Quit:
            
            [self parseQuitResponse:objTraderResponse];
            
            break;
            
        case MsgCode_UserInfo:
            
            [self parseUserInfoResponse:objTraderResponse];
            
            break;
            
        case MsgCode_MarketList:
            
            [self parseMarketListResponse:objTraderResponse];
            
            break;
            
        case MsgCode_ChangeUserInfo:
            
            [self parseChangeUserInfoResponse:objTraderResponse];
            
            break;
            
        case MsgCode_ChangePass:
            
            [self parseChangePassResponse:objTraderResponse];
            
            break;
            
        case MsgCode_MsgNotify:
            
            [self parseMsgNotifyResponse:objTraderResponse];
            
            break;
            
        case MsgCode_MsgCenterList:
            
            [self parseMsgCenterListResponse:objTraderResponse];
            
            break;
            
        case MsgCode_Subscription:
            
            [self parseDiscoverSubscribeResponse:objTraderResponse];
            
            break;
            
            
        case MsgCode_SubscriptionNumber:
            
            [self parseSubscriptionNumberResponse:objTraderResponse];
            
            break;
            
        case MsgCode_HomepageQuery_uid:
            
            [self parseHomepageQuery_uidResponse:objTraderResponse];
            
            break;
            
            
        case MsgCode_SubscriptionNotify:
            
            [self parseSubscriptionNotifyResponse:objTraderResponse];
            
            break;
        case MsgCode_RaceStatus:
            
            [self parseRaceResponse:objTraderResponse];
            
            break;
        case MsgCode_RaceNumber:
            
            [self parseRaceResponse:objTraderResponse];
            
            break;
        case MsgCode_SUBSCRIPTION_SEARCHNOTIFY:
            
            [self parseSubscriptionSearchResponse:objTraderResponse];
            
            break;
            
        default:
            break;
    }
    
}
//心跳数据返回
- (void) parseHeartResponse: (TraderResponse *) objTraderResponse
{
    HeartParaObj * objHeartPara = [[HeartParaObj alloc] init];
    
    [objHeartPara setValuesForKeysWithDictionary:objTraderResponse.para];
    
    [NetWorkManager sharedInstance].nCurTimeSec = objHeartPara.time;
    
    [self refreshMarketStatus:objHeartPara.time];
}
- (void) refreshMarketStatus:(NSTimeInterval)curTimeSec//刷新过期状态，收到心跳包后刷新
{

    NSArray * arrayTmp = [self.dicMarketStatus allKeys];
    for (NSString * strKey in arrayTmp)
    {
        MarketStatusObj * objMarketStatus = [self.dicMarketStatus valueForKey:strKey];
        
        if (objMarketStatus.timeDate < curTimeSec)
        {
            objMarketStatus.bExpired = YES;
        }
        else
        {
            objMarketStatus.bExpired = NO;
        }
    }
    
    
    
}
//登录返回 ，具体参照协议文件
-(void) parseLoginResponse:(TraderResponse *) objTraderResponse{
    
    
    //
    LoginParaObj * objLoginPara = [[LoginParaObj alloc] init];
    JsonParse *jsonParse = [[JsonParse alloc]init];
    
    objLoginPara = [jsonParse getLoginResponse_LoginParaObjByDIC:objTraderResponse.para];
   //获取login.json
    //判断登陆后返回的MD5值是否与原文件相同
    self.objLoginPara = objLoginPara;
    
    self.array_QuoteServerObj = [NSMutableArray array];
    self.dicMarketQuoteServerObj = [NSMutableDictionary dictionary];
    for (int i = 0; i <self.objLoginPara.quoteServer.count; i++) {
        QuoteServerObj *  objQuoteServer = [[QuoteServerObj alloc]init];
        objQuoteServer.PIP =     [self.objLoginPara.quoteServer[i] objectForKey:@"IP"];
        objQuoteServer.PPort = [self.objLoginPara.quoteServer[i] objectForKey:@"Port"];
        objQuoteServer.priceSocket = [[CPriceClientSocket alloc]init];
        [self.array_QuoteServerObj addObject:objQuoteServer];
        NSArray * marketIDArr = [self.objLoginPara.quoteServer[i] objectForKey:@"marketID"];
        for (int j = 0; j < marketIDArr.count; j++) {
            [self.dicMarketQuoteServerObj setObject:objQuoteServer forKey:[NSString stringWithFormat:@"%@",marketIDArr[j]]];
        }

    }
    
    for (int i = 0; i < self.objLoginPara.graphServer.count; i++) {
        GraphServerObj *  objGraphServer = [[GraphServerObj alloc]init];
        objGraphServer.GIP = [self.objLoginPara.graphServer[i] objectForKey:@"IP"];
        objGraphServer.GPort = [self.objLoginPara.graphServer[i] objectForKey:@"Port"];
        objGraphServer.DBURL = [self.objLoginPara.graphServer[i] objectForKey:@"DBURL"];
        NSArray * marketIDArr = [self.objLoginPara.graphServer[i] objectForKey:@"marketID"];
        for (int j = 0; j < marketIDArr.count; j++) {
            [self.dicMarketServer_Graph setObject:objGraphServer forKey:[NSString stringWithFormat:@"%@",marketIDArr[j]]];
        }
        
    }
    NSArray * arrayMarketList = objLoginPara.marketlist;

    NSMutableDictionary * dicMarketList = [[NSMutableDictionary alloc] init];
    
    for (int i =0; i < arrayMarketList.count; i++)
    {
        //MarketList_Obj * objPara_markerList=[[MarketList_Obj alloc]init];//存储字典
        
        MarketStatusObj * objMarketStatus = [[MarketStatusObj alloc] init];
        
        JsonParse *jsonParse = [[JsonParse alloc]init];
        
        Para_MarketListObj * objPara_MarketList = [jsonParse getPara_Para_MarketListObj_objByDIC:arrayMarketList[i]];
        
        NSString *strExpiredTime = objPara_MarketList.expiretime;
        
        NSDate * dateExpiredTime = [[NetWorkManager sharedInstance] getDateFromStr2:strExpiredTime];
        
        objMarketStatus.timeDate = [dateExpiredTime timeIntervalSince1970];
        
        [dicMarketList setObject: objMarketStatus forKey:[NSString stringWithFormat:@"%ld", (long)objPara_MarketList.marketID]];
    }
    self.dicMarketStatus = dicMarketList;
    
    //设置当前时间，刷新过期判断的dic
    NSDate * dateCur = [NSDate new];
    [NetWorkManager sharedInstance].nCurTimeSec = [dateCur timeIntervalSince1970];
    
    [self refreshMarketStatus:[NetWorkManager sharedInstance].nCurTimeSec];
    
    [self connectQuoteServerWithMarketID:const_MarketID]; //启动18757行情服务
    //登录返回
    objTraderResponse.para = objLoginPara;
    [[CSocketListenerManager sharedInstance] callBack:PROTOCOL_SEL(Login) withObjcet:objTraderResponse];
}
//获取login.json数据
-(void)getLoginJsonFileForce:(BOOL)force{
    LoginParaObj * objLoginPara = self.objLoginPara;
    if (force || ![[[NetWorkManager sharedInstance] getMD5FromDocumentLoginJsonFile] isEqualToString:objLoginPara.MD5])
    {
        
        NSLog(@"获取login.json ...");
        dispatch_queue_t queue = dispatch_queue_create("com.tt.socket.dowload", DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(queue, ^{
            [fileCache queryDataForKey:const_strLoginJsonFileName completion:^(NSData *data) {
                
                @autoreleasepool {
                    BOOL bSaveDB = NO;
                    if (!data) {
                        
                        NSURLResponse *response = nil;
                        NSHTTPURLResponse *httpresponse = nil;
                        
                        NSURL    *url = [NSURL URLWithString:[objLoginPara.URL stringByAppendingString:const_strLoginJsonFileName]];
                        
                        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
                        
                        NSError *error = nil;
                        data = [NSURLConnection sendSynchronousRequest:request
                                                               returningResponse:&response
                                                                           error:&error];
                        
                        httpresponse = (NSHTTPURLResponse *) response;
                        
                        /* 下载的数据 */
                        
                        if (data != nil && (httpresponse.statusCode /100) == 2 ){
                            //缓存文件
                            [fileCache storeFile:data forKey:const_strLoginJsonFileName];
                            NSString *strMD5 = objLoginPara.MD5;
                            [[NetWorkManager sharedInstance] saveMD5FileWithStrMD5:strMD5];
                            
                        }else{
                            NSLog(@"login.json 获取失败");
                        }
                        bSaveDB = YES;
                    }

                    NSDictionary *dicfile = nil;
                    if (data) {
                        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                        
                        NSString *string = [[NSString alloc] initWithData:data encoding:enc];
                        
                        NSData *dicData = [string dataUsingEncoding:NSUTF8StringEncoding];
                        
                        dicfile = [NSJSONSerialization JSONObjectWithData:dicData options:NSJSONReadingMutableLeaves error:nil];

                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self handleLoginJsonData:dicfile saveSearchDB:bSaveDB];
                        [[CSocketListenerManager sharedInstance] callBack:PROTOCOL_SEL(LoginJson) withObjcet:dicfile];
                    });
                    
                }
            }];
       });
        
    }else{
        [fileCache queryDataForKey:const_strLoginJsonFileName completion:^(NSData *data) {
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            
            NSString *string = [[NSString alloc] initWithData:data encoding:enc];
            
            NSData *dicData = [string dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary *dicfile = [NSJSONSerialization JSONObjectWithData:dicData options:NSJSONReadingMutableLeaves error:nil];
            [self handleLoginJsonData:dicfile saveSearchDB:NO];
            [[CSocketListenerManager sharedInstance] callBack:PROTOCOL_SEL(LoginJson) withObjcet:dicfile];
            
        }];
    }
    

}
//处理login.json数据
- (void)handleLoginJsonData:(NSDictionary*)dic  saveSearchDB:(BOOL) bSaveSearch{
    SearchDBManager *manager = [SearchDBManager sharedInstance];

    if (!bSaveSearch) {    //如果Login文件存在，还要判断数据库是否存储过数据
        if (![manager haveSavedData]) {
            bSaveSearch = YES;     //如果没有存储过数据，需要存储
        }
    }
    if (bSaveSearch) {
        [manager resetDataBase];
    }
    if ([dic objectForKey:@"tags"]) {
        
        NSMutableDictionary *dicMarketTag = [[NSMutableDictionary alloc]init];
        
        NSMutableDictionary *dicMarketTag_Order = [[NSMutableDictionary alloc]init];
        
        NSArray *tagsArr = [dic objectForKey:@"tags"];
        
        NSMutableArray * arrayTagsOrder = [NSMutableArray array];
        
        for (int i = 0; i < tagsArr.count; i++)
        {
            
            if ([[[tagsArr objectAtIndex:i]objectForKey:@"parentID"]integerValue]==0) {
                
                JsonParse *jsonParse = [[JsonParse alloc]init];
                
                Login_Tags_Obj * obj_LoginJson_tags = [jsonParse getLoginJson_Tags_ObjByDIC:tagsArr[i]];
                
                Tags_Obj * obj_tag = [[Tags_Obj alloc]init];
                
                obj_tag.name = obj_LoginJson_tags.name ;
                
                obj_tag.ID = obj_LoginJson_tags.ID;
                
                obj_tag.order = obj_LoginJson_tags.order;
                
                obj_tag.parentID = obj_LoginJson_tags.parentID;
                
                [dicMarketTag setObject:obj_tag forKey:[NSString stringWithFormat:@"%lu",(unsigned long)obj_tag.ID]];
                
                [dicMarketTag_Order setObject:obj_tag forKey:obj_tag.order];
                
                [arrayTagsOrder addObject:obj_tag.order];
                
            }
        }
        
        //市场信息
        NSArray *arrayTagID = [dicMarketTag allKeys];
        
        NSMutableDictionary *dicMarketTag_ByParentID_SortOut = [NSMutableDictionary dictionary];
        
        for (NSString *tag_ID in arrayTagID) {
            
            NSMutableArray * arr_obj_tag = [NSMutableArray array];
            
            for (int i = 0; i < tagsArr.count; i++)
            {
                if ([[[tagsArr objectAtIndex:i]objectForKey:@"parentID"]integerValue]!=0)
                {
                    
                    if ([tag_ID integerValue] == [[[tagsArr objectAtIndex:i]objectForKey:@"parentID"]integerValue])
                    {
                        
                        JsonParse *jsonParse = [[JsonParse alloc]init];
                        
                        Login_Tags_Obj * obj_LoginJson_tags = [jsonParse getLoginJson_Tags_ObjByDIC:tagsArr[i]];
                        
                        Tags_Obj * obj_tag = [[Tags_Obj alloc]init];
                        
                        obj_tag.name = obj_LoginJson_tags.name ;
                        
                        obj_tag.ID = obj_LoginJson_tags.ID;
                        
                        obj_tag.order = obj_LoginJson_tags.order;
                        
                        obj_tag.parentID = obj_LoginJson_tags.parentID;
                        
                        [arr_obj_tag addObject:obj_tag]; //二级tagg数组
                        
                    }
                    
                }
            }
            
            NSMutableDictionary *dic_sub_MarketTag_ByParentID_SortOut = [NSMutableDictionary dictionary];
            
            for (Tags_Obj * objTags in arr_obj_tag) {
                
                NSMutableArray * arr_sub_obj_tag = [NSMutableArray array];
                
                for (int i = 0; i < tagsArr.count; i++)
                {
                    if ([[[tagsArr objectAtIndex:i]objectForKey:@"parentID"]integerValue]!=0)
                    {
                        
                        if (objTags.ID == [[[tagsArr objectAtIndex:i]objectForKey:@"parentID"]integerValue])
                        {
                            
                            JsonParse *jsonParse = [[JsonParse alloc]init];
                            
                            Login_Tags_Obj * obj_LoginJson_tags = [jsonParse getLoginJson_Tags_ObjByDIC:tagsArr[i]];
                            
                            Tags_Obj * obj_tag = [[Tags_Obj alloc]init];
                            
                            obj_tag.name = obj_LoginJson_tags.name ;
                            
                            obj_tag.ID = obj_LoginJson_tags.ID;
                            
                            obj_tag.order = obj_LoginJson_tags.order;
                            
                            obj_tag.parentID = obj_LoginJson_tags.parentID;
                            
                            [arr_sub_obj_tag addObject:obj_tag]; //三级tag数组
                            
                            
                            
                        }
                        
                    }
                }
                [dic_sub_MarketTag_ByParentID_SortOut setObject:arr_sub_obj_tag forKey:[NSString stringWithFormat:@"%lu",(unsigned long)objTags.ID]]; //二级tag 中三级tag数组 索引
                
            }
            
            
            [dicMarketTag_ByParentID_SortOut setObject:arr_obj_tag forKey:tag_ID]; //二级tag索引
            
        }
        
        self.dicMarketTag = dicMarketTag;
        
        self.arrayOrder =  [NSMutableArray arrayWithArray: [arrayTagsOrder sortedArrayUsingSelector:@selector(compare:)]];
        
        self.dicMarketTag_Order = dicMarketTag_Order;
        
        self.dicMarketTag_ByParentID_SortOut = dicMarketTag_ByParentID_SortOut;
        
        
    }
    
    if ([dic objectForKey:@"tagrelation"]) {
        
        NSArray *tagrelationArray = [dic objectForKey:@"tagrelation"];
        
        NSMutableDictionary *dicMarketTagrelation = [[NSMutableDictionary alloc]init];
        
        for (int i = 0; i < tagrelationArray.count; i++)
        {
            
            NSDictionary * dict = tagrelationArray[i];
            
            [dicMarketTagrelation setObject:[dict objectForKey:@"mpcodes"] forKey:[NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]]];
            
        }
        
        self.dicMarketTagrelation = dicMarketTagrelation;
        
    }
    
    if ([dic objectForKey:@"menus"]) {
        
        NSArray *menusArray = [dic objectForKey:@"menus"];
        
        NSMutableDictionary *dicMarketMenus_ID = [[NSMutableDictionary alloc]init];
        NSMutableDictionary *dicMarketMenus_Order = [[NSMutableDictionary alloc]init];
        NSMutableArray * arrayMenusOrder = [NSMutableArray array];
        for (int i = 0; i < menusArray.count; i++)
        {
            /*
             {
             "categoryid": 11,
             "id": 3,
             "ispublic": 1,
             "name": "∏€π…",
             "orderby": 1005,
             "position": 2,
             "type": 2,
             "url": "http: //www.nike.com.cn"
             },
             */
            
            NSDictionary * dic = menusArray[i];
            
            LoginJson_menus_Obj * obj_menus = [[LoginJson_menus_Obj alloc]init];
            
            obj_menus.categoryid = [dic objectForKey:@"categoryid"] ;
            
            obj_menus.ID = [dic objectForKey:@"id"];
            
            obj_menus.ispublic = [dic objectForKey:@"ispublic"];
            
            obj_menus.name = [dic objectForKey:@"name"];
            
            obj_menus.orderby = [dic objectForKey:@"orderby"] ;
            
            obj_menus.position = [dic objectForKey:@"position"];
            
            obj_menus.type = [dic objectForKey:@"type"];
            
            obj_menus.url = [dic objectForKey:@"url"];
            
            if ([obj_menus.type integerValue] == 1) {
                
                [dicMarketMenus_ID setObject:obj_menus forKey:[NSString stringWithFormat:@"%@",obj_menus.ID]];
                
                [dicMarketMenus_Order setObject:obj_menus forKey:[NSString stringWithFormat:@"%@",obj_menus.orderby]];
                
                [arrayMenusOrder addObject:obj_menus.orderby];
                
            }
            
            
        }
        
        self.dicMarketMenus = dicMarketMenus_ID;
        self.dicMarketMenus_Order = dicMarketMenus_Order;
        self.arrayMenusOrder = [NSMutableArray arrayWithArray: [arrayMenusOrder sortedArrayUsingSelector:@selector(compare:)]];
        
    }
    
    
    //MCL obj数据存储
    if ([dic objectForKey:@"MCL"]) {
        
        NSArray *arrayMessageCenterList = [dic objectForKey:@"MCL"];
        
        NSMutableDictionary * dicMessageCenterJsonfile = [NSMutableDictionary dictionary];
        
        //  NSMutableArray *arr =[NSMutableArray array];
        
        for (int i=0; i<arrayMessageCenterList.count; i++) {
            
            LoginJson_MCL_Obj * objPara_MCL = [[LoginJson_MCL_Obj alloc ] init];//解析字典
            
            MessageCenterList_Obj * objMessageCenterList = [[MessageCenterList_Obj alloc] init];//存储字典
            
            JsonParse *jsonParse = [[JsonParse alloc]init];
            
            objPara_MCL = [jsonParse getLoginJson_MCL_ObjByDIC:arrayMessageCenterList[i]];
            
            //[objPara_MCL setValuesForKeysWithDictionary:arrayMessageCenterList[i]];
            
            objMessageCenterList.strURL = objPara_MCL.URL;
            
            objMessageCenterList.strName = objPara_MCL.name;
            
            
            [dicMessageCenterJsonfile setObject:objMessageCenterList forKey:[NSString stringWithFormat:@"%ld", (long)objPara_MCL.ID]];
            
            // [arr addObject:dicMessageCenterJsonfile];
            
            // DLog(@"%@",arr);
            
        }
        
        self.dicMessageCenterJsonfile = dicMessageCenterJsonfile;
        
    }
    
    
    
    //OCTDic obj数据存储
    if ([dic objectForKey:@"OCTDic"]) {
        
        NSArray *arrayOCTDic_obj = [dic objectForKey:@"OCTDic"];
        
        LoginJson_OCTDic_obj *obj_LoginJson_OCTDic = [[LoginJson_OCTDic_obj alloc]init];
        
        OCTDic_Obj *obj_OCTDic = [[OCTDic_Obj alloc]init];
        
        NSMutableDictionary * dicOCTDic = [[NSMutableDictionary alloc] init];
        
        
        for (int i=0; i<arrayOCTDic_obj.count; i++) {
            
            
            JsonParse *jsonParse = [[JsonParse alloc]init];
            
            obj_LoginJson_OCTDic = [jsonParse getLoginJson_OCTDic_objByDIC:arrayOCTDic_obj[i]];
            
            //[obj_LoginJson_OCTDic setValuesForKeysWithDictionary:arrayOCTDic_obj[i]];
            
            obj_OCTDic.arrayOTCT = obj_LoginJson_OCTDic.OTCT;
            
            
            obj_OCTDic.arrayWeek = obj_LoginJson_OCTDic.week;
            
            //            obj_OCTDic.dicWeek = obj_LoginJson_OCTDic.dicWeek;
            //
            //            obj_OCTDic.dicWeekSign = obj_LoginJson_OCTDic.dicWeekSign;
            
            NSMutableArray *arrayOpenCloseTime = [NSMutableArray arrayWithCapacity:7];
            
            for (int h=0; h<7; h++) {
                
                NSMutableArray *array = [NSMutableArray array];
                
                [arrayOpenCloseTime addObject:array];
            }
            
            
            for (int j=0; j<obj_OCTDic.arrayOTCT.count; j++) {
                
                
                LoginJson_opencloseTime_obj *obj_opencloseTime = [[LoginJson_opencloseTime_obj alloc]init];
                
                
                
                JsonParse *jsonParse = [[JsonParse alloc]init];
                
                obj_opencloseTime = [jsonParse getLoginJson_opencloseTime_objByDIC:obj_OCTDic.arrayOTCT[j]];
                
                // [obj_opencloseTime setValuesForKeysWithDictionary:obj_OCTDic.arrayOTCT[j]];
                
                
                
                //[arrayTime addObject:openclose_obj];
                for (int k=0; k<obj_LoginJson_OCTDic.week.count; k++) {
                    
                    OpenCloseTime_Obj *openclose_obj = [[OpenCloseTime_Obj alloc]init];
                    
                    openclose_obj.strClosetime = obj_opencloseTime.closetime;
                    
                    openclose_obj.strOpentime = obj_opencloseTime.opentime;
                    
                    //NSLog(@"k:%d",k);
                    
                    int nWeek = [[obj_LoginJson_OCTDic.week objectAtIndex:k ] intValue];
                    
                    //NSLog(@"week:%d",nWeek);
                    
                    NSMutableArray *array = [arrayOpenCloseTime objectAtIndex:nWeek];
                    
                    //                    openclose_obj.nDay = [[obj_OCTDic.dicWeek valueForKey:[NSString stringWithFormat:@"%d",nWeek]] intValue];
                    //
                    //
                    //                    openclose_obj.strSign = [obj_OCTDic.dicWeekSign valueForKey:[NSString stringWithFormat:@"%d",nWeek]];
                    
                    [array addObject:openclose_obj];
                }
                
            }
            
            
            
            [dicOCTDic setObject:arrayOpenCloseTime forKey:[NSString stringWithFormat:@"%ld", (long)obj_LoginJson_OCTDic.index]];
            
        }
        
        self.dicOCTDic = dicOCTDic;
        
        // self.arrayOpenCloseTime = arrayOpenCloseTime;
        
    }
    
    //marketlist obj数据存储  MerpList Obj数据存储
    if ([dic objectForKey:@"marketlist"]) {

        NSArray *arrayMarketlist = [dic objectForKey:@"marketlist"];
        
        NSMutableDictionary *dicMarket = [[NSMutableDictionary alloc]init];
        
        NSMutableDictionary *dicMarketIndex = [[NSMutableDictionary alloc]init];

        NSMutableDictionary *dicMarketName = [[NSMutableDictionary alloc]init];
        
        NSMutableArray *arrayMarket = [[NSMutableArray alloc]init];
        
        NSMutableArray *arrayMarketName = [[NSMutableArray alloc]init];
        
        
        //        NSArray *arrayId = [dicMarketTagName allKeys];
        //
        //        NSMutableDictionary *dicMarketTag = [NSMutableDictionary dictionary];
        //
        //        for (NSString *tag in arrayId) {
        //            [dicMarketTag setObject:[NSMutableDictionary dictionary] forKey:tag];
        //        }
        //
        NSMutableDictionary *dic_All_obj_MerpList = [[NSMutableDictionary alloc]init];
        
        for (int i=0; i<arrayMarketlist.count; i++) {
            
            
            LoginJson_marketlist_Obj *obj_LoginJson_marketlist = [[LoginJson_marketlist_Obj alloc]init];
            
            MarketID_Obj *obj_MarketID = [[MarketID_Obj alloc]init];
            
            JsonParse *jsonParse = [[JsonParse alloc]init];
            
            obj_LoginJson_marketlist = [jsonParse getLoginJson_marketlist_ObjByDIC:arrayMarketlist[i]];
            
            
            obj_MarketID.strName = obj_LoginJson_marketlist.name;
            
            obj_MarketID.nType =obj_LoginJson_marketlist.type;
            
            obj_MarketID.nIndex = obj_LoginJson_marketlist.index;
            
            obj_MarketID.nUnit = obj_LoginJson_marketlist.unit;
            
            [dicMarketName setObject:obj_MarketID forKey:[NSString stringWithFormat:@"%ld", (long)obj_LoginJson_marketlist.marketID]];
            
            NSMutableDictionary *dicMerpList = [[NSMutableDictionary alloc]init];
            
            for (int j=0; j<obj_LoginJson_marketlist.merplist.count; j++) {
                
                LoginJson_MerpList_Obj *obj_LoginJson_MerpList = [[LoginJson_MerpList_Obj alloc]init];
                
                MerpList_Obj *obj_MerpList = [[MerpList_Obj alloc]init];
                
                JsonParse *jsonParse = [[JsonParse alloc]init];
                
                obj_LoginJson_MerpList = [jsonParse getLoginJson_MerpList_ObjByDIC:obj_LoginJson_marketlist.merplist[j]];
                
                //[obj_LoginJson_MerpList setValuesForKeysWithDictionary:obj_LoginJson_marketlist.merplist[j]];
                
                obj_MerpList.dDiff = obj_LoginJson_MerpList.diff;
                
                obj_MerpList.nIndex = obj_LoginJson_MerpList.index;
                
                obj_MerpList.strMpname = obj_LoginJson_MerpList.mpname;
                
                obj_MerpList.nPrecision = obj_LoginJson_MerpList.precision;
                
                obj_MerpList.nUnit = obj_LoginJson_MerpList.unit;
                
                obj_MerpList.nOpt = obj_LoginJson_MerpList.opt;
                
                obj_MerpList.strDataDate = obj_LoginJson_MerpList.dd;
                
                obj_MerpList.strMpcode = obj_LoginJson_MerpList.mpcode;
                
                obj_MerpList.dSetp = obj_LoginJson_MerpList.dStep*pow(10 , -obj_MerpList.nPrecision) ;
                obj_MerpList.nDd = obj_LoginJson_MerpList.dd;
            
                               //建立开盘收盘数组
                NSMutableArray * arrayOCT_All = [[NSMutableArray alloc] init];
                
                for (int h=0; h<7; h++) {
                    
                    NSMutableArray *array = [NSMutableArray array];
                    
                    [arrayOCT_All addObject:array];
                }
                
                
                for ( NSNumber *nNumIndex in obj_LoginJson_MerpList.OCTlist)
                {
                    
                    int nIndex = [nNumIndex intValue];
                    NSString * strIndex = [NSString stringWithFormat:@"%d",(int)nIndex];
                    
                    NSMutableArray *arrayOCT_Tmp= [self.dicOCTDic objectForKey:strIndex];
                    
                    for (int i = 0; i< arrayOCT_Tmp.count; i++)
                    {
                        
                        if ([arrayOCT_Tmp[i] count])//判断数组为nil时
                            
                            arrayOCT_All[i] = arrayOCT_Tmp[i];
                    }
                    
                    obj_MerpList.arrayOCTlist = arrayOCT_All;
                    
                }
                
                // obj_MerpList.arrayOCTlist = obj_LoginJson_MerpList.OCTlist;
                
                
                //index为索引存储mpcode，marketID
                marketIndex_Obj *obj_marketIndex = [[marketIndex_Obj alloc]init];
                
                obj_marketIndex.strMarketID = [NSString stringWithFormat:@"%ld", (long)obj_LoginJson_marketlist.marketID];
                
                obj_marketIndex.strMpcode = obj_LoginJson_MerpList.mpcode;
                
                [dicMarketIndex setObject:obj_marketIndex forKey:[NSString stringWithFormat:@"%ld", (long)obj_MerpList.nIndex]];
                
                
                [dicMerpList setObject:obj_MerpList forKey:obj_LoginJson_MerpList.mpcode];
                [dic_All_obj_MerpList setObject:obj_MerpList forKey:[NSString stringWithFormat:@"%ld", (long)obj_MerpList.nIndex]];

                
                [arrayMarketName addObject:obj_LoginJson_MerpList.mpname];
                
                [arrayMarket addObject:obj_LoginJson_MerpList.mpcode];
                
                
                if (bSaveSearch && [const_MarketID isEqualToString:obj_marketIndex.strMarketID]) {
                    NSString *strMapId = [NSString stringWithFormat:@"%ld",(long)obj_MerpList.nIndex];
                    NSString *strIndexString = nil;
                    if ([ChineseInclude isIncludeChineseInString:obj_MerpList.strMpname]) {
                        NSString *tmpString = [PinYinForObjc chineseConvertToPinYinHead:obj_MerpList.strMpname];
                        strIndexString = [NSString stringWithFormat:@"%@%@",tmpString,obj_MerpList.strMpcode];
                    } else {
                        strIndexString = [NSString stringWithFormat:@"%@%@",obj_MerpList.strMpname,obj_MerpList.strMpcode];
                    }
                    
                    [manager insertSearchData:strMapId AndIndexString:strIndexString];
                }
                

                
            }
            
            
//            self.dicMerpList = dicMerpList;
            
            [dicMarket setObject:dicMerpList forKey:[NSString stringWithFormat:@"%ld", (long)obj_LoginJson_marketlist.marketID]];
            
            
        }
        if (bSaveSearch) {
            [manager saveContext];
            
        }

        self.dicMarketIndex = dicMarketIndex;
        
        self.dicMarket = dicMarket;
        
        self.dicMarketName = dicMarketName;
        
        self.arrayMarkrtList = arrayMarket;
        
        self.arrayMarkrtListName = arrayMarketName;
        
        self.dic_All_obj_MerpList = dic_All_obj_MerpList;
        
    }
    
    //版本号
    self.stringVersion = [dic objectForKey:@"version"];
}

//强制登录返回
- (void) parseQuitResponse: (TraderResponse *) objTraderResponse{
    [[CSocketListenerManager sharedInstance] callBack:PROTOCOL_SEL(Logout) withObjcet:objTraderResponse];

}

- (void) parseUserInfoResponse: (TraderResponse *) objTraderResponse
{
}

- (void) parseMarketListResponse: (TraderResponse *) objTraderResponse
{
}

- (void) parseChangeUserInfoResponse: (TraderResponse *) objTraderResponse
{
}

- (void) parseChangePassResponse: (TraderResponse *) objTraderResponse
{
}

- (void) parseMsgNotifyResponse: (TraderResponse *) objTraderResponse{
}



- (void) parseDiscoverSubscribeResponse: (TraderResponse *) objTraderResponse
{
    
    
}

- (void) parseSubscriptionNumberResponse: (TraderResponse *) objTraderResponse
{
    
}

- (void) parseHomepageQuery_uidResponse: (TraderResponse *) objTraderResponse
{
    
   }


- (void) parseSubscriptionNotifyResponse: (TraderResponse *) objTraderResponse
{
}

- (void)parseRaceResponse: (TraderResponse *) objTraderResponse
{
}

- (void)parseSubscriptionSearchResponse: (TraderResponse *) objTraderResponse
{
}



- (void) parseMsgCenterListResponse: (TraderResponse *) objTraderResponse
{
}


-(MerpList_Obj*)merpListObjWithMpcode:(NSString*)mpCode marketId:(NSString *)marketID{
    NSDictionary*market = self.dicMarket[marketID];
    if (market) {
        return market[mpCode];
    }else{
        return nil;
    }
}
-(MerpList_Obj*)merpListObjWithMpIndex:(NSString*)mpIndex{
    marketIndex_Obj *market = [self marketIndexByMpIndex:mpIndex];
    return [self merpListObjWithMpcode:market.strMpcode marketId:market.strMarketID];
}

//根据mpcode检索市场商品信息
-(MerpList_Obj*)merpListObjWithMpcode:(NSString*)mpCode{
    
    MerpList_Obj *obj = nil;
    for (NSString *key in self.dicMarket) {
        NSDictionary*market = self.dicMarket[key];
        obj = market[mpCode];
        if (obj) {
            obj.priceObJ = self.dicPriceData[[NSString stringWithFormat:@"%ld", (long)obj.nIndex]];
            break;
        }
        obj = nil;
    }
    return obj;
}
-(NSArray*)recommendMerpListObj{
    return [self merpLitObjByClassicID:const_recommondTag];
}
-(NSArray*)globalQihuoMarketMerpListObj{
    return [self merpLitObjByClassicID:const_GlobleMarketQihuoTag];
}

-(NSArray*)merpLitObjByClassicID:(NSString*)classicID{
    NSMutableArray * arry =[NSMutableArray array];
    NSArray *list = [self.dicMarketTagrelation objectForKey: classicID];
    for (NSNumber *mpCode in list) {
        MerpList_Obj *obj = self.dic_All_obj_MerpList[[mpCode stringValue]];
        if (obj) {
//            //获取商品的最新价
//            obj.priceObJ = self.dicPriceData[[NSString stringWithFormat:@"%ld", (long)obj.nIndex]];
//            marketIndex_Obj *markeObj = self.dicMarketIndex[[NSString stringWithFormat:@"%ld", (long)obj.nIndex]];
//            if (obj.priceObJ) {
//                NSLog(@"在市场中%@,找到商品 %@, 商品成交量 %f",markeObj.strMarketID, obj.strMpname,obj.priceObJ.fVolume);
//                
//            }else{
//                NSLog(@"在市场中%@,找到商品 %@",markeObj.strMarketID, obj.strMpname);
//                
//            }
            [arry addObject:obj];
        }else{
            NSLog(@"商品%@ 在市场中未找到",mpCode);
        }
    }
    return arry;
}

-(void)connectQuoteServerWithMarketID:(NSString *)marketID{
    QuoteServerObj *  objQuoteServer = self.dicMarketQuoteServerObj[marketID];
    if (objQuoteServer) {
        [objQuoteServer.priceSocket connectToHost:objQuoteServer.PIP onPort:[objQuoteServer.PPort integerValue]];
    }
}
-(void)disConnectQuoteServerWithMarketID:(NSString *)marketID{
    QuoteServerObj *  objQuoteServer = self.dicMarketQuoteServerObj[marketID];
    if (objQuoteServer) {
        [objQuoteServer.priceSocket disconnect];
    }

}
-(void)updateMarketInfoWithMpIndexs:(NSSet*)mpIndexs{
    
    for (NSString *key in self.dicMarketQuoteServerObj) {
        QuoteServerObj *quote = self.dicMarketQuoteServerObj[key];
        NSMutableSet * mutlSet = [NSMutableSet set];
        
        for (NSNumber *mpIndex in mpIndexs) {
            marketIndex_Obj *market = self.dicMarketIndex[[mpIndex stringValue]];
            if ([market.strMarketID isEqualToString:key]) {
                [mutlSet addObject:mpIndex];
            }
        }
        if (mutlSet.count > 0) {
            [quote.priceSocket updateMarketInfoWithMpIndexs:mutlSet];
        }
    }

}
-(marketIndex_Obj*)marketIndexByMpIndex:(NSString*)mpIndex{
    return self.dicMarketIndex[mpIndex];
}
-(GraphServerObj*)graphServerByMpIndex:(NSNumber*)mpIndex{
    marketIndex_Obj *mk = [self marketIndexByMpIndex:[mpIndex stringValue]];
    return self.dicMarketServer_Graph[mk.strMarketID];
}


-(OpenCloseTime_Obj *) getOpenCloseTime_Obj: (NSTimeInterval) nTime AndMapID:(NSString *) strMapID{
    
    OpenCloseTime_Obj *obj_OpenCloseTime = [[OpenCloseTime_Obj alloc] init];
    
    NSString * strTime = [[NetWorkManager sharedInstance] getStrFromSec:nTime];
    
    //当前礼拜几
    int nCurrentWeekDay =  (int)[[NetWorkManager sharedInstance] getWeekDay:strTime];
    
    marketIndex_Obj * objMarketIndex = [self marketIndexByMpIndex:strMapID];
    
    NSMutableDictionary *dicMerpList = [self.dicMarket objectForKey:objMarketIndex.strMarketID];
    
    MerpList_Obj *obj_MerpList = [dicMerpList objectForKey:objMarketIndex.strMpcode ];
    
    NSArray *arrayOCTlist = obj_MerpList.arrayOCTlist;
    
    NSArray *arrayOpenCloseTime = [NSArray array];
    
    arrayOpenCloseTime = [arrayOCTlist objectAtIndex:nCurrentWeekDay];
    
    NSTimeInterval nTodayZeroTime = [[NetWorkManager sharedInstance] getTimeIntervalForTodayZero];
    
    if (arrayOpenCloseTime.count) {  //如果有开收盘时间数据
        
        OpenCloseTimeInteval_Obj *obj_OpenCloseTimeInteval = [[NetWorkManager sharedInstance] getTimeIntervalFromArrayOpenCloseTime:arrayOpenCloseTime];
        
        NSTimeInterval nTodayOpenTime = obj_OpenCloseTimeInteval.nOpenTime;
        
        NSTimeInterval nTodayCloseTime = obj_OpenCloseTimeInteval.nCloseTime;
        
        
        
        NSString * strCurTime_HMS = [[NetWorkManager sharedInstance] convertDateFormatter:const_Trader_strTimeFormatter_YMDHMS targetFormatter:const_strTimeFormatter_HMS dateString:strTime];
        
        NSTimeInterval nCurTime = [[NetWorkManager sharedInstance] getSecondsFromStr:strCurTime_HMS];
        
        if (nCurTime < nTodayOpenTime) {    //需要往前推最多七天，找到一个合适的时间
            
            int nForwardWeekDay = nCurrentWeekDay-1;
            
            if (nForwardWeekDay == -1) {
                nForwardWeekDay = 6;
            }    //向前推一天
            
            OpenCloseTimeInfo_Obj *obj_ForwardOpenCloseTimeInfo = [self getForwardOCTarrayFromMapID:[strMapID integerValue] andWeek:nForwardWeekDay];
            
            OpenCloseTimeInteval_Obj *obj_ForwardOpenCloseTimeInteval = [[NetWorkManager sharedInstance] getTimeIntervalFromArrayOpenCloseTime:obj_ForwardOpenCloseTimeInfo.arrayOpenCloseTime];
            
            NSTimeInterval nForwardOpenTime = obj_ForwardOpenCloseTimeInteval.nOpenTime;
            NSTimeInterval nForwardCloseTime = obj_ForwardOpenCloseTimeInteval.nCloseTime;
            
            int nForwardCout = 1 + obj_ForwardOpenCloseTimeInfo.nCount;
            
            //合适礼拜几的零点时间戳
            NSTimeInterval nFixedZeroTime = nTodayZeroTime - nForwardCout*24*60*60;
            
            NSTimeInterval nFixedOpenTime = nFixedZeroTime + nForwardOpenTime;
            
            NSTimeInterval nFixedCloseTime = nFixedZeroTime + nForwardCloseTime;
            
            NSString * strFixedOpenTime = [[NetWorkManager sharedInstance] getStrFromSec:nFixedOpenTime];
            
            NSString * strFixedCloseTime = [[NetWorkManager sharedInstance] getStrFromSec:nFixedCloseTime];
            
            obj_OpenCloseTime.strOpentime = strFixedOpenTime;
            obj_OpenCloseTime.strClosetime = strFixedCloseTime;
            
            return obj_OpenCloseTime;
            
        } else if (nCurTime > nTodayCloseTime) {   //往后做多推七天，找到一个合适的时间，看当前这个时间点有没有落在时间段中，如果在就用这个时间段，如果没有就用今天的开收盘时间
            
            int nBackwardWeekDay = nCurrentWeekDay+1;
            
            if (nBackwardWeekDay == 7) {
                nBackwardWeekDay = 0;
            }    //向后推一天
            
            
            OpenCloseTimeInfo_Obj *obj_BackwardOpenCloseTimeInfo = [self getBackwardOCTarrayFromMapID:[strMapID integerValue] andWeek:nBackwardWeekDay];
            
            OpenCloseTimeInteval_Obj *obj_BackwardOpenCloseTimeInteval = [[NetWorkManager sharedInstance] getTimeIntervalFromArrayOpenCloseTime:obj_BackwardOpenCloseTimeInfo.arrayOpenCloseTime];
            
            
            NSTimeInterval nBackwardOpenTime = obj_BackwardOpenCloseTimeInteval.nOpenTime;
            
            NSTimeInterval nBackwardCloseTime = obj_BackwardOpenCloseTimeInteval.nCloseTime;
            
            
            
            int nBackCout = 1 + obj_BackwardOpenCloseTimeInfo.nCount;
            
            //合适礼拜几的零点时间戳
            NSTimeInterval nFixedZeroTime = nTodayZeroTime + nBackCout*24*60*60;
            
            NSTimeInterval nFixedOpenTime = nFixedZeroTime + nBackwardOpenTime;
            
            NSTimeInterval nFixedCloseTime = nFixedZeroTime + nBackwardCloseTime;
            
            if (nFixedOpenTime < nTime) {  //当前时间落在后一个开收盘时间段中
                NSString * strFixedOpenTime = [[NetWorkManager sharedInstance] getStrFromSec:nFixedOpenTime];
                
                NSString * strFixedCloseTime = [[NetWorkManager sharedInstance] getStrFromSec:nFixedCloseTime];
                
                obj_OpenCloseTime.strOpentime = strFixedOpenTime;
                obj_OpenCloseTime.strClosetime = strFixedCloseTime;
                return obj_OpenCloseTime;
            } else {  //取当天的开收盘时间
                NSTimeInterval nFixedOpenTime = nTodayZeroTime + nTodayOpenTime;
                
                NSTimeInterval nFixedCloseTime = nTodayZeroTime + nTodayCloseTime;
                
                NSString * strFixedOpenTime = [[NetWorkManager sharedInstance]getStrFromSec:nFixedOpenTime];
                
                NSString * strFixedCloseTime = [[NetWorkManager sharedInstance] getStrFromSec:nFixedCloseTime];
                
                obj_OpenCloseTime.strOpentime = strFixedOpenTime;
                obj_OpenCloseTime.strClosetime = strFixedCloseTime;
                return obj_OpenCloseTime;
            }
            
        } else {   //在开收盘时间之内，就去当前的开收盘时间
            
            NSTimeInterval nFixedOpenTime = nTodayZeroTime + nTodayOpenTime;
            
            NSTimeInterval nFixedCloseTime = nTodayZeroTime + nTodayCloseTime;
            
            NSString * strFixedOpenTime = [[NetWorkManager sharedInstance] getStrFromSec:nFixedOpenTime];
            
            NSString * strFixedCloseTime = [[NetWorkManager sharedInstance] getStrFromSec:nFixedCloseTime];
            
            obj_OpenCloseTime.strOpentime = strFixedOpenTime;
            obj_OpenCloseTime.strClosetime = strFixedCloseTime;
            return obj_OpenCloseTime;
        }
        
        
        
        
    } else {    //没有开收盘时间数据，需要往前往后推最多七天，找到一个合适的时间，落在后一个时间段则去后的，否则取前一个
        
        //向前推
        
        int nForwardWeekDay = nCurrentWeekDay-1;
        
        if (nForwardWeekDay == -1) {
            nForwardWeekDay = 6;
        }    //向前推一天
        
        OpenCloseTimeInfo_Obj *obj_ForwardOpenCloseTimeInfo = [self getForwardOCTarrayFromMapID:[strMapID integerValue] andWeek:nForwardWeekDay];
        
        OpenCloseTimeInteval_Obj *obj_ForwardOpenCloseTimeInteval = [[NetWorkManager sharedInstance] getTimeIntervalFromArrayOpenCloseTime:obj_ForwardOpenCloseTimeInfo.arrayOpenCloseTime];
        
        NSTimeInterval nForwardOpenTime = obj_ForwardOpenCloseTimeInteval.nOpenTime;
        NSTimeInterval nForwardCloseTime = obj_ForwardOpenCloseTimeInteval.nCloseTime;
        
        
        int nForwardCout = 1 + obj_ForwardOpenCloseTimeInfo.nCount;
        
        //向前推的合适礼拜几的零点时间戳
        NSTimeInterval nForwardFixedZeroTime = nTodayZeroTime - nForwardCout*24*60*60;
        
        NSTimeInterval nForwardFixedOpenTime = nForwardFixedZeroTime + nForwardOpenTime;
        
        NSTimeInterval nForwardFixedCloseTime = nForwardFixedZeroTime + nForwardCloseTime;
        
        if (nTime < nForwardCloseTime) {   //如果小于前一个时间段的收盘时间，则落在前一个时间段
            NSString * strFixedOpenTime = [[NetWorkManager sharedInstance] getStrFromSec:nForwardFixedOpenTime];
            
            NSString * strFixedCloseTime = [[NetWorkManager sharedInstance] getStrFromSec:nForwardFixedCloseTime];
            
            obj_OpenCloseTime.strOpentime = strFixedOpenTime;
            obj_OpenCloseTime.strClosetime = strFixedCloseTime;
            
            return obj_OpenCloseTime;
        }
        
        //向后推
        
        int nBackwardWeekDay = nCurrentWeekDay+1;
        
        if (nBackwardWeekDay == 7) {
            nBackwardWeekDay = 0;
        }    //向后推一天
        
        OpenCloseTimeInfo_Obj *obj_BackwardOpenCloseTimeInfo = [self getBackwardOCTarrayFromMapID:[strMapID integerValue] andWeek:nBackwardWeekDay];
        
        OpenCloseTimeInteval_Obj *obj_BackwardOpenCloseTimeInteval = [[NetWorkManager sharedInstance] getTimeIntervalFromArrayOpenCloseTime:obj_BackwardOpenCloseTimeInfo.arrayOpenCloseTime];
        
        
        NSTimeInterval nBackwardOpenTime = obj_BackwardOpenCloseTimeInteval.nOpenTime;
        
        NSTimeInterval nBackwardCloseTime = obj_BackwardOpenCloseTimeInteval.nCloseTime;
        
        
        
        int nBackCout = 1 + obj_BackwardOpenCloseTimeInfo.nCount;
        
        //合适礼拜几的零点时间戳
        NSTimeInterval nBackwardFixedZeroTime = nTodayZeroTime + nBackCout*24*60*60;
        
        NSTimeInterval nBackwardFixedOpenTime = nBackwardFixedZeroTime + nBackwardOpenTime;
        
        NSTimeInterval nBackwardFixedCloseTime = nBackwardFixedZeroTime + nBackwardCloseTime;
        
        if (nTime > nBackwardFixedOpenTime) {  //大于后一个时间段的开盘时间，则说明落在后一个时间段
            NSString * strFixedOpenTime = [[NetWorkManager sharedInstance]getStrFromSec:nBackwardFixedOpenTime];
            
            NSString * strFixedCloseTime = [[NetWorkManager sharedInstance] getStrFromSec:nBackwardFixedCloseTime];
            
            obj_OpenCloseTime.strOpentime = strFixedOpenTime;
            obj_OpenCloseTime.strClosetime = strFixedCloseTime;
            
            return obj_OpenCloseTime;
        } else {   //否则取前一个时间段
            
            NSString * strFixedOpenTime = [[NetWorkManager sharedInstance] getStrFromSec:nForwardFixedOpenTime];
            
            NSString * strFixedCloseTime = [[NetWorkManager sharedInstance] getStrFromSec:nForwardFixedCloseTime];
            
            obj_OpenCloseTime.strOpentime = strFixedOpenTime;
            obj_OpenCloseTime.strClosetime = strFixedCloseTime;
            
            return obj_OpenCloseTime;
        }
        
    }
    
    return obj_OpenCloseTime;
}

//向前推最多七天找到一个合适的开收盘时间
-(OpenCloseTimeInfo_Obj *) getForwardOCTarrayFromMapID:(NSInteger)mapID andWeek:(int)week
{
    marketIndex_Obj * objMarketIndex = [self marketIndexByMpIndex:[NSString stringWithFormat:@"%ld",(long)mapID]];
    
    NSMutableDictionary *dicMerpList = [self.dicMarket objectForKey:objMarketIndex.strMarketID];
    
    MerpList_Obj *obj_MerpList = [dicMerpList objectForKey:objMarketIndex.strMpcode ];
    
    NSArray *arrayOCTlist = obj_MerpList.arrayOCTlist;
    
    NSArray *arrayOpenCloseTime = [NSArray array];
    
    arrayOpenCloseTime = [arrayOCTlist objectAtIndex:week];
    
    //如果出现nil的情况说明当天没有开收盘时间数据，需要再向前推n天，只到推断到开收盘数据为止
    int nMaxCount = 7;
    while (arrayOpenCloseTime.count < 1)
    {
        if (nMaxCount < 1)
            break;
        
        if (week == 7)
        {
            week = 0;
        }
        
        arrayOpenCloseTime = [arrayOCTlist objectAtIndex:week];
        
        if (arrayOpenCloseTime.count) {
            break;
        }
        
        nMaxCount--;
        week++;
    }
    
    int nCount = 7 - nMaxCount;
    
    OpenCloseTimeInfo_Obj *obj_OpenCloseTimeInfo = [[OpenCloseTimeInfo_Obj alloc] init];
    obj_OpenCloseTimeInfo.nCount = nCount;
    obj_OpenCloseTimeInfo.arrayOpenCloseTime = arrayOpenCloseTime;
    obj_OpenCloseTimeInfo.nWeek = week;
    
    return obj_OpenCloseTimeInfo;
}
//向后推最多七天找到一个合适的开收盘时间
-(OpenCloseTimeInfo_Obj *) getBackwardOCTarrayFromMapID:(NSInteger)mapID andWeek:(int)week
{
    marketIndex_Obj * objMarketIndex = [self marketIndexByMpIndex:[NSString stringWithFormat:@"%ld",(long)mapID]];
    
    NSMutableDictionary *dicMerpList = [self.dicMarket objectForKey:objMarketIndex.strMarketID];
    
    MerpList_Obj *obj_MerpList = [dicMerpList objectForKey:objMarketIndex.strMpcode ];
    
    NSArray *arrayOCTlist = obj_MerpList.arrayOCTlist;
    
    NSArray *arrayOpenCloseTime = [NSArray array];
    
    arrayOpenCloseTime = [arrayOCTlist objectAtIndex:week];
    
    //如果出现nil的情况说明当天没有开收盘时间数据，需要再向前后n天，只到推断到开收盘数据为止
    int nMaxCount = 7;
    while (arrayOpenCloseTime.count < 1)
    {
        nMaxCount--;
        
        if (nMaxCount < 1)
            break;
        
        if (week == 7)
        {
            week = 0;
        }
        else
        {
            week++;
        }
        
        
        arrayOpenCloseTime = [arrayOCTlist objectAtIndex:week];
    }
    
    int nCount = 7 - nMaxCount;
    
    OpenCloseTimeInfo_Obj *obj_OpenCloseTimeInfo = [[OpenCloseTimeInfo_Obj alloc] init];
    obj_OpenCloseTimeInfo.nCount = nCount;
    obj_OpenCloseTimeInfo.arrayOpenCloseTime = arrayOpenCloseTime;
    obj_OpenCloseTimeInfo.nWeek = week;
    
    return obj_OpenCloseTimeInfo;
}



//获得一个合理的礼拜几，如果时间不在当天的开收盘时间内，需要向前推一天
- (int) getWeekDayFromMapID: (NSInteger) nMapID AndTime:(NSTimeInterval) nTime
{
    NSString * strTime = [[NetWorkManager sharedInstance]  getStrFromSec:nTime];
    
    NSInteger nWeekDay = [[NetWorkManager sharedInstance]  getWeekDay:strTime];
    
    OpenCloseTimeInfo_Obj *obj_OpenCloseTimeInfo = [self getOCTarrayFromMapID:nMapID andWeek:nWeekDay];
    
    NSArray * arrayOpenCloseTime = obj_OpenCloseTimeInfo.arrayOpenCloseTime;
    
    //如果 obj_OpenCloseTimeInfo.nCount > 0 ,说明已经往前推了，直接返回礼拜几；
    if (obj_OpenCloseTimeInfo.nCount > 0) {
        
        return obj_OpenCloseTimeInfo.nWeek;
        
    } else {   //没有往前推，需要判断当前时间是否在开盘时间之后
        
        OpenCloseTime_Obj * objOpenCloseTime_First = arrayOpenCloseTime[0];
        
        NSString * strOpenTime = objOpenCloseTime_First.strOpentime;
        
        NSTimeInterval nOpenTime = [[NetWorkManager sharedInstance] getSecondsFromStr:strOpenTime];
        
        
        NSString * strCurTime_HMS = [[NetWorkManager sharedInstance]convertDateFormatter:const_Trader_strTimeFormatter_YMDHMS targetFormatter:const_strTimeFormatter_HMS dateString:strTime];
        
        NSTimeInterval nCurTime = [[NetWorkManager sharedInstance] getSecondsFromStr:strCurTime_HMS];
        
        //判断当前时间如果在开盘时间以前，就需要再次调用getOCTarrayFromMapID，来获取开收盘信息对象
        if (nCurTime < nOpenTime)
        {
            obj_OpenCloseTimeInfo = [self getOCTarrayFromMapID:nMapID andWeek:nWeekDay-1];
            return obj_OpenCloseTimeInfo.nWeek;
            
        } else {
            return obj_OpenCloseTimeInfo.nWeek;
        }
    }
    
}

//获取开盘时间段的点array
-(NSArray *) getOpenTimePiontArrayFromMapId:(NSString *) strMapID AndTime: (NSTimeInterval) nTime
{
    //首先通过参数时间，获取开收盘时间的array
    NSInteger nWeekDay = [self getWeekDayFromMapID:[strMapID integerValue] AndTime:nTime];
    
    if (nWeekDay < 0)
    {
        return nil;
    }
    
    OpenCloseTimeInfo_Obj * Obj_OpenCloseTimeInfo = [self getOCTarrayFromMapID:[strMapID integerValue] andWeek:nWeekDay];
    
    NSArray *arrayOpenCloseTime = Obj_OpenCloseTimeInfo.arrayOpenCloseTime;
    
    //得到最开始开盘的其实时间秒数
    OpenCloseTime_Obj * objOpenCloseTime_First = arrayOpenCloseTime[0];
    //OpenCloseTime_Obj * objOpenCloseTime_Last = arrayOpenCloseTime[arrayOpenCloseTime.count -1];
    
    //int nMinuteRange = [[PublicFun Instance] getMinuteRangeFrom:objOpenCloseTime_First.strOpentime To:objOpenCloseTime_Last.strClosetime];
    
    NSInteger nBeginSec = [[NetWorkManager sharedInstance] getSecondsFromStr:objOpenCloseTime_First.strOpentime];
    
    
    int nIncrement = 0;  //时间增量,如果开盘时间比前一个收盘时间小，就加一天

    
    //遍历该array，得到开盘时间的点
    NSMutableArray * arrayPoint = [[NSMutableArray alloc ] init];
    
    for (int i = 0; i < arrayOpenCloseTime.count; i++)
    {
        if (i == 0) {
            OpenCloseTime_Obj * objOpenCloseTime = arrayOpenCloseTime[i];
            
            NSInteger nCurBeginSec = [[NetWorkManager sharedInstance] getSecondsFromStr:objOpenCloseTime.strOpentime];
            
            NSInteger nCurEndSec = [[NetWorkManager sharedInstance] getSecondsFromStr:objOpenCloseTime.strClosetime];
            
            if (nCurEndSec < nCurBeginSec) {   //第一个数据，如果收盘时间小于开盘时间，则时间增量加一天
                nIncrement += 86400;
            }
            nCurEndSec = nCurEndSec + nIncrement;
            
            //构造一个可绘制点的范围对象
            OpenTimePointObj * objOpenTimePoint = [[OpenTimePointObj alloc] init];
            
            objOpenTimePoint.nBegin = (nCurBeginSec - nBeginSec)/60;
            objOpenTimePoint.nEnd   = (nCurEndSec - nBeginSec)/60;
            
            [arrayPoint addObject:objOpenTimePoint];
        } else {
            OpenCloseTime_Obj * objFowardOpenCloseTime = arrayOpenCloseTime[i-1];
            
            NSInteger nCurForwardEndSec = [[NetWorkManager sharedInstance] getSecondsFromStr:objFowardOpenCloseTime.strClosetime];
            
            OpenCloseTime_Obj * objOpenCloseTime = arrayOpenCloseTime[i];
            
            NSInteger nCurBeginSec = [[NetWorkManager sharedInstance] getSecondsFromStr:objOpenCloseTime.strOpentime];
            
            NSInteger nCurEndSec = [[NetWorkManager sharedInstance] getSecondsFromStr:objOpenCloseTime.strClosetime];
            
            if (nCurBeginSec < nCurForwardEndSec) {    //如果小于前一个收盘时间，则时间增量加一天
                nIncrement += 86400;
            }
            
            if (nCurEndSec < nCurBeginSec) { //如果收盘时间小于开盘时间，则时间增量加一天
                nIncrement += 86400;
            }
            
            //加上累积的时间增量
            nCurBeginSec += nIncrement;
            nCurEndSec += nIncrement;
            
            //构造一个可绘制点的范围对象
            OpenTimePointObj * objOpenTimePoint = [[OpenTimePointObj alloc] init];
            
            objOpenTimePoint.nBegin = (nCurBeginSec - nBeginSec)/60;
            objOpenTimePoint.nEnd   = (nCurEndSec - nBeginSec)/60;
            
            [arrayPoint addObject:objOpenTimePoint];
            
        }
        
        
    }
    
    return arrayPoint;
}

-(OpenCloseTimeInfo_Obj *) getOCTarrayFromMapID:(NSInteger)mapID andWeek:(NSInteger)week
{
    marketIndex_Obj * objMarketIndex = [self marketIndexByMpIndex:[NSString stringWithFormat:@"%ld",(long)mapID]];
    
    NSMutableDictionary *dicMerpList = [self.dicMarket objectForKey:objMarketIndex.strMarketID];
    
    MerpList_Obj *obj_MerpList = [dicMerpList objectForKey:objMarketIndex.strMpcode ];
    
    NSArray *arrayOCTlist = obj_MerpList.arrayOCTlist;
    
    NSArray *arrayOpenCloseTime = [NSArray array];
    
    arrayOpenCloseTime = [arrayOCTlist objectAtIndex:week];
    
    //如果出现nil的情况说明当天没有开收盘时间数据，需要再向前推n天，只到推断到开收盘数据为止
    NSInteger nMaxCount = 7;
    while (arrayOpenCloseTime.count < 1)
    {
        nMaxCount--;
        
        if (nMaxCount < 1)
            break;
        
        if (week == 0)
        {
            week = 6;
        }
        else
        {
            week--;
        }
        
        
        arrayOpenCloseTime = [arrayOCTlist objectAtIndex:week];
    }
    
    NSInteger nCount = 7 - nMaxCount;
    
    OpenCloseTimeInfo_Obj *obj_OpenCloseTimeInfo = [[OpenCloseTimeInfo_Obj alloc] init];
    obj_OpenCloseTimeInfo.nCount = nCount;
    obj_OpenCloseTimeInfo.arrayOpenCloseTime = arrayOpenCloseTime;
    obj_OpenCloseTimeInfo.nWeek = week;
    
    return obj_OpenCloseTimeInfo;
}


- (NSString *) getClosePrice: (NSString *)strProductCode marketID:(NSString *)strMarketID
{
    MerpList_Obj  *obj = [self merpListObjWithMpcode:strProductCode marketId:strMarketID];
    PriceData_Obj * objPriceData = [self.dicPriceData objectForKey:[NSString stringWithFormat:@"%ld", (long)obj.nIndex]];
    return [[NetWorkManager sharedInstance] getFormatValue:objPriceData.fClosePrice merplist_obj:obj];
    
}

-(NSArray*)getSubTagForTagID:(NSString*)tagID{
    return self.dicMarketTag_ByParentID_SortOut[tagID];
}

@end
