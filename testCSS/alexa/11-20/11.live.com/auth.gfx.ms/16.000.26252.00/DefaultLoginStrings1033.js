(function(){var a="Core.Strings";(function(){var c=window,b=c.wLive=c.wLive||{},a=b.Login=b.Login||{};a.Using=function(){if(arguments.length<2)return;for(var f=[],e=0,h=arguments.length-1;e<h;e++){for(var d=arguments[e].split("."),b=a,c=0,g=d.length;c<g;c++)b=b[d[c]]=b[d[c]]||{};f.push(b)}arguments[arguments.length-1].apply(null,f)}})();wLive.Login.Using(a,function(a){a.StringRepository=a.StringRepository||new function(){var b=this,a={};b.registerSource=function(b,c){a[b]=a[b]||[];a[b].push(c)};b.getStrings=function(f,e){for(var d={},c=a[f]||[],b=0,g=c.length;b<g;b++)c[b](d,e);return d}}});wLive.Login.Using(a,function(b){var a=b.StringRepository;a.registerSource("str",function(a,b){var c="someone@example.com";a["MOBILE_STR_Header_Brand"]="Microsoft account";a["WF_STR_HeaderDefault_Title"]=b.Bj;a["WF_STR_Default_Desc"]=b.F?"Use your work or school, or personal Microsoft account.":"Use your Microsoft account.";a["WF_STR_LearnMoreLink_Text"]="What\'s this?";a["WF_STR_ProgressText"]="Please wait";a["MOBILE_STR_Footer_Microsoft"]="Microsoft";a["WF_STR_Footer_LinkDisclaimer_Text"]="Link Disclaimer";a["WF_STR_GenericError_Title"]="Something went wrong and we can\'t sign you in right now. Please try again later.";a["CT_PWD_STR_Email_Example"]=b.B&&b.H?"Email, phone, or Skype":b.A?"Email or phone":c;a["CT_STR_CountryCodeError"]="Please verify the country code.";a["CT_PWD_STR_PwdTB_Label"]="Password";a["CT_WPIL_STR_Android_UseDifferentAddress"]="Use a different account";a["CT_PWD_STR_ForgotPwdLink_Text"]="Forgot my password";a["CT_PWD_STR_ForgotPwdLink_SplitterText"]="What kind of account do you have?";a["CT_PWD_STR_KeepMeSignedInCB_Text"]="Keep me signed in";a["CT_PWD_STR_SignIn_Button"]="Sign in";a["CT_PWD_STR_SwitchToOTC_Link"]="Sign in with a single-use code";a["CT_PWD_STR_Error_InvalidUsername"]=b.B&&b.H?"Please enter a valid email address, phone number, or Skype name.":b.A?"Please enter your phone number or your email address in the format someone@example.com.":"Please type your email address in the format someone@example.com.";a["CT_PWD_STR_Error_InvalidPhoneNumber"]="That phone number doesn\'t look right. Please check the country code and phone number.";a["CT_PWD_STR_Error_InvalidPhoneFormatting"]="The phone number you entered isn\'t valid. Your phone number can contain numbers, spaces, and these special characters: ( ) [ ] . - # * /";a["CT_PWD_STR_Error_MissingPassword"]="Please enter the password for your Microsoft account.";a["CT_PWD_STR_Error_PasswordTooLong"]="Microsoft account passwords can contain up to 16 characters. If you\'ve been using a password that has more than 16 characters, enter the first 16.";a["CT_PWD_STR_Error_FedNotAllowed"]="You cannot use this account for this purpose because it belongs to an organization. Please choose a different account or sign up for a new one.";a["CT_FED_STR_ChangeUserLink_Text"]="Sign in with a different Microsoft account";a["CT_FED_STR_GoThereLink_Text"]="Sign in at #~#partnerdomain#~#";a["WF_STR_ForceSI_Info"]="Because you\'re accessing sensitive info, you need to verify your password.";a["WF_STR_SwitchUser_Title"]="You\'re already signed in.";a["WF_STR_SwitchUser_Stay"]="Remain signed in with this account.";a["WF_STR_SwitchUser_Switch"]="Sign out and sign in with a different account.";a["WF_STR_Switch_SignOutDesc"]="(You will be signed out of all Microsoft services you are using currently with your #~#FederatedDomainName_LS#~# account.)";a["WF_STR_Switch_DifferentID"]="Sign in with a different Microsoft account";a["WF_STR_InviteBlocked_Error"]="Sorry, you can\'t use your #~#FederatedDomainName_LS#~# account to sign in here.";a["WF_STR_ServiceBlocked_Error"]="Sorry, we can\'t sign you in here with your #~#FederatedDomainName_LS#~# account.";a["WF_STR_IDPFailed_GenericError"]="Your organization could not sign you in to this service.";a["WF_STR_IDPFailed_Error"]="#~#FederatedPartnerName_LS#~# could not sign you in here.";a["WF_STR_IDPFailed_Desc1"]="Your #~#FederatedDomainName_LS#~# account may not be enabled to use this service or there may be a system error at #~#FederatedPartnerName_LS#~#.";a["WF_STR_IDPFailed_Desc2"]=" Please try again later, and contact the administrator at #~#FederatedPartnerName_LS#~# if this problem persists.";a["WF_STR_IDPFailed_GenericDesc"]="Please try again later, and contact the administrator at your organization if this problem persists.";a["MOBILE_STR_SignIn_MSAcctHelpHeading"]="What is a Microsoft account?";a["MOBILE_STR_SignIn_MSAcctHelpDesc"]="A Microsoft account is what you use to sign in to Microsoft services such as Outlook.com, Skype, OneDrive, Office, Xbox, Windows and more. Sign in for your personalized experience.";a["MOBILE_STR_SignIn_MSAcctHelpDone_Button"]="OK";a["CT_HIP_ID_P_HipLockout_Info"]="Help us make sure you\'re not a robot.";a["CT_HIP_STR_HIP_ISLOADING"]="Loading ...";a["WF_STR_Lockout_AnotherID_Text"]="Sign in using another Microsoft account";a["WF_STR_Lockout_Title"]="Sign-in is blocked";a["WF_STR_Lockout_Desc"]="Sign-in with <b>#~#MemberName_LS#~#</b> is blocked for one of these reasons:";a["WF_STR_Lockout_Reason1"]="Someone entered the wrong password too many times.";a["WF_STR_Lockout_Reason2"]="If you signed up for this account through an organization, you might not be able to use it yet.";a["WF_STR_Lockout_Reset_Text"]="Reset your password";a["WF_STR_HIP_Label"]="Enter these characters";a["WF_STR_HIPAudio_Label"]="Enter the characters you hear";a["CT_OTC_STR_Email_Example"]=c;a["CT_OTC_STR_SwitchToPwd_Text"]="Sign in with a password";a["CT_OTC_STR_CodeTxtBox_Label"]="Single-use code";a["CT_OTC_STR_RequestCode_Text"]="Don\'t have a code?";a["CT_OTC_STR_Error_MissingCode"]="Please enter your single-use code.";a["CT_OTC_STR_Error_InvalidUsername"]="Please enter your email address in the format someone@example.com.";a["OTC_STR_SMS_Confirm"]="If the phone number you entered matches the one you provided for your Microsoft account, you\'ll receive the single use code soon.";a["CT_OTC_STR_InfoMsg"]=b.az&&b.az.replace(/<a .*?<\/a>/gi,"");a["CT_OTC_STR_HintMsg"]=b.aZ&&b.aZ.replace(/<a .*?<\/a>/gi,"");a["CT_OTC_STR_SignIn_ReSendInfo"]="It may take a few minutes for the code to arrive. Are you sure you want to request a new code?";a["CT_OTC_STR_YesButton_Text"]="Yes";a["CT_OTC_STR_NoButton_Text"]="No";a["CT_OTC_STR_EnterCode_Text"]="Already have a code?";a["CT_OTC_STR_SendCode_SMSInvalid"]="That phone number doesn\'t look right. Please try again or use a different number.";a["CT_OTC_STR_JPN_MobileEmail"]="Mobile email address:";a["CT_OTC_STR_SMSTextbox_Label"]="Phone number:";a["CT_OTC_STR_JPN_MobileEmail2"]="Mobile email address";a["CT_OTC_STR_SMSTextbox_Label2"]="Phone number";a["CT_OTC_STR_JPN_MobileHelp"]="Use the primary mobile email address you\'ve associated with your Microsoft account.";a["OTC_STR_SMS_Button"]="Text me the code";a["CT_OTC_STR_SendingCode_Button"]="Sending...";a["CT_OTC_STR_MobileCharges_Text"]="Text messaging charges may apply.";a["CT_OTC_STR_SendCode_Generic"]="Sorry, there was a problem sending the code. Please try again.";a["CT_OTC_STR_SendCode_SMSEmailInvalid"]="That mobile email address doesn\'t look right. Please try again or use a different mobile email address.";a["CT_OTC_STR_Error_InvalidPhone_Special"]="Please enter your phone number without any special characters.";a["CT_PWD_STR_Continue_Button"]="Continue";a["CT_PWD_STR_ContinueBtn_Tooltip"]="You are signed in on this computer with this Microsoft account.";a["CT_PWD_STR_SignedIn_Label"]="You\'re already signed in";a["CT_HRD_STR_Splitter_Heading"]="It looks like this email is used with more than one account from Microsoft. Which one do you want to use?";a["CT_HRD_STR_Splitter_AadTile_Title"]="Work or school account";a["CT_HRD_STR_Splitter_AadTile_Hint"]="Created by your IT department";a["CT_HRD_STR_Splitter_MsaTile_Title"]="Personal account";a["CT_HRD_STR_Splitter_MsaTile_Hint"]="Created by you";a["CT_HRD_STR_Splitter_Back"]="Back";a["WF_STR_FIDO_ReAuthUserPrompt"]="Use your PIN or Windows Hello to prove you own {0}"});a.registerSource("html",function(a,b){var e="CT_IHL_STR_Error_WrongHip",d="The password is incorrect. Please try again.",c="CT_PWD_STR_Error_WrongCreds";a["CT_FED_STR_FedDomainMsg"]="To sign in to this account you need to go to #~#partnerdomain#~#.";a["WF_STR_SignUpLink_Text"]="No account? <a href=\"#\" id=\"signup\">Create one!</a>";a["CT_OTC_STR_SendCode_SessionExpired"]="Your session has timed out. To request a single use code, please <a href=\"#\" id=\"idA_ReloadPage\">refresh the page</a>.";a["UT_STR_LWADisclaimer_Info"]=b.aX;a["CT_HRD_STR_Redirect_Heading"]="Taking you to the sign in page for your organization. <a id=\"aadRedirectCancel\" href=\"#\">Cancel</a>";a["CT_HRD_STR_Splitter_Rename"]="Tired of seeing this? <a href=\"#\" id=\"iDisambigRenameLink\">Rename your personal Microsoft account.</a>";if(b.AL===1){a[c]=b.D?d:b.A?"Your account or password is incorrect. If you don\'t remember your password, <a id=\"idA_IL_ForgotPassword0\" href=\"\">reset it now.</a>":"Your email or password is incorrect. If you don\'t remember your password, <a id=\"idA_IL_ForgotPassword0\" href=\"\">reset it now.</a>";a[e]="Enter your password and the characters correctly. If you don\'t remember your password, <a id=\"idA_IHL_ForgotPassword0\" href=\"\">reset it now.</a>"}else{a[c]=b.D?d:b.A?"Your account or password is incorrect. If you don\'t remember your password, <a id=\"idA_IL_ForgotPassword0\" href=\"\">continue without a Microsoft account.</a>":"Your email or password is incorrect. If you don\'t remember your password, <a id=\"idA_IL_ForgotPassword0\" href=\"\">continue without a Microsoft account.</a>";a[e]="Enter your password and the characters correctly. If you don\'t remember your password, <a id=\"idA_IHL_ForgotPassword0\" href=\"\">continue without a Microsoft account.</a>"}})})})();var __DefaultLogin_Strings=true
