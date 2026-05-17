# SYNAPSE — Spatial Intelligence Platform

Point your phone at any object in your home. Synapse identifies it and gives you instant control. Built with Flutter and PocketBase.

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.16+-02569B?logo=flutter&logoColor=white" alt="Flutter"/>
  <img src="https://img.shields.io/badge/Dart-3.2+-0175C2?logo=dart&logoColor=white" alt="Dart"/>
  <img src="https://img.shields.io/badge/Platform-Android%20|%20iOS%20|%20Web-blue" alt="Platform"/>
  <img src="https://img.shields.io/badge/Backend-PocketBase-orange" alt="Backend"/>
  <img src="https://img.shields.io/badge/License-MIT-purple" alt="License"/>
</p>

## Live Demo

**[Try Synapse Now](https://YOUR-NETLIFY-URL.netlify.app)**

## What It Does

**Object Detection and Control**
Point your camera at lights, thermostats, locks, speakers, or appliances. Synapse identifies the device and shows a control panel. Toggle power, adjust brightness, change temperature. Every action saves to the backend.

**Room Management**
Switch between rooms during scanning. Living room, bedroom, kitchen, office, garage. Each room has its own set of detected devices.

**Energy Monitoring**
Live energy flow visualization with particle streams. Track solar production, battery levels, and grid consumption. View 24-hour usage charts and get tomorrow's forecast with cost estimates.

**AI Assistant**
Chat with Synapse using natural language. Ask about energy usage, control devices, activate scenes. The assistant understands commands for lights, temperature, security, and more.

**Device Scheduling**
Set schedules for lights, thermostats, and appliances. Choose days of the week and specific times. Toggle schedules on and off as needed.

**Authentication**
Sign up with email and password. After login, face scan simulation provides an extra layer of security. PIN and voice authentication are also available as backup methods.

**Activity Tracking**
Every device interaction is logged with timestamps. View the timeline in the Memory tab. Swipe to delete entries. Audit log shows all system events by category.

**Data Export**
Export your data as a formatted text report or machine-readable JSON. Useful for energy analysis or sharing with others.

**Enterprise Features**
Command palette with keyboard shortcuts, global search across all devices and rooms, user management with role-based access, analytics dashboard with charts, and system status monitoring.

## Architecture

Feature-first folder structure. Each feature contains its own screens, services, and models. Shared widgets and services are separated at the root level.

The backend runs on PocketBase, an open-source Go backend. Authentication uses PocketBase's built-in users collection. Device states and interactions are stored in custom collections.

All icons are custom painted. No icon font dependencies. Particle systems, holographic orbs, and ambient backgrounds use Flutter's Canvas API directly.

## Running Locally

```bash
git clone https://github.com/YOUR_USERNAME/synapse.git
cd synapse
flutter pub get
flutter run -d chrome
or the backend, download PocketBase from pocketbase.io and run:

bash
./pocketbase serve
Open the admin panel at http://127.0.0.1:8090/_/ and create an admin account. Then create two collections:

devices:
user_id (text)
name (text)
type (text)
is_on (bool)

interactions:
user_id (text)
device_name (text)
action (text)

Unlock all API rules for both collections before running the app.

Built With
Flutter for the frontend. PocketBase for the backend. flutter_animate for animations. sensors_plus for gyroscope. shared_preferences for local state. shimmer for loading effects.