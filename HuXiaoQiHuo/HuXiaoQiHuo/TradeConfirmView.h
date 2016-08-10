//
//  TradeConfirmView.h
//  HuXiaoQiHuo
//
//  Created by niupark on 16/6/7.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TradeConfirmViewDelegate<NSObject>
@optional
-(void)TradeConfirmViewConfirm:(BOOL)confirm;
@end
@interface TradeConfirmView : UIView{
    NSMutableDictionary * stuff;
}
@property (weak, nonatomic) IBOutlet UILabel *lblType;
@property (weak, nonatomic) IBOutlet UILabel *lblCode;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property(weak, nonatomic)id<TradeConfirmViewDelegate> deleate;
@end
