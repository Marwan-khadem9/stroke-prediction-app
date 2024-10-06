# Stroke Prediction App

## Overview
This Flutter application predicts the likelihood of a stroke based on various health and lifestyle factors. It uses a TensorFlow Lite model for predictions and provides a user-friendly interface for input and result display.

## Features

- Input health metrics such as age, BMI, and glucose level
- Select categorical data like gender, residence type, and work type
- Utilizes a TensorFlow Lite model for stroke prediction
- Dark/Light mode toggle for user preference
- Responsive design for various screen sizes

## Technologies Used

- Flutter
- Dart
- TensorFlow Lite
- Android Studio
- VS Code

## Getting Started

Prerequisites:

- Flutter SDK
- Dart SDK
- VS Code with Flutter & Dart extension
- An Android or iOS device/emulator

## Installation

1. Clone the repository:

    ```bash
       git clone https://github.com/your-username/stroke-prediction-app.git

2. Navigate to the project directory:

     ```bash
        cd stroke-prediction-app

3. Install dependencies:
   
     ```bash
        flutter pub get

4. Run the app:

     ```bash
        flutter run


## Usage

- Launch the app on your device or emulator.
- Input your health metrics using the sliders and dropdown menus.
- Select appropriate options for categorical data.
- Tap the "Predict Stroke" button to get the result.
- View the prediction result at the bottom of the screen.

## Model Information
The stroke prediction is based on a TensorFlow Lite model trained on https://www.kaggle.com/datasets/fedesoriano/stroke-prediction-dataset. The model takes into account factors such as age, BMI, glucose level, gender, and lifestyle choices to estimate stroke risk.

Project Link: https://github.com/Marwan-khadem9/stroke-prediction-app

## Acknowledgements

Flutter

TensorFlow Lite

[Dataset Source](https://www.kaggle.com/datasets/fedesoriano/stroke-prediction-dataset)
