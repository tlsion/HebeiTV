//
//  HBRegisterFinishViewController.m
//  HebeiTV
//
//  Created by 智美合 on 14-5-19.
//  Copyright (c) 2014年 MyOrganization. All rights reserved.
//
#import "HBHTTPService.h"
#import "HBCustomerTextField.h"
#import "HBRegisterFinishViewController.h"
#import "HBPhoto.h"
#import "UIView+Action.h"
#import "HBLogViewController.h"
#import "HBAlertView.h"
#import "HBSettingViewController.h"
@interface HBRegisterFinishViewController ()<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIActionSheet *SexSheet,*chooseHeadPortraitSheet;
    UIImage *headPortrait;
    NSUserDefaults * userDefaults;
    
    IBOutlet UIScrollView *mainScrollView;
}

@property (strong, nonatomic) IBOutlet HBCustomerTextField *userName;
@property (strong, nonatomic) IBOutlet HBCustomerTextField *userAge;
@property (strong, nonatomic) IBOutlet HBCustomerTextField *userSex;
@property (strong, nonatomic) IBOutlet UIImageView *headView;

@end

@implementation HBRegisterFinishViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //键盘将要消失时的触发事件
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillBeHidden:)name:UIKeyboardWillHideNotification object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    mainScrollView.frame=CGRectMake(0, 0, SCREEN_MAX_WIDTH, self.view.frame.size.height);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7)
    {
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    // Do any additional setup after loading the view.
    [self.userName setTextTitle:@"昵称"];
    self.userName.keyboardType=UIKeyboardTypeDefault;
    [self.userAge setTextTitle:@"年龄"];
    [self.userSex setTextTitle:@"性别"];
    
    
    userDefaults =[NSUserDefaults standardUserDefaults];
    
    //手势回收键盘
    UITapGestureRecognizer * tapGesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoard)];
    [mainScrollView addGestureRecognizer:tapGesture1];
    
    UIButton *chooseHeadImageBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 64, 64)];
    [chooseHeadImageBtn addTarget:self action:@selector(chooseHeadPortrait) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:chooseHeadImageBtn];
    
    UIButton *chooseSexBtn=[[UIButton alloc]initWithFrame:CGRectMake(55, 0, 245, 40)];
    [chooseSexBtn addTarget:self action:@selector(chooseSexAction) forControlEvents:UIControlEventTouchUpInside];
    [self.userSex addSubview:chooseSexBtn];
    
    
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)finishAction:(id)sender {
    if (self.userName.text.length>0&&self.userSex.text.length>0&&self.userAge.text.length>0) {
        NSString *sex;
        if ([self.userSex.text isEqualToString:@"男"]) {
            sex=@"0";
        }
        else if ([self.userSex.text isEqualToString:@"女"])
        {
            sex=@"1";
        }
        
        [self.view makeToastActivity];
        
        NSMutableDictionary * paramDic=[[NSMutableDictionary alloc]init];
        
        NSString * imageBase64=@"";
        if (headPortrait) {
            imageBase64=[HBPhoto image2String:headPortrait];
        }
        [paramDic setObject:imageBase64 forKey:@"userimages"];
        [paramDic setObject:_phone forKey:@"phone"];
        [paramDic setObject:[sex stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"sex"];
        [paramDic setObject:[self.userAge.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"age"];
        [paramDic setObject:[self.userName.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"username"];
        [paramDic setObject:_passWord forKey:@"password"];
        [paramDic setObject:@"ios" forKey:@"equipment"];
        
        [HBHTTPService requestPostMethod:@"ImplUserInfosave.do" andParam:paramDic andServiceSuccessBlock:^(HBHTTPService * service) {
            if (service.status==1) {
                NSDictionary * userInfo=[service.allDataDic objectForKey:@"dataList"];
                
                AppDelegate * app=APP;
                [app updateUserInfo:userInfo];
                
                int beansCount=[[userInfo objectForKey:@"bean"] intValue];
                HBAlertView * av=[[HBAlertView alloc]initWithDuoDuoDouCount:beansCount leftButtonTitle:nil rightButtonTitle:@"确定"];
                [av show];
                av.rightBlock=^{
                    
                    for (UIViewController * viewController in self.navigationController.viewControllers) {
                        if ([viewController isKindOfClass:[HBSettingViewController class]]) {
                            [self.navigationController popToViewController:viewController animated:YES];
                        }
                    }
                };
//                for (UIViewController * viewController in self.navigationController.viewControllers) {
//                    if ([viewController isKindOfClass:[HBLogViewController class]]) {
//                        HBLogViewController * logVC=(HBLogViewController*)viewController;
//                        logVC.phoneNumber.text=_phone;
//                        logVC.passWord.text=_passWord;
//                        [self.navigationController popToViewController:viewController animated:YES];
//                        //18150376032
//                    }
//                }
            }
            else if (service.status==-2) {
                ALERT(service.msg);
            }
            else{
                ALERT(@"注册失败!");
            }
            [self.view hideToastActivity];
            
        }andServiceFailBlock:^(void){
            ALERT(@"注册失败，请重试!");
            [self.view hideToastActivity];
        }];
    }
    else
    {
        ALERT(@"请将资料填写完整");
    }

}

#pragma mark -- 触控事件
-(void)dismissKeyBoard
{
    //将整个视图的Y轴向下移150像素
    
    [self.userAge resignFirstResponder];
    [self.userName resignFirstResponder];
}
-(void)chooseSexAction
{
    [self dismissKeyBoard];
    SexSheet =[[UIActionSheet alloc]initWithTitle:@"性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
    
    [SexSheet showFromRect:self.view.bounds inView:self.view animated:YES];
}
-(void)chooseHeadPortrait
{
    [self dismissKeyBoard];
    chooseHeadPortraitSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:@"拍照"
                                                    otherButtonTitles:@"从相册中选择", nil];
    chooseHeadPortraitSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [chooseHeadPortraitSheet showInView:self.view];
}

#pragma mark ----------ActionSheet 按钮点击-------------
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet==SexSheet)
    {
        self.userSex.text=nil;
        if (buttonIndex==0) {
            self.userSex.text=@"男";
        }
        else if (buttonIndex==1)
        {
             self.userSex.text=@"女";
        }
    }
    else if(actionSheet==chooseHeadPortraitSheet)
    {
        switch (buttonIndex) {
            case 0:
                //照一张
            {
                UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
                if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
                {
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.delegate = self;
                    //设置拍照后的图片可被编辑
                    picker.allowsEditing = YES;
                    picker.sourceType = sourceType;
                    [self presentViewController:picker animated:YES completion:nil];
                }else
                {
                }
            }
                break;
            case 1:
                //搞一张
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                picker.delegate = self;
                //设置选择后的图片可被编辑
                picker.allowsEditing = YES;
             [self presentViewController:picker animated:YES completion:nil];
            }
                break;
            default:
                break;
        }
    }
}
#pragma mark ----------图片选择完成-------------
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        
        //
        //        Dataimg = UIImageJPEGRepresentation(image, 0);
        
        //关闭相册界面
        
        [picker dismissViewControllerAnimated:YES completion:^(){}];
        
        self.headView.image=image;
        headPortrait=image;
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    int flag1=setY(textField)+NAV_HEI_64;
    int flag2=SCREEN_MAX_HEIGHT-216;
    int flag3=flag1-flag2+44;
    mainScrollView.contentSize=CGSizeMake(SCREEN_MAX_WIDTH, mainScrollView.bounds.size.height +216);
    if (flag1>flag2) {
        
        [mainScrollView setContentOffset:CGPointMake(0, flag3) animated:YES];
    }
}
-(void)keyboardWillBeHidden:(id)sender{
    mainScrollView.contentSize=CGSizeMake(SCREEN_MAX_WIDTH, mainScrollView.bounds.size.height);
    [mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
