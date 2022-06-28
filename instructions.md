**Appointment Scheduler** is built with **Dart** & **Flutter**.

To run this project one must do the following steps:

1.  Install [Dart Sdk](https://dart.dev/get-dart). Follow the steps in the website to accurately install and set the sdk's path in your Enviroment Variables.

2. Install [Flutter Sdk](https://docs.flutter.dev/get-started/install) from here and follow the instructions to set the flutter sdk in your device.     [N.B : As the project is built on null safety it's wise to use flutter sdk version 2+. We've used flutter 2.5.3]      
    Try giving the command  ```flutter doctor -v``` in terminal to see if everything is okay.

3. Now you need an editor/IDE to run the project. It's recommended to use [Android Studio](https://developer.android.com/studio) but you can also use [Microsoft VScode](https://code.visualstudio.com/) if you want a light weight editor. You can learn how to set up your editor for flutter from [here](https://docs.flutter.dev/get-started/editor)

4. Now you are ready to import the repo from given github link. There will be a section in both Android Studio and VScode from where you can import flutter projects from Version Control.
You can use the following links to learn more about it.
    * [Android Studio](https://www.youtube.com/watch?v=DbG8uZwdDow)
    * [VScode](https://www.youtube.com/watch?v=XIm7ofsCEH4)

5. After the import, there might be bunch of errors. You shouldn't freak out. All you need to do is go to the terminal of the project and write:
    ```
    flutter pub get
    ```
    Or you could just go to the **pubspec.yaml** file and hit save.

6. One last thing needed to be done is setting up an emulator to run the project. You can follow the below links to create an android emulator:
    * for [Android Studio](https://www.youtube.com/watch?v=x_lvdLil0Fk)
    * for [VScode](https://flutteragency.com/set-up-an-emulator-for-vscode/)
    
    if you have a physical android device which has debuggable permissions you can also run the project via USB cable connecting your physical device and pc. You can learn more about it from [here](https://www.youtube.com/watch?v=UuLdD7oyML8)

7. Finally you can now run the project. Give the given commands in your terminal:
    ```
    flutter devices
    ```
    *To check that an Android device is running. If none are shown, you should create one following **step 6***

    then give: 
    ```
    flutter run
    ```
    There are other ways to run the project. You can learn from the *Run the App* section from [here](https://docs.flutter.dev/get-started/test-drive?tab=androidstudio).


#FAQ
-----

1. I have errors in my terminal after giving ```flutter doctor -v```. What to do?       
    **Answer**: There might be a couple of issues.      
    * First of all you might want to check if you've set your **Enviroment Variables Path** correctly.
    * If you've got an error regarding *Android Licence Agreement* you have to manually accept all the licences. In this case do the following:
        * Open your terminal
        * type ```flutter doctor --android-licenses```
        * press ```y``` to accept every license.
    * If you've got an error regarding devices: try following ***Step 6***

2. I still have errors after I used ```flutter pub get```. What to do?      
    **Answer**: Sometimes after importing or cloning other project your IDE/Editors failed to get all the dependencies in the first try. In this case try using ***Step 5*** another time and hopefully it will fix the errors.

3. Some of the packages are giving error. What to do?       
    **Answer**: This might happen if you use outdated packages or in the near future if you use more updated versions of them. That's why we are giving all the dependencies and their versions below:      
    **dependencies**:
```
  intl: ^0.17.0
  date_format: ^2.0.2
  provider: ^6.0.1
  animations: ^2.0.2
  table_calendar: ^3.0.3
  image_picker: ^0.8.4+4
  http: ^0.13.4
  cupertino_icons: ^1.0.4
  firebase_auth: ^3.3.0
  cloud_firestore: ^3.1.1
  fluttertoast: ^8.0.8
  flutter_speed_dial: ^4.6.6
  geolocator: ^8.0.0
  google_maps_flutter: ^2.1.0
  url_launcher: ^6.0.17 
  flutter_local_notifications: ^9.0.0
  rxdart: ^0.27.2
  flutter_native_timezone: ^2.0.0
  firebase_storage: ^10.2.4
  file_picker: ^4.3.0
  email_auth: ^1.0.0
  barcode_widget: ^2.0.2
  flutter_barcode_scanner: ^2.0.0
  path_provider: ^2.0.8  
  wc_flutter_share: ^0.4.0
  dropdown_button2: ^1.0.7
```  
    
