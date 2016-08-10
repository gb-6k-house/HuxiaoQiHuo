//
//  TradeConfirmView.m
//  HuXiaoQiHuo
//
//  Created by niupark on 16/6/7.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "TradeConfirmView.h"

@implementation TradeConfirmView
-(id)valueForUndefinedKey:(NSString *)key
{
    id value = [stuff valueForKey:key];
    
    return (value);
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if(stuff==nil){
        stuff=[[NSMutableDictionary alloc] init];
    }
    
    [stuff setObject:value forKey:key];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)cancel:(id)sender {
    if (self.deleate&&[self.deleate respondsToSelector:@selector(TradeConfirmViewConfirm:)]) {
        [self.deleate TradeConfirmViewConfirm:NO];
    }
}
- (IBAction)confirm:(id)sender {
    if (self.deleate&&[self.deleate respondsToSelector:@selector(TradeConfirmViewConfirm:)]) {
        [self.deleate TradeConfirmViewConfirm:YES];
    }

}

@end
