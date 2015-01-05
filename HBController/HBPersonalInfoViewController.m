//
//  HBPersonalInfoViewController.m
//  HebeiTV
//
//  Created by Pro on 6/6/14.
//  Copyright (c) 2014 MyOrganization. All rights reserved.
//

#import "HBPersonalInfoViewController.h"
#import "EGOImageView.h"
#import "HBCustomerTextField.h"
#import "UIView+Action.h"
#import "HBPhoto.h"
@interface HBPersonalInfoViewController ()<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIActionSheet *SexSheet,*chooseHeadPortraitSheet;
    UIImage *headPortrait;
    NSUserDefaults * userDefaults;
    IBOutlet UILabel *phoneNumberLabel;
    
    IBOutlet UILabel *passwordLabel;
    
    IBOutlet UILabel *myBeansLabel;
    
    IBOutlet UIView *passwordSelectBgView;
    
    IBOutlet EGOImageView * headImageView;
    

    IBOutlet UIScrollView *mainScrollView;
}

@property (strong, nonatomic) IBOutlet HBCustomerTextField *userName;
@property (strong, nonatomic) IBOutlet HBCustomerTextField *userAge;
@property (strong, nonatomic) IBOutlet HBCustomerTextField *userSex;
@end

@implementation HBPersonalInfoViewController

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
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mainScrollView.frame=CGRectMake(0, NAV_HEI_64, SCREEN_MAX_WIDTH, SCREEN_MAX_HEIGHT-NAV_HEI_64);
    
    // Do any additional setup after loading the view.
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changePasswordAction)];
    [passwordSelectBgView addGestureRecognizer:tap];
    
    userDefaults=[NSUserDefaults standardUserDefaults];
    NSString * beansCount=[NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"beanscount"]];
    NSString * phone=[NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"phone"]];
    NSString * password=[NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"password"]];
    NSString * imageURL=[NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"userimages"]];
    NSString * age=[NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"age"]];
    NSString * sex=[NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"sex"]];
    if ([sex isEqualToString:@"0"]) {
        sex=@"男";
    }else if ([sex isEqualToString:@"1"]){
        sex=@"女";
    }
    NSString * username=[NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"username"]];
    NSMutableString * starPassword=[NSMutableString string];
    for (int i=0; i<password.length; i++) {
        [starPassword appendString:@"*"];
    }
    phoneNumberLabel.text=phone;
    passwordLabel.text=starPassword;
    myBeansLabel.text=beansCount;
    headImageView.imageURL=IMG_URL(imageURL);
    
    [self.userName setTextTitle:@"昵称"];
    [self.userAge setTextTitle:@"年龄"];
    [self.userSex setTextTitle:@"性别"];
    self.userName.text=username;
    self.userSex.text=sex;
    self.userAge.text=age;
    
    //手势回收键盘
    UITapGestureRecognizer * tapGesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoard)];
    [mainScrollView addGestureRecognizer:tapGesture1];
    
    UITapGestureRecognizer * headTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseHeadPortrait)];
    [headImageView addGestureRecognizer:headTapGesture];
    
    UIButton *chooseSexBtn=[[UIButton alloc]initWithFrame:CGRectMake(55, 0, 245, 40)];
    [chooseSexBtn addTarget:self action:@selector(chooseSexAction) forControlEvents:UIControlEventTouchUpInside];
    [self.userSex addSubview:chooseSexBtn];
    
}
-(void)changePasswordAction{
    [self performSegueWithIdentifier:@"ChangePasswordPush" sender:self];
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)comfireChangeAction:(id)sender {
    [self dismissKeyBoard];
    [self updateUserInfo];
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
        
        headImageView.image=image;
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

-(void)updateUserInfo{
//    ImplUserInfoupdate.do {
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
        [paramDic setObject:[sex stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"sex"];
        [paramDic setObject:[self.userAge.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"age"];
        [paramDic setObject:[self.userName.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"username"];
        [paramDic setObject:[[NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"userId"]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"userId"];
        
        [HBHTTPService requestPostMethod:@"ImplUserInfoupdate.do" andParam:paramDic andServiceSuccessBlock:^(HBHTTPService * service) {
            if (service.status==1) {
                AppDelegate * app=APP;
                [app updateUserInfo:service.dataDic];
                ALERT(@"修改成功!");
            }
            else if (service.status==-2) {
                ALERT(service.msg);
            }
            else{
                ALERT(@"修改失败!");
            }
            [self.view hideToastActivity];
            
        }andServiceFailBlock:^(void){
            ALERT(@"修改失败，请重试!");
            [self.view hideToastActivity];
        }];
    }
    else
    {
        ALERT(@"资料填写不完整!");
    }
    
}
- (void)didReceiveMemoryWarningui
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
