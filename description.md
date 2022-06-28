## Motivation behind this project:
--------------------------------
This is basically an appointment scheduling application.But our app offers some extra features which make it unique from 
other appointment management applications.
Our goal is to help teachers to utilize their free time more efficiently.
Sometimes teachers may be free during their busy schedule due to some unexpected reasons and intend to take 
appointments of students to utilize his time.
So besides taking regular appointments this app offers a feature where teachers can schedule instant apointments according to both his 
free time duration and student's loaction who can get to him in his free time to attend the meeting.  

## Features:
-----------
### 1. Setting up an account
   * Account Creation :  
      Our app has three modules: student,teacher and moderator. To sign up both as a student and teacher user has to pass three phase.
      Firstly user has to provide his name , email and password .And then he has to verify him with an otp which has
      been sent to his given email. After the verification user is signed up finally and has to fillup some necessary informations 
      to set his profile.
      
      ![login](https://github.com/cse-250-2018/G05-Appointment-Scheduler/blob/main/project%20pics/login.png) &nbsp;  ![signup](https://github.com/cse-250-2018/G05-Appointment-Scheduler/blob/main/project%20pics/signup.png) &nbsp; ![student_info](https://github.com/cse-250-2018/G05-Appointment-Scheduler/blob/main/project%20pics/studentInfo.png) &nbsp; ![teacherInfo](https://github.com/cse-250-2018/G05-Appointment-Scheduler/blob/main/project%20pics/teacherinfo.png)
   * Account approval :    
      User can't use his account right after signing up.Initially all the accounts are disabled by default.The user has to be approved by 
      moderator. Moderator plays a vital role here
      to keep this app free from frauds.Moderator enables user's account by checking all information provided by that user. 
      And then user gets the permission to use his account. 
### 2. Features related to student account
   * Adding teachers by scanning QR code :  
      Students can connect with their teachers scanning the QR code given by them.After that they are ready to create appointment
      requests to those teachers who are connected with them.  
        
      ![Scan_Qr_Code1](https://github.com/cse-250-2018/G05-Appointment-Scheduler/blob/main/project%20pics/scanCode1.jpg) &nbsp; ![scan_qr_code2](https://github.com/cse-250-2018/G05-Appointment-Scheduler/blob/main/project%20pics/scanCode2.png)      
   * Creating Pre-scheduled appointments :  
      Students can request appointments to particular teacher by filling up all of these necessary informations.
      
      ![scheduled_appointment1](https://github.com/cse-250-2018/G05-Appointment-Scheduler/blob/main/project%20pics/scheduleapp1.jpg) &nbsp; ![scheduled_appointment2](https://github.com/cse-250-2018/G05-Appointment-Scheduler/blob/main/project%20pics/scheduleapp2.png)   
   * Creating Instant Appointmnets :  
      In people tabbar all the active and inactive connected teachers are shown. By clicking the active teacher and afterward
      by providing these important informations  students can easily create instant appointments.
      
      ![instant1](https://github.com/cse-250-2018/G05-Appointment-Scheduler/blob/main/project%20pics/instant1.png) &nbsp; ![instant2](https://github.com/cse-250-2018/G05-Appointment-Scheduler/blob/main/project%20pics/instant2.png)  
   * Deleting requested appointments :  
      Students can delete their appointment request by long pressing the appointment.
      
      ![delete](https://github.com/cse-250-2018/G05-Appointment-Scheduler/blob/main/project%20pics/deleteStuapp.png)  
### 3. Features related to teacher account
   * Accepting or Rejecting appointments :  
      By tapping on the requested appointment, teacher can view all the details regarding the particular appointment and he can accept 
      or reject by clicking on these buttons. He can also accept and reject appointments by swiping left and right respectively.  
      
      ![accept](https://github.com/cse-250-2018/G05-Appointment-Scheduler/blob/main/project%20pics/acceptStuApp.jpg) &nbsp; ![reject](https://github.com/cse-250-2018/G05-Appointment-Scheduler/blob/main/project%20pics/rejectStu.jpg)  
   * Turning active status on :  
      When teacher intends to take instant appointments he can turn the button on to let all the connected students send appointment
      requests if they want.  
      
      ![status](https://github.com/cse-250-2018/G05-Appointment-Scheduler/blob/main/project%20pics/activeStatus.jpg)
   * Knowing the location of students :  
      To check the location of a student to accept instant appointment, he can go to the map view and select the student to 
      know his current location.If the student is nearby and can catch the meeting in time, then teacher will accept his appointment, otherwise not.  
      
      ![location](https://github.com/cse-250-2018/G05-Appointment-Scheduler/blob/main/project%20pics/map1.jpg) &nbsp; ![location2](https://github.com/cse-250-2018/G05-Appointment-Scheduler/blob/main/project%20pics/mappp.png)
   * Filtering appointments :    
      Teachers can filter appointments according to the courses.  
      
      ![filter](https://github.com/cse-250-2018/G05-Appointment-Scheduler/blob/main/project%20pics/filter.jpg) &nbsp; ![filter2](https://github.com/cse-250-2018/G05-Appointment-Scheduler/blob/main/project%20pics/filter2.png)   
   * Auto generated QR code :  
      After signing up for every teacher a QR code will be auto generated by scanning which students can connect with the teacher.
      
      ![qr1](https://github.com/cse-250-2018/G05-Appointment-Scheduler/blob/main/project%20pics/qr1.jpg) &nbsp; ![qr2](https://github.com/cse-250-2018/G05-Appointment-Scheduler/blob/main/project%20pics/qr2.png) 
   * Call Functionality :
      Tecahers can directly call students using the app.
      
      ![call](https://github.com/cse-250-2018/G05-Appointment-Scheduler/blob/main/project%20pics/call.png)  
### 4. Features related to moderator account
   * Enabling user's account :  
      By clicking on every user,moderator can view all the important informations of that user.After checking and verifying those
      informations moderator enables/disables the accounts.Then those users are ready to use their accounts.
### 5. User Account Modification
   * Edit profile infortmation :  
      Users can edit some of their profile informations if needed.
   * Forget/Change password :  
      Users can  change their password if they forget it or intend to do so.  
      
      ![resetPass](https://github.com/cse-250-2018/G05-Appointment-Scheduler/blob/main/project%20pics/passReset2.png) &nbsp; ![reset2](https://github.com/cse-250-2018/G05-Appointment-Scheduler/blob/main/project%20pics/passReset3.png)  

       
