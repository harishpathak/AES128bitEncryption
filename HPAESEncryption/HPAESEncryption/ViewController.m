//
//  ViewController.m
//  HPAESEncryption
//
//  Created by Harish Pathak on 7/28/17.
//  Copyright © 2017 ASPL. All rights reserved.
//

#import "ViewController.h"
#import "NSData+AES.h"

//AES Encryption in APIs
#define ENCRYPTION_AES_KEY @"7E892875A52C59A3B588306B13C31FBD"
#define ENCRYPTION_AES_IV @"1011121314151617"

@interface ViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *txtPlainText;
@property (weak, nonatomic) IBOutlet UITextView *txtEncryptedText;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _txtPlainText.delegate = self;
    _txtEncryptedText.delegate = self;
}

- (IBAction)actionEncrypt:(id)sender {

    _txtEncryptedText.text = [self getBase64EncodedWithAES128Encryption:_txtPlainText.text];
    
}

- (IBAction)actionDecrypt:(id)sender {
    
    _txtPlainText.text = [self getBase64DecodedWithAES128Encryption:_txtEncryptedText.text];
}

-(NSString *)getBase64EncodedWithAES128Encryption:(NSString *)plainText{
    
    NSData *plainTextData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    
    plainTextData = [plainTextData AES128EncryptedDataWithKey:ENCRYPTION_AES_KEY iv:ENCRYPTION_AES_IV];
    
    NSString *encryptedText = [[plainTextData base64EncodedStringWithOptions:0] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
    
    NSLog(@"encrypted text: %@", encryptedText);
    
    return encryptedText;
    
}


-(NSString *)getBase64DecodedWithAES128Encryption:(NSString *)encryptedText{
    
    NSString *base64Str = [encryptedText stringByRemovingPercentEncoding];
    
    NSData *encryptedTextData = [[NSData alloc] initWithBase64EncodedString:base64Str options:0];
    
    NSString *plainText = [[NSString alloc]initWithData:[encryptedTextData AES128DecryptedDataWithKey:ENCRYPTION_AES_KEY iv:ENCRYPTION_AES_IV] encoding:kCFStringEncodingUTF8];
    
    NSLog(@"decrypted text: %@", plainText);
    
    return plainText;
    
}

#pragma mark - Text View Delegates

-(void)textViewDidEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_txtEncryptedText endEditing:YES];
    [_txtPlainText endEditing:YES];
}

@end
