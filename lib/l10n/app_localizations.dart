import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Registration App'**
  String get appTitle;

  /// No description provided for @enterOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enterOtp;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @bangla.
  ///
  /// In en, this message translates to:
  /// **'Bangla'**
  String get bangla;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @languageToggleButton.
  ///
  /// In en, this message translates to:
  /// **'বাংলা'**
  String get languageToggleButton;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Unemployed Worker Self-Registration App'**
  String get appName;

  /// No description provided for @appProgramme.
  ///
  /// In en, this message translates to:
  /// **'Unemployed Worker Self-Registration App'**
  String get appProgramme;

  /// No description provided for @implementedBy.
  ///
  /// In en, this message translates to:
  /// **'Implemented By:\nCentral Fund\nMinistry of Labour and Employment'**
  String get implementedBy;

  /// No description provided for @registration.
  ///
  /// In en, this message translates to:
  /// **'Please Login'**
  String get registration;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @mobNum.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number of Unemployed Worker'**
  String get mobNum;

  /// No description provided for @nidNum.
  ///
  /// In en, this message translates to:
  /// **'NID Number'**
  String get nidNum;

  /// No description provided for @pickDate.
  ///
  /// In en, this message translates to:
  /// **'Pick Date'**
  String get pickDate;

  /// No description provided for @selectDob.
  ///
  /// In en, this message translates to:
  /// **'Please Select Date of Birth'**
  String get selectDob;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @errnid.
  ///
  /// In en, this message translates to:
  /// **'Enter NID number'**
  String get errnid;

  /// No description provided for @errnid2.
  ///
  /// In en, this message translates to:
  /// **'NID must be 10 or 17 digits'**
  String get errnid2;

  String get emptyDoB;

  String get emptyNameEn;

  /// No description provided for @errmob.
  ///
  /// In en, this message translates to:
  /// **'Enter mobile number'**
  String get errmob;

  /// No description provided for @errmob2.
  ///
  /// In en, this message translates to:
  /// **'Mobile must be 11 digits starting with 01'**
  String get errmob2;

  /// No description provided for @selectOption.
  ///
  /// In en, this message translates to:
  /// **'Select Option'**
  String get selectOption;

  /// No description provided for @selfRegistration.
  ///
  /// In en, this message translates to:
  /// **'Self-Registration'**
  String get selfRegistration;

  /// No description provided for @grievanceSubmission.
  ///
  /// In en, this message translates to:
  /// **'Grievance Submission'**
  String get grievanceSubmission;

  /// No description provided for @errotp.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get errotp;

  /// No description provided for @errotp2.
  ///
  /// In en, this message translates to:
  /// **'OTP must be 6 digits'**
  String get errotp2;

  /// No description provided for @otpVerifying.
  ///
  /// In en, this message translates to:
  /// **'Verifying OTP...'**
  String get otpVerifying;

  /// No description provided for @enterOTP.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit OTP sent to your mobile.'**
  String get enterOTP;

  /// No description provided for @timeRem.
  ///
  /// In en, this message translates to:
  /// **'Time remaining: '**
  String get timeRem;

  /// No description provided for @invalidOtp.
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP.'**
  String get invalidOtp;

  /// No description provided for @credNotMatch.
  ///
  /// In en, this message translates to:
  /// **'The credentials did not match. Please re-enter.'**
  String get credNotMatch;

  /// No description provided for @backReg.
  ///
  /// In en, this message translates to:
  /// **'Back to Registration'**
  String get backReg;

  /// No description provided for @cantConnect.
  ///
  /// In en, this message translates to:
  /// **'Could not connect to server.'**
  String get cantConnect;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @enterComplaint.
  ///
  /// In en, this message translates to:
  /// **'Please enter your complaint'**
  String get enterComplaint;

  /// No description provided for @yourComplaint.
  ///
  /// In en, this message translates to:
  /// **'Your Complaint'**
  String get yourComplaint;

  /// No description provided for @enterGrievType.
  ///
  /// In en, this message translates to:
  /// **'Please select a grievance type'**
  String get enterGrievType;

  /// No description provided for @grievType.
  ///
  /// In en, this message translates to:
  /// **'Grievance Type'**
  String get grievType;

  /// No description provided for @submitGriev.
  ///
  /// In en, this message translates to:
  /// **'Submit Grievance'**
  String get submitGriev;

  /// No description provided for @uploadSuccess.
  ///
  /// In en, this message translates to:
  /// **'Upload successful'**
  String get uploadSuccess;

  /// No description provided for @uploadFail.
  ///
  /// In en, this message translates to:
  /// **'Upload Failed'**
  String get uploadFail;

  /// No description provided for @uploadImage.
  ///
  /// In en, this message translates to:
  /// **'Upload Image'**
  String get uploadImage;

  /// No description provided for @uploadCertificate.
  ///
  /// In en, this message translates to:
  /// **'Upload Certificates'**
  String get uploadCertificate;

  /// No description provided for @certEmp.
  ///
  /// In en, this message translates to:
  /// **'Certificate of Employment'**
  String get certEmp;

  /// No description provided for @certUnemp.
  ///
  /// In en, this message translates to:
  /// **'Certificate of Unemployment'**
  String get certUnemp;

  String get nidCard;

  String get facePhoto;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @fillFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields.'**
  String get fillFields;

  /// No description provided for @corrErrForm.
  ///
  /// In en, this message translates to:
  /// **'Please correct the errors in the form.'**
  String get corrErrForm;

  /// No description provided for @detailsForm.
  ///
  /// In en, this message translates to:
  /// **'Details Form'**
  String get detailsForm;

  /// No description provided for @nameEn.
  ///
  /// In en, this message translates to:
  /// **'Name (English)'**
  String get nameEn;

  /// No description provided for @fatherNameEn.
  ///
  /// In en, this message translates to:
  /// **'Father\'s Name (English)'**
  String get fatherNameEn;

  /// No description provided for @motherNameEn.
  ///
  /// In en, this message translates to:
  /// **'Mother\'s Name (English)'**
  String get motherNameEn;

  /// No description provided for @nameBn.
  ///
  /// In en, this message translates to:
  /// **'Name (Bangla)'**
  String get nameBn;

  /// No description provided for @fatherNameBn.
  ///
  /// In en, this message translates to:
  /// **'Father\'s Name (Bangla)'**
  String get fatherNameBn;

  /// No description provided for @motherNameBn.
  ///
  /// In en, this message translates to:
  /// **'Mother\'s Name (Bangla)'**
  String get motherNameBn;

  /// No description provided for @religion.
  ///
  /// In en, this message translates to:
  /// **'Religion'**
  String get religion;

  String get validInput;

  /// No description provided for @presentAddress.
  ///
  /// In en, this message translates to:
  /// **'Present Address'**
  String get presentAddress;

  /// No description provided for @division.
  ///
  /// In en, this message translates to:
  /// **'Division'**
  String get division;

  /// No description provided for @district.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get district;

  /// No description provided for @upazila.
  ///
  /// In en, this message translates to:
  /// **'Upazila'**
  String get upazila;

  /// No description provided for @permanentAddress.
  ///
  /// In en, this message translates to:
  /// **'Permanent Address'**
  String get permanentAddress;

  /// No description provided for @association.
  ///
  /// In en, this message translates to:
  /// **'Association'**
  String get association;

  /// No description provided for @factory.
  ///
  /// In en, this message translates to:
  /// **'Factory'**
  String get factory;

  /// No description provided for @designation.
  ///
  /// In en, this message translates to:
  /// **'Designation'**
  String get designation;

  /// No description provided for @linNum.
  ///
  /// In en, this message translates to:
  /// **'LIN Number'**
  String get linNum;

  /// No description provided for @linErr.
  ///
  /// In en, this message translates to:
  /// **'LIN Number must be exactly 12 digits'**
  String get linErr;

  /// No description provided for @dateEmp.
  ///
  /// In en, this message translates to:
  /// **'Date of Employment'**
  String get dateEmp;

  /// No description provided for @dateUnemp.
  ///
  /// In en, this message translates to:
  /// **'Date of Unemployment'**
  String get dateUnemp;

  /// No description provided for @unempReason.
  ///
  /// In en, this message translates to:
  /// **'Reason of Unemployment'**
  String get unempReason;

  /// No description provided for @failBankSubmit.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit banking details.'**
  String get failBankSubmit;

  /// No description provided for @bankingInfo.
  ///
  /// In en, this message translates to:
  /// **'Banking Info'**
  String get bankingInfo;

  /// No description provided for @paymentMode.
  ///
  /// In en, this message translates to:
  /// **'Payment Mode'**
  String get paymentMode;

  /// No description provided for @bank.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get bank;

  /// No description provided for @branch.
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get branch;

  /// No description provided for @mfsProv.
  ///
  /// In en, this message translates to:
  /// **'MFS Provider'**
  String get mfsProv;

  /// No description provided for @accName.
  ///
  /// In en, this message translates to:
  /// **'Account Holder Name'**
  String get accName;

  /// No description provided for @accNum.
  ///
  /// In en, this message translates to:
  /// **'Account Number'**
  String get accNum;

  /// No description provided for @accNumErr.
  ///
  /// In en, this message translates to:
  /// **'Account Number must be 11 or 12 digits'**
  String get accNumErr;

  String get bankAccNumErr;

  /// No description provided for @mfsVerifiedFail.
  ///
  /// In en, this message translates to:
  /// **'Failed to verify MFS'**
  String get mfsVerifiedFail;

  String get accountNonExistent;

  String get accountNidNotMatchedWithGivenNid;

  String get simNidNotMatchedWithGivenNid;

  /// No description provided for @mfsVerifiedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully verified MFS'**
  String get mfsVerifiedSuccess;

  /// No description provided for @pleaseVerifyMfs.
  ///
  /// In en, this message translates to:
  /// **'Please verfiy your MFS'**
  String get pleaseVerifyMfs;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
