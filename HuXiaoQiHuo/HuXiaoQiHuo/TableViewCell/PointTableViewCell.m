//
//  PointTableViewCell.m
//  HuXiaoQiHuo
//
//  Created by fukeng on 1/6/16.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "PointTableViewCell.h"

@implementation PointTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)refreshUI:(NSDictionary*)dic{
//    {
//        ContentText = "<span id=\"paperTitle\" style=\"color:#000000;padding-top:25px;display:block;-ms-word-break:break-all;\"";
//        CreateDate = "2016-05-12T14:13:31";
//        CreateUser = kaimenhong;
//        CreateUserID = 1355;
//        ID = 2530;
//        IsDigest = 0;
//        IsOriginal = 0;
//        Plate = 3;
//        Title = "\U80a1\U7968\U5341\U62db";
//        UpdateDate = "<null>";
//    }
//    {"Code":0,"Msg":"7","Data":[{"ID":2503,"Title":"ddcds","Plate":3,"ContentText":"dfadfsdsfadsfadsfadsf","CreateDate":"2016-03-18T17:36:43","UpdateDate":null,"CreateUser":"yeliang","CreateUserID":4,"IsDigest":false,"IsOriginal":true},{"ID":2484,"Title":"ffffrrr","Plate":3,"ContentText":"qqqq<img alt=\"\" src=\"http://121.43.232.204:8098/upload/2016031703012793DZ8HNUXG.jpg\" />f","CreateDate":"2016-03-17T14:42:13","UpdateDate":null,"CreateUser":"yeliang","CreateUserID":4,"IsDigest":false,"IsOriginal":false}]}
//    id:文章ID,title:标题,plate:板块 固定为3(国际期货),contenttext:正文,createdate:创建日期,updatedate:更新日期,createuser:作者名,createuserid:作者ID,isigest:是否精品,isoriginal:是否原创
   
    self.name.text = dic[@"CreateUser"];
    self.time.text = [ToolCore strFromTimeStr:dic[@"CreateDate"] format:@"yyyy-MM-dd HH:mm:ss"];
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[dic[@"ContentText"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor YColorGray] range:NSMakeRange(0,attrStr.length)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:14.0] range:NSMakeRange(0, attrStr.length)];
    self.content.attributedText = attrStr;
//    self.attchImg = nil;
    
}

@end
