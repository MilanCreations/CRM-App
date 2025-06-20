// ignore_for_file: constant_identifier_names

class ApiConstants {
//  static const String baseUrls = "http://192.168.1.27:3000"; // Replace with your base URL
 static const String baseUrls = "https://crm.venusstudies.com/api"; // Replace with your base URL




  // Login end-point
  static const String login = "$baseUrls/auth/login";

  // Clock-In
  static const String checkIn = "$baseUrls/payroll/attendance/check-in";

  // Clock-Out
  static const String checkOut = "$baseUrls/payroll/attendance/check-out";

  // Breal-In
  static const String breakstart = "$baseUrls/payroll/attendance/break-start";

  // Breal-Out
  static const String breakOut = "$baseUrls/payroll/attendance/break-end";

//   // Check check-in
  static const String checkInStatus = "$baseUrls/payroll/attendance/check";
  
// Leave type
static const String leaveType = "$baseUrls/payroll/attendance/leaves/type";

// Apply Leave
static const String applyLeave = "$baseUrls/payroll/attendance/leaves";

// Attendance history
static const String attendanceHistory = "$baseUrls/payroll/attendance";

// Profile
static const String profile = "$baseUrls/auth/user/profile";

// Leave history
static const String leaveHistory = "$baseUrls/payroll/attendance/leaves";

// Get All Employee Leave Data
static const String allleaveHistory = "$baseUrls/payroll/attendance/leaves";

// Get all employee list
static const String getAllEmployeeList = "$baseUrls/payroll/employee/list";

////////////////////////////////// HR Module end points //////////////////////////////////
static const String employeeList = "$baseUrls/payroll/employee";
// Employee Department
static const String employeeDepartment = "$baseUrls/payroll/department";

// Employee Designation
static const String employeeDesignation = "$baseUrls/payroll/designation";

// Employee Invite
static const String inviteEmployee = "$baseUrls/payroll/company/invite-employee";

// Change Employee Status
static const String changeEmpStatus = "$baseUrls/payroll/employee/change/status";

// Employee Details
static const String employeeDetails = "$baseUrls/payroll/employee";
static const String editEmployeeDetails = "$baseUrls/payroll/employee";

// approve and reject leave
static const String leaveAction = "$baseUrls/payroll/attendance/leaves";

// Get All Companirs
static const String getAllComapies = "$baseUrls/payroll/company/index";

////////////////////////// Lead Managament ////////////////////////////
// Create leads
static const String creatLead = "$baseUrls/payroll/leads";

// Get Lead List
static const String leadList = "$baseUrls/payroll/leads/all/assignedLeads";

//////////////////// Salary Management //////////////////
static const String salaryList = "$baseUrls/payroll/employee/generate-salary-report";


}
