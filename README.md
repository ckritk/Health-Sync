# HealthSync Flutter Project
HealthSync is a comprehensive health management application designed to assist users in managing their health, with a current focus on controlling type 2 diabetes. This application acts as a partner in the user's health management journey, providing various functionalities to monitor and improve health.

## Project Structure
The HealthSync project consists of the following key files:

### Database Files:

**dbhelper.dart:** This file manages the storage of user details, including the type of disease, user name, and emergency contacts.

**dbhelper1.dart:** This file stores the user's daily health inputs such as blood pressure, sugar levels, exercise duration, diet details, and sleep duration.
### User Interface Files:

**editprofile.dart:** This file contains the interface for users to input their personal information.

**emergency.dart:** This file handles the functionality for making emergency calls when the emergency button is pressed.

**fitness.dart:** This file provides suggestions for different types of exercises.

**profile.dart:** This file displays the user's profile page.

**proginput.dart:** This file collects daily health statistics from the user.

**progress.dart:** This file displays the user's health progress over time.

**recipie.dart:** This file presents recipes suitable for diabetes management.

**ytube.dart:** This file retrieves relevant health-related videos from YouTube.

**main.dart:** This file is currently empty and does not contain any code.
### Homepage File:

**sidebar.dart:** This file contains the code for the homepage and handles sidebar navigation functionality.

## APIs Used
The project utilizes the following APIs:

**Edamam API:** Used for retrieving nutrition and recipe information.

**Google YouTube API:** Used for retrieving relevant health-related videos from YouTube.

**Note:** API keys for the Edamam API and Google YouTube API must be replaced with your own keys.
## Assets
The project uses two specific images as assets:

Image 1 : https://illustimage.com/?id=2272

Image 2 : https://thumb.ac-illust.com/31/31829d1be0a1381998bbbcd5f3beb181_w.jpeg

These images should be downloaded and included in the assets folder.

## How to Run the Project
To run the HealthSync project, follow these steps:

### Download and include the assets:

Download the images from the provided links.
Add these images to the assets folder in your project directory.
### Edit pubspec.yaml:

Open the pubspec.yaml file.
Edit the assets and the depecdencies
### Run the Main Application:

Execute the sidebar.dart file to start the application.
Use the command:      flutter run lib/sidebar.dart


