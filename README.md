THRIVE

Introduction:
**
=======================================
Our project is an application that’s main focus is to allow its users to focus on and keep track of
goals that they create within the app. Furthermore, our project is unique in that it adds an
additional aspect of sharing the users’ goals and progress with their friends in the app. Our
project allows users to set goals that repeat daily, weekly, monthly etc., measure out bigger goals
with smaller chunks of units, and even set goals with their friends to motivate each other to
complete those goals. These goals are then shown to the users’ friends as they are posted on the
social wall along with the current progress of those goals. This allows users on the app to interact
with and encourage their friends through showing support and liking their progress. In addition, our
project allows the users to update their goals as they see fit, whether making the goal harder like
increasing the intensity of a workout, or accommodating challenges along the way by reducing the
intensity of a goal. Overall, through our unique social approach to goal setting, our project is a
convenience and a motivator for those who have goals they want to achieve allowing them to keep
track of their progress, gain encouragement from friends, and finally start seeing results.

==============================================================================

Login credentials/Accounts for test cases:
** 
=======================================

TC-LOG-1: Sign Up for Account
TC-LOG-2: Log In to Account
TC-LOG-3: Log Out of Account

(Created during TC-LOG-1)
Email: thrivetest@gmail.com
Password: password

** Account with the email "thriving2@gmail.com" exists
** Account with the email “bademail@gmail.com” does not exist
** Account with email “goodemail@gmail.com” exists and the password is not “password”
** Account with the username "used" exists

=======================================

TC-FRN-1: Searching Friends
TC-FRN-2: Adding Friends
TC-FRN-3: Removing Friends
TC-FRN-4: Accepting Friend Invitation
TC-FRN-5: Declining Friend Invitation

Account #1:
Email: testerunique@gmail.com
Password: password

Account #2:
Email: gary2@gmail.com
Password: password

Account #3:
Email: bob@gmail.com
Password: password

** Needs account with username "Gary" to exist and not be a friend
** Needs no users with the substring "jack" to exist
** Needs account with username "friend2" to exist and be a current friend
** Needs account with username "friendrequest" to have sent a friend request to the user
** Needs account with username "rejection" to have sent a friend request to the user

=======================================

TC-CRG-1: Creating an Invidiaul Goal
TC-CRG-2: Naming Goal
TC-CRG-3: Setting Final Deadline
TC-CRG-4: Adding Subgoals
TC-CRG-5: Recurring Goal
TC-CRG-6: Entering Units to Accomplish Goal
TC-CRG-7: Adding Collaborators to Goal
TC-SOW-1: Commenting on Friend’s Goals
TC-SOW-2: Reacting to Friend’s Goals

Account #1
Email: testgoal@gmail.com
Password: password

Account #2
Email: friend1@gmail.com
Password: password

** Needs these two accounts to be friends
** Needs friend2 to be a friend of testgoal
** Needs some goal on friend1 so testgoal can like it.

=======================================

TC-PER-1: Update Goal Progress
TC-PER-2: Renaming Goal
TC-PER-3: Delete Goal
TC-PER-4: Updating Goal Timeline
TC-PER-5: Updating Reminders for Goals
TC-PER-7: Adding/Changing Avatar

Account
Email: testerpersonal@gmail.com
Password: password

Account #2
** Needs goal with name of "premade goal" & deadline "June 1st, 2020" & Units "0/10" already created 
** Needs goal with name of "premade goal2" & deadline "June 1st, 2020" & Units "0/1" already created 
** Needs goal with name of "premade goal3" & Units "5/10" already created
** Needs goal with name of "premade goal4" & Units "3/10" already created
** Needs goal with name of "delete this goal" & deadline "June 1st, 2020" & Units "0/1" already created

=======================================

TC-PER-6: Password Change

Account
Email: changepass@gmail.com
Password: oldpass

=======================================

TC-NOT-1: Comments from Friends

Account #1
Email: commenter@gmail.com
Password: password

Account #2:
Email: commentmain@gmail.com
Password: password

** The two accounts are friends
** commentmain must have a goal created

=======================================

TC-NOT-2: Upcoming Goal Reminders
TC-NOT-3: Friend Request
TC-NOT-4: Friend Accept

Account #1
Email: acc1@gmail.com
Password: password

Account #2:
Email: acc2@gmail.com
Password: password

** acc1 and acc2 must not be friends

==============================================================================

Requirements:
**
=======================================
Android device

Minimum Specifications:
1536 MB of RAM, we used the Pixel API 28 emulator device from android studio.

Average Specifications:
1536 MB of RAM, we used the Nexus 6 API 28 emulator device from android studio.

==============================================================================

Installation Instruction:
**
=======================================
We will be providing the application APK's as per the submission instructions. It will be on our
github repository https://github.com/EEZhuang/THRIVE.

How to install onto local machine: 
1. Clone the repo<br/>
   Run the command in your desired directory: git clone https://github.com/EEZhuang/THRIVE.git

2. Open the project in Android Studio<br/>
   i. Open Android Studio<br/>
   ii. Select 'Open an existing Android Studio project'<br/>
   iii. Navigate to the directory in which you cloned the repo<br/>
   iv. Select 'THRIVE' and press 'Open'<br/>

3. Within Android Studio, run an emulator with the proper specifications outlined in the section above<br/>
   i. Open your AVD Manager<br/>
   ii. Press the green play button to run your desired emulator<br/>

4. Install the apk by running the following commands in your terminal<br/>
   i. If your adb path is set up, simply run adb install build\app\outputs\apk\debug\app-debug.apk<br/>
      If your adb path is not set up, you must specify the path to run adb<br/>
      
      For Windows Users run: C:\Users\\[user]\Appdata\Local\Android\sdk\platform-tools\adb.exe install          build\app\outputs\apk\debug\app-debug.apk<br/>
      For Mac Users run: /Users/[user]/Library/Android/sdk/platform-tools/adb* install build/app/outputs/apk/debug/app-debug.apk<br/>
      Substitute your local username for [user]
      
      After a successful installation,  ‘Performing Streamed Install. Success’ should print to your terminal.
      
      ****
      If you receive the failure message: adb: failed to install build/app/outputs/apk/debug/app-debug.apk: Failure [INSTALL_FAILED_UPDATE_INCOMPATIBLE: Package com.example.thrivejs signatures do not match previously installed version; ignoring!]
      
      You must run the command adb uninstall "com.example.thrivejs"
      (Again, if your adb path is not specified you must run this command with the paths specified above)
      ***
         
         

5. Launch node<br/>
   Run the command: node index.js

6. View your emulator and navigate through its apps and click on 'thrive' with a Flutter icon

7. Now you're ready to start THRIVING!

==============================================================================

How to Run:
**
=======================================
Before running the application on an emulator, you would have to run "node index.js" within your
terminal. Therefore, you would need to have node js installed.  https://nodejs.org/en/

Now, with your emulator open, locate the 'thrive' app and press on the app icon
to start the app. If the app is not visible on the home screen, swipe up from
the bottom of the home screen to open the app drawer, where you can scroll
through the emulator's apps to find 'thrive'.

==============================================================================

Known Bugs:
**
=======================================
1. There is pixel overflow if you try to create a goal without a name nor a date. However, this
   should not affect the functionality of the code.

2. Potentially, it may take a while for the social wall or profile page to load.

3. Delete collaborator goals does not properly delete for collaborators. The goal will delete fine
   for the user, however, the goal gets deleted by the database but the user still seems to have a
   reference to it. It causes the social wall and profile to load infinitely for the collaborators
   who's goal got deleted.
