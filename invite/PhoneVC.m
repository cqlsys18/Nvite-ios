//
//  PhoneVC.m
//  invite
//
//  Created by Ajay kumar on 9/20/17.
//  Copyright © 2017 cqlsys. All rights reserved.
//

#import "PhoneVC.h"
#import "OtpVC.h"
@interface PhoneVC ()
{
    
    IBOutlet UITextField *phoneTF;
    IBOutlet UITextField *countryCodeTF;
    NSArray  * countryNameArr;
    NSArray * countryAreaCodeArr;
    UIPickerView * countryCodePV;
    NSString *countryCodeStr;
}
@end

@implementation PhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    countryNameArr = @[@"Afghanistan",@"Albania",@"Algeria",@"Andorra",@"Angola",@"Antarctica",@"Argentina",@"Armenia",@"Aruba",@"Australia",@"Austria",@"Azerbaijan",@"Bahrain",@"Bangladesh",@"Belarus",@"Belgium",@"Belize",@"Benin",@"Bhutan",@"Bolivia",@"Bosnia And Herzegovina",@"Botswana",
                       @"Brazil",@"Brunei Darussalam",@"Bulgaria",@"Burkina Faso",
                       @"Myanmar",@"Burundi",@"Cambodia",@"Cameroon",@"Canada",@"Cape Verde",
                       @"Central African Republic",@"Chad",@"Chile",@"China",@"Christmas Island",@"Cocos (keeling) Islands",@"Colombia",@"Comoros",@"Congo",@"Cook Islands",@"Costa Rica",@"Croatia",@"Cuba",@"Cyprus",@"Czech Republic",@"Denmark",@"Djibouti",@"Timor-leste",@"Ecuador",@"Egypt",@"El Salvador",@"Equatorial Guinea",@"Eritrea",@"Estonia",@"Ethiopia",
                       @"Falkland Islands (malvinas)",@"Faroe Islands",@"Fiji",@"Finland",
                       @"France",@"French Polynesia",@"Gabon",@"Gambia",@"Georgia",
                       @"Germany",@"Ghana",@"Gibraltar",@"Greece",@"Greenland",@"Guatemala",
                       @"Guinea",@"Guinea-bissau",@"Guyana",@"Haiti",@"Honduras",@"Hong Kong",@"Hungary",@"India",@"Indonesia",@"Iran",@"Iraq",@"Ireland",@"Isle Of Man",@"Israel",@"Italy",@"Ivory Coast",@"Jamaica",@"Japan",@"Jordan",@"Kazakhstan",@"Kenya",@"Kiribati",@"Kuwait",@"Kyrgyzstan",@"Laos",@"Latvia",@"Lebanon",@"Lesotho",
                       @"Liberia",@"Libya",@"Liechtenstein",@"Lithuania",@"Luxembourg",
                       @"Macao",@"Macedonia",@"Madagascar",@"Malawi",@"Malaysia",
                       @"Maldives",@"Mali",@"Malta",@"Marshall Islands",@"Mauritania",
                       @"Mauritius",@"Mayotte",@"Mexico",@"Micronesia",@"Moldova",
                       @"Monaco",@"Mongolia",@"Montenegro",@"Morocco",@"Mozambique",
                       @"Namibia",@"Nauru",@"Nepal",@"Netherlands",@"New Caledonia",
                       @"New Zealand",@"Nicaragua",@"Niger",@"Nigeria",@"Niue",@"Korea",
                       @"Norway",@"Oman",@"Pakistan",@"Palau",@"Panama", @"Papua New Guinea",@"Paraguay",@"Peru",@"Philippines",@"Pitcairn",
                       @"Poland",@"Portugal",@"Puerto Rico",@"Qatar",@"Romania",@"Russian Federation",@"Rwanda",@"Saint Barthélemy",@"Samoa",
                       @"San Marino",@"Sao Tome And Principe",@"Saudi Arabia",@"Senegal",
                       @"Serbia",@"Seychelles",@"Sierra Leone",@"Singapore",@"Slovakia",
                       @"Slovenia",@"Solomon Islands",@"Somalia",@"South Africa",
                       @"Korea, Republic Of",@"Spain",@"Sri Lanka",@"Saint Helena",
                       @"Saint Pierre And Miquelon",@"Sudan",@"Suriname",@"Swaziland",
                       @"Sweden",@"Switzerland",@"Syrian Arab Republic",@"Taiwan",
                       @"Tajikistan",@"Tanzania",@"Thailand",@"Togo",@"Tokelau",@"Tonga",
                       @"Tunisia",@"Turkey",@"Turkmenistan",@"Tuvalu",
                       @"United Arab Emirates",@"Uganda",@"United Kingdom",@"Ukraine",
                       @"Uruguay",@"United States",@"Uzbekistan",@"Vanuatu",
                       @"Holy See (vatican City State)",@"Venezuela",@"Viet Nam",
                       @"Wallis And Futuna",@"Yemen",@"Zambia",@"Zimbabwe"];
    
    countryAreaCodeArr = @[@"93",@"355",@"213",
                           @"376",@"244",@"672",@"54",@"374",@"297",@"61",@"43",@"994",@"973",
                           @"880",@"375",@"32",@"501",@"229",@"975",@"591",@"387",@"267",@"55",
                           @"673",@"359",@"226",@"95",@"257",@"855",@"237",@"1",@"238",@"236",
                           @"235",@"56",@"86",@"61",@"61",@"57",@"269",@"242",@"682",@"506",
                           @"385",@"53",@"357",@"420",@"45",@"253",@"670",@"593",@"20",@"503",
                           @"240",@"291",@"372",@"251",@"500",@"298",@"679",@"358",@"33",
                           @"689",@"241",@"220",@"995",@"49",@"233",@"350",@"30",@"299",@"502",
                           @"224",@"245",@"592",@"509",@"504",@"852",@"36",@"91",@"62",@"98",
                           @"964",@"353",@"44",@"972",@"39",@"225",@"1876",@"81",@"962",@"7",
                           @"254",@"686",@"965",@"996",@"856",@"371",@"961",@"266",@"231",
                           @"218",@"423",@"370",@"352",@"853",@"389",@"261",@"265",@"60",
                           @"960",@"223",@"356",@"692",@"222",@"230",@"262",@"52",@"691",
                           @"373",@"377",@"976",@"382",@"212",@"258",@"264",@"674",@"977",
                           @"31",@"687",@"64",@"505",@"227",@"234",@"683",@"850",@"47",@"968",
                           @"92",@"680",@"507",@"675",@"595",@"51",@"63",@"870",@"48",@"351",
                           @"1",@"974",@"40",@"7",@"250",@"590",@"685",@"378",@"239",@"966",
                           @"221",@"381",@"248",@"232",@"65",@"421",@"386",@"677",@"252",@"27",
                           @"82",@"34",@"94",@"290",@"508",@"249",@"597",@"268",@"46",@"41",
                           @"963",@"886",@"992",@"255",@"66",@"228",@"690",@"676",@"216",@"90",
                           @"993",@"688",@"971",@"256",@"44",@"380",@"598",@"1",@"998",@"678",
                           @"39",@"58",@"84",@"681",@"967",@"260",@"263" ];
    
    countryCodePV = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-0, self.view.frame.size.width, 200)];
    
    countryCodePV.delegate = self;
    countryCodeTF.inputView  = countryCodePV;
    countryCodePV.backgroundColor = UIColorFromRGBAlpha(255, 255, 255, 0.8);
    
    [countryCodePV selectRow:30 inComponent:0 animated:YES];
    
    countryCodeStr = @"1";
}

#pragma mark - Picker View Delegate

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [countryNameArr count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
   
    return 1;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSString *countryStr = [[countryNameArr objectAtIndex:row] stringByAppendingString:[NSString stringWithFormat:@" (+%@)",[countryAreaCodeArr objectAtIndex:row]]];
    countryCodeTF.text = countryStr;
    countryCodeStr = [countryAreaCodeArr objectAtIndex:row];
    
    countryCodeTF.text    = [NSString stringWithFormat:@"+%@",countryCodeStr];
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
}


-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel* pickerLbl = (UILabel*)view;
    
    if (!pickerLbl)
    {
        pickerLbl = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, self.view.frame.size.width-60, 50)];
        [pickerLbl setFont:[UIFont fontWithName:@"Helvetica" size:13]];
        NSString *countryStr = [[countryNameArr objectAtIndex:row] stringByAppendingString:[NSString stringWithFormat:@" (+%@)",[countryAreaCodeArr objectAtIndex:row]]];
        
        pickerLbl.text = countryStr;
        pickerLbl.numberOfLines = 2;
        pickerLbl.textAlignment = NSTextAlignmentCenter;
    }
    return pickerLbl;
}

#pragma mark - UIButtons

- (IBAction)backBtnAction:(id)sender {
    
    UIViewController *phoneVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PhoneVC"];
    [self dismissViewControllerAnimated:phoneVC completion:nil];
}

- (IBAction)signupBtnAction:(id)sender {
    
    if ([countryCodeTF.text isEqualToString:@""]) {
        SHOW_NETWORK_ERROR(@"Select Country Code!", self);
        return;
    }else if ([phoneTF.text isEqualToString:@""]){
        SHOW_NETWORK_ERROR(@"Enter Phone Number!", self);
        return;
    }else{
        
        if ([self.title isEqualToString:@"SocialLogin"]) {
            [self phoneApicalling];
        }
        else{
            [self signupApicalling];
        }
        
    }
}
-(void)signupApicalling {
    
    [_signupParamDict setObject:countryCodeStr   forKey:@"phone_code"];
    [_signupParamDict setObject:phoneTF.text   forKey:@"phone_no"];
    
    [[ApiManager sharedInstance] CheckReachibilty:^(BOOL responseObject)
     {
         
         if (responseObject == false)
         {
             SHOW_NETWORK_ERROR(INTERNET_ERROR, self);
         }
         else
         {
             SHOW_PROGRESS(@"");
             
             
             NSString *signupurl=[NSString stringWithFormat:@"%@%@",appURL,@"signup"];
             [[ApiManager sharedInstance] apiCallWithImage:signupurl parameterDict:_signupParamDict imageDataDictionary:_imgDict  CompletionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary)  {
                 
                 HIDE_PROGRESS;
                 if (success == false)
                 {
                     SHOW_NETWORK_ERROR([dictionary objectForKey:@"message"], self);
                 }
                 else
                 {
                     if ([Util checkIfSuccessResponse:dictionary])
                     {
                        SET_USER_ID([[dictionary objectForKey:@"body"]objectForKey:@"id"]);
                         SET_AUTH_TOKEN([[dictionary objectForKey:@"body"] objectForKey:@"auth_token"])
                         
                         [[NSUserDefaults standardUserDefaults] setObject:[dictionary objectForKey:@"body"] forKey:@"userInfo"];
                         
                         OtpVC *otpVc = [self.storyboard instantiateViewControllerWithIdentifier:@"OtpVC"];
                         otpVc.phoneNo      = [[dictionary objectForKey:@"body"]objectForKey:@"phone_no"];
                         otpVc.Countrycode  = [[dictionary objectForKey:@"body"] objectForKey:@"phone_code"];
                         [self presentViewController:otpVc animated:YES completion:nil];
                         
                     }
                     else
                     {
                         if ([[NSString stringWithFormat:@"%@",[dictionary objectForKey:@"code"]]isEqualToString:@"403"]) {
                             
                             
                         }
                     }
                 }
             }];
         }
         
     }];
    
    
}

-(void)phoneApicalling{
    
    [[ApiManager sharedInstance] CheckReachibilty:^(BOOL responseObject)
     {
         
         if (responseObject == false)
         {
             SHOW_NETWORK_ERROR(INTERNET_ERROR, self);
         }
         else
         {
             SHOW_PROGRESS(@"");
             
             NSDictionary *dict = @{@"auth_token" : AUTH_TOKEN,
                                    @"phone_no"   : phoneTF.text,
                                    @"phone_code" : countryCodeStr};
             
             NSString *url  =   [NSString stringWithFormat:@"%@%@",appURL,@"phone_verfiy"];
             
             [[ApiManager sharedInstance] POST:url parameterDict:dict Headers:nil CompletionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary){
                 
                 HIDE_PROGRESS;
                 if (success == false)
                 {
                     SHOW_NETWORK_ERROR(message, self);
                 }
                 else
                 {
                     if ([Util checkIfSuccessResponse:dictionary])
                     {
                         [[NSUserDefaults standardUserDefaults] setObject:[[dictionary objectForKey:@"body"] objectForKey:@"User"] forKey:@"userInfo"];
                         
                         SET_USER_ID([[[dictionary objectForKey:@"body"] objectForKey:@"User"] objectForKey:@"id"])
                         SET_AUTH_TOKEN([[[dictionary objectForKey:@"body"] objectForKey:@"User"] objectForKey:@"auth_token"])
                         
                         OtpVC *otpVc = [self.storyboard instantiateViewControllerWithIdentifier:@"OtpVC"];
                         otpVc.phoneNo      = [[[dictionary objectForKey:@"body"] objectForKey:@"User"] objectForKey:@"phone_no"];
                         otpVc.Countrycode  = [[[dictionary objectForKey:@"body"] objectForKey:@"User"] objectForKey:@"phone_code"];
                         [self presentViewController:otpVc animated:YES completion:nil];
                         
                     }
                     else
                     {
                         if ([[NSString stringWithFormat:@"%@",[dictionary objectForKey:@"code"]]isEqualToString:@"403"]) {
                             
                             
                         }
                     }
                 }
             }];
         }
         
     }];
    
    
}
#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
