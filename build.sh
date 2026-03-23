#!/bin/bash
# automated Vercel deployment script for Flutter

echo "Cloning Flutter SDK..."
git clone https://github.com/flutter/flutter.git -b stable

echo "Adding Flutter to PATH..."
export PATH="$PATH:`pwd`/flutter/bin"

echo "Verifying Flutter version..."
flutter --version

echo "Fetching dependencies..."
flutter pub get

echo "Generating Hive Adapters..."
dart run build_runner build -d

echo "Building Production Web App..."
flutter build web --release
