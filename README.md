# HealthSync Flutter Project

## Overview
HealthSync is a comprehensive health management application tailored to assist users in managing their health, with a primary focus on controlling type 2 diabetes. This application serves as a digital partner in the user's health journey, offering various functionalities to monitor and improve health outcomes.

## Tech Stack
- **Flutter & Dart:** Core framework and language for developing the application.
- **SQLite:** Database for storing user data and health inputs.
- **APIs:** Integration with Edamam API and Google YouTube API.
- **Version Control:** GitHub for version control and collaboration.

## APIs Used
- **Edamam API:** Retrieves nutrition and recipe information.
- **Google YouTube API:** Fetches health-related videos from YouTube.

> **Note:** Replace the API keys for the Edamam API and Google YouTube API with your own keys in the respective files.

## Assets
The project uses specific images as assets:

- **Image 1:** [Link](https://illustimage.com/?id=2272)
- **Image 2:** [Link](https://thumb.ac-illust.com/31/31829d1be0a1381998bbbcd5f3beb181_w.jpeg)

### Steps to Include Assets:
1. Download the images from the provided links.
2. Add these images to the `assets` folder in your project directory.
3. Update the `pubspec.yaml` file to include these assets under the `assets:` section.

```yaml
flutter:
  assets:
    - assets/image1.jpeg
    - assets/image2.jpeg
```
## Installation

### Prerequisites
Ensure that the following tools are installed on your system:
- **Flutter SDK:** Follow the [Installation Guide](https://flutter.dev/docs/get-started/install).
- **Dart SDK:** Included with Flutter.
- **A suitable code editor:** For example, Visual Studio Code or Android Studio.

### Steps to Run the Application

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/username/HealthSync.git
   cd HealthSync
   ```

2. **Install Dependencies:**
   Update your Flutter dependencies by running:
   ```bash
   flutter pub get
   ```

3. **Download and Include Assets:**
   - Download the specified images from the provided links.
   - Place them in the `assets/` directory of your project.
   - Ensure the `pubspec.yaml` file is correctly configured to include these assets:
     ```yaml
     flutter:
       assets:
         - assets/image1.jpeg
         - assets/image2.jpeg
     ```

4. **Configure API Keys:**
   Replace the placeholder API keys with your own in the relevant Dart files (`recipie.dart` and `ytube.dart`).

5. **Run the Application:**
   Execute the application using the following command:
   ```bash
   flutter run lib/sidebar.dart
   ```
## Contributions
Contributions to the HealthSync project are welcome. If you'd like to contribute, please submit a pull request with your changes, and we'll review it for inclusion in the project.

We appreciate your contributions and look forward to collaborating with you!
