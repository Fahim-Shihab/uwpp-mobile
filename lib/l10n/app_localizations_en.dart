// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Registration App';

  @override
  String get enterOtp => 'Enter OTP';

  @override
  String get verify => 'Verify';

  @override
  String get bangla => 'Bangla';

  @override
  String get english => 'English';

  @override
  String get languageToggleButton => 'বাংলা';

  @override
  String get next => 'Next';

  @override
  String get appName => 'Unemployed Worker Self-Registration App';

  @override
  String get appProgramme => 'Unemployed Worker Protection Program';

  @override
  String get implementedBy =>
      'Implemented By:\nCentral Fund\nMinistry of Labour and Employment';

  @override
  String get registration => 'Please Login';

  @override
  String get login => 'Login';

  @override
  String get mobNum => 'Mobile Number of Unemployed Worker';

  @override
  String get nidNum => 'NID Number';

  @override
  String get pickDate => 'Pick Date';

  @override
  String get selectDob => 'Date of Birth';

  @override
  String get submit => 'Submit';

  @override
  String get errnid => 'Enter NID number';

  @override
  String get errnid2 => 'NID must be 10 or 17 digits';

  @override
  String get emptyDoB => 'Please provide Date of Birth';

  @override
  String get emptyNameEn => 'Please provide English Name';

  @override
  String get errmob => 'Enter mobile number';

  @override
  String get errmob2 => 'Mobile must be 11 digits starting with 01';

  @override
  String get selectOption => 'Select Option';

  @override
  String get selfRegistration => 'Self-Registration';

  @override
  String get grievanceSubmission => 'Grievance Submission';

  @override
  String get errotp => 'Enter OTP';

  @override
  String get errotp2 => 'OTP must be 6 digits';

  @override
  String get otpVerifying => 'Verifying OTP...';

  @override
  String get enterOTP => 'Enter the 6-digit OTP sent to your mobile.';

  @override
  String get timeRem => 'Time remaining: ';

  @override
  String get invalidOtp => 'Invalid OTP.';

  @override
  String get credNotMatch => 'The credentials did not match. Please re-enter.';

  @override
  String get backReg => 'Back to Registration';

  @override
  String get cantConnect => 'Could not connect to server.';

  @override
  String get retry => 'Retry';

  @override
  String get enterComplaint => 'Please enter your complaint';

  @override
  String get yourComplaint => 'Your Complaint';

  @override
  String get enterGrievType => 'Please select a grievance type';

  @override
  String get grievType => 'Grievance Type';

  @override
  String get submitGriev => 'Submit Grievance';

  @override
  String get uploadSuccess => 'Upload successful';

  @override
  String get uploadFail => 'Upload Failed';

  @override
  String get uploadImage => 'Upload Image';

  @override
  String get uploadCertificate => 'Document Upload (Max 2MB)';

  @override
  String get certEmp =>
      'Proof of Employment (ID Card, Appointment Letter, Service Book, Salary Slip)';

  @override
  String get certUnemp =>
      'Proof of Unemployment (Termination Letter, Factory Closure Notice, Layoff Notice)';

  @override
  String get nidCard => 'National ID (Clear copy of your NID)';

  @override
  String get facePhoto => 'Worker Own Photo';

  @override
  String get gender => 'Gender';

  @override
  String get fillFields => 'Please fill all fields.';

  @override
  String get corrErrForm => 'Please correct the errors in the form.';

  @override
  String get detailsForm => 'Details Form';

  @override
  String get nameEn => 'Name (English)';

  @override
  String get fatherNameEn => 'Father\'s Name (English)';

  @override
  String get motherNameEn => 'Mother\'s Name (English)';

  @override
  String get nameBn => 'Name (Bangla)';

  @override
  String get fatherNameBn => 'Father\'s Name (Bangla)';

  @override
  String get motherNameBn => 'Mother\'s Name (Bangla)';

  @override
  String get religion => 'Religion';

  @override
  String get validInput => 'Required';

  @override
  String get presentAddress => 'Present Address';

  @override
  String get division => 'Division';

  @override
  String get district => 'District';

  @override
  String get upazila => 'Upazila';

  @override
  String get permanentAddress => 'Permanent Address';

  @override
  String get association => 'Association';

  @override
  String get factory => 'Factory';

  @override
  String get designation => 'Designation';

  @override
  String get linNum => 'LIN Number';

  @override
  String get linErr => 'LIN Number must be exactly 12 digits';

  @override
  String get dateEmp => 'Date of Employment';

  @override
  String get dateUnemp => 'Date of Unemployment';

  @override
  String get unempReason => 'Reason of Unemployment';

  @override
  String get failBankSubmit => 'Failed to submit banking details.';

  @override
  String get bankingInfo => 'Banking Info';

  @override
  String get paymentMode => 'Payment Mode';

  @override
  String get bank => 'Bank';

  @override
  String get branch => 'Branch';

  @override
  String get mfsProv => 'Mobile Bank';

  @override
  String get accName => 'Account Holder Name';

  @override
  String get accNum => 'Account Number';

  @override
  String get accNumErr =>
      'Account Number must be 11 or 12 digits and must start with 01';

  @override
  String get bankAccNumErr => 'Bank Account Number must be 13 to 17 digits';

  @override
  String get mfsVerifiedFail => 'Failed to verify MFS Account';

  @override
  String get accountNonExistent => 'This MFS Account does not exist';

  @override
  String get accountNidNotMatchedWithGivenNid =>
      'The given NID does not own this MFS Account';

  @override
  String get simNidNotMatchedWithGivenNid =>
      'The given NID does not own this SIM';

  @override
  String get mfsVerifiedSuccess => 'Successfully verified MFS';

  @override
  String get pleaseVerifyMfs => 'Please verify your MFS';
}
