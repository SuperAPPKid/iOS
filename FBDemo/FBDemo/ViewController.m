//
//  ViewController.m
//  FBDemo
//
//  Created by user37 on 2018/1/19.
//  Copyright © 2018年 user37. All rights reserved.
//

#import "ViewController.h"
@import FBSDKCoreKit;
@import FBSDKLoginKit;
@import FBSDKShareKit;
@import FBSDKMessengerShareKit;
@import Social;

@interface ViewController () <FBSDKLoginButtonDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;
@property (weak, nonatomic) IBOutlet FBSDKProfilePictureView *pictureView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginButton.layer.cornerRadius = 30;
    self.nameLabel.layer.cornerRadius = 20;
    
    self.loginButton.readPermissions =
    @[@"public_profile", @"email", @"user_friends"];
    self.loginButton.delegate = self;
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(updateProfile)
     name:FBSDKProfileDidChangeNotification object:nil];
    [self updateProfile];
    [self requestMe];
}

-(void)requestMe{
    //先判斷是否有token存在
    if ( [FBSDKAccessToken currentAccessToken]){
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:nil];
        [request startWithCompletionHandler:
         ^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             NSLog(@"%@",result);
             NSDictionary *info = result;
             NSLog(@"email = %@",info[@"email"]);
             NSLog(@"birthday = %@",info[@"birthday"]);
         }];
    }
}
- (IBAction)post:(id)sender {
    //一定要有facebook app才能測試
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fbapi://"]] ){
        FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc]init];
        photo.image = [UIImage imageNamed:@"cat"];
        photo.userGenerated = YES;
        FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc]init];
        content.photos = @[photo];
        [FBSDKShareDialog showFromViewController:self withContent:content delegate:self];
    }
    //模擬器測試
    FBSDKShareLinkContent *linkContent = [[FBSDKShareLinkContent alloc] init];
    linkContent.contentURL = [NSURL URLWithString:@"http://tw.yaoo.com"];
    [FBSDKShareDialog showFromViewController:self withContent:linkContent delegate:self];
}
- (IBAction)messenger:(id)sender {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb-messenger-api://"]] ) {
        UIImage *image = [UIImage imageNamed:@"cat"];
        [FBSDKMessengerSharer shareImage:image withOptions:nil];
    }
}
//邀請功能
- (IBAction)inviteFriend:(id)sender {
    //app invite必須提供一個網頁讓Facebook認證
    NSURL *url = [NSURL URLWithString:@"http://iosnetworkdemo.appspot.com/applink.html"];
    FBSDKAppInviteContent *content =[[FBSDKAppInviteContent alloc] init];
    content.appLinkURL = url;
    
    FBSDKAppInviteDialog *dialog = [[FBSDKAppInviteDialog alloc] init];
    //dialog.delegate = self;
    dialog.content = content;
    if ([dialog canShow]){
        [dialog show];
    }
    
}
#pragma mark FBSDKSharingDelegate
-(void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results{
    NSLog(@"success");
}
-(void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error{
    NSLog(@"error %@",error);
}
-(void)sharerDidCancel:(id<FBSDKSharing>)sharer{
    NSLog(@"share cancel");
}

#pragma mark FBSDKLoginButtonDelegate
- (void)loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
              error:(NSError *)error {
    if ( error ){
        NSLog(@"error %@",error);
    }else if ( result.isCancelled ){
        NSLog(@"取消");
    }else{
        NSLog(@"成功");
    }
}
-(void)updateProfile{
    self.pictureView.profileID = [FBSDKProfile currentProfile].userID;
    self.nameLabel.text = [FBSDKProfile currentProfile].name;
}
- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    self.pictureView.profileID = nil;//清空畫面
    self.nameLabel.text = nil;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
