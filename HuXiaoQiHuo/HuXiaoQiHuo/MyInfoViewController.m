//
//  MyInfoViewController.m
//  HuXiaoQiHuo
//
//  Created by fukeng on 16/5/15.
//  Copyright © 2016年 fukeng. All rights reserved.
//

#import "MyInfoViewController.h"

@interface MyInfoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgHeader;
@property (weak, nonatomic) IBOutlet UILabel *sexInfo;
@property (weak, nonatomic) IBOutlet UILabel *accountName;

@property (strong, nonatomic) NSDictionary *dicInfo;
@end

@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    获取用户基本信息	http://121.43.232.204:8097/ajax/DataHandler.ashx?action=account&uname=yeliang	GET	uname（账号）
    [self getUserInfo:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getUserInfo:) name:@"userNameUpdate" object:nil];
    
    [self.view setBackgroundColor:[UIColor YColorBackGroudGray]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getUserInfo:(NSNotification *) notification{
    NSDictionary *dicInfo = @{@"uname":[GlobalValue sharedInstance].uname};
    [NetWork postDataWithServer:@"http://121.43.232.204:8097/ajax/DataHandler.ashx?action=account" sendDic:dicInfo kind:HttpRequstLoading tips:@"" target:self userInfo:nil callback:^(NSDictionary *dic) {
        self.dicInfo = dic[@"Data"];
        [self.imgHeader sd_setImageWithURL:dic[@"Data"][@"Avatar"] placeholderImage:[UIImage imageNamed:@"userName"]];
        self.sexInfo.text = dic[@"Data"][@"Sex"];
        self.accountName.text = [GlobalValue sharedInstance].uname;
    }errorCallback:^(NSDictionary *resultDic) {
        
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - action
- (IBAction)nickNameAction:(UIButton *)sender {
    [self performSegueWithIdentifier:@"NickNameViewController" sender:self.dicInfo];
}

- (IBAction)sexAction:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //按钮：从相册选择，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.sexInfo.text = @"男";
        [self saveInformation];
    }]];
    //按钮：拍照，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        self.sexInfo.text = @"女";
        [self saveInformation];
    }]];
    //按钮：取消，类型：UIAlertActionStyleCancel
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}


- (IBAction)headerAction:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //按钮：从相册选择，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //初始化UIImagePickerController
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式1：通过相册（呈现全部相册），UIImagePickerControllerSourceTypePhotoLibrary
        //获取方式2，通过相机，UIImagePickerControllerSourceTypeCamera
        //获取方法3，通过相册（呈现全部图片），UIImagePickerControllerSourceTypeSavedPhotosAlbum
        PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //允许编辑，即放大裁剪
        PickerImage.allowsEditing = YES;
        //自代理
        PickerImage.delegate = self;
        //页面跳转
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：拍照，类型：UIAlertActionStyleDefault
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        /**
         其实和从相册选择一样，只是获取方式不同，前面是通过相册，而现在，我们要通过相机的方式
         */
        UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
        //获取方式:通过相机
        PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        PickerImage.allowsEditing = YES;
        PickerImage.delegate = self;
        [self presentViewController:PickerImage animated:YES completion:nil];
    }]];
    //按钮：取消，类型：UIAlertActionStyleCancel
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];

}

//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
//    上传修改图片	http://121.43.232.204:8098/ashx/uploadImg.ashx?action=upload&uname=yeliang&pwd=e10adc3949ba59abbe56e057f20f883e	POST	"UNAME(账号) pwd(MD5密码)
    //    file控件名(fsource)"
    NSDictionary *dicSend = @{@"uname":[GlobalValue sharedInstance].uname,
                              @"pwd": [Request getMD5:[GlobalValue sharedInstance].pwd],
                              @"fsource":@"fsource"};
    
    [NetWork postFileDataWithServer:@"http://121.43.232.204:8098/ashx/uploadImg.ashx?action=upload" sendDic:dicSend file:[NSString stringWithFormat:@"%@.png", [GlobalValue sharedInstance].uname] image:newPhoto kind:HttpRequstSubmit tips:@"正在上传图片..." target:self userInfo:nil callback:^(NSDictionary *resultDic) {
        NSLog(@"resultDic:%@", resultDic);
        self.imgHeader.image = newPhoto;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAVator" object:nil];
    } errorCallback:^(NSDictionary *resultDic) {
        
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)saveInformation{
//    修改用户资料	http://121.43.232.204:8097/ajax/DataHandler.ashx?action=modify	POST	uname（账号）
//    pwd（密码）
//    nickname（昵称）	非空
//    sex（性别）	默认为男
    NSDictionary *dicInfo = @{@"uname":[GlobalValue sharedInstance].uname,
                              @"pwd": [Request getMD5:[GlobalValue sharedInstance].pwd],
                              @"nickname":self.dicInfo[@"NickName"],
                              @"sex":self.sexInfo.text};
    [NetWork postDataWithServer:@"http://121.43.232.204:8097/ajax/DataHandler.ashx?action=modify" sendDic:dicInfo kind:HttpRequstSubmit tips:@"正在提交信息" target:self userInfo:nil callback:^(NSDictionary *dic) {
        NSLog(@"saveInformation=%@", dic);
    }errorCallback:^(NSDictionary *resultDic) {
        
    }];
    
}

@end
