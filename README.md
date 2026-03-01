<div align="center">

# 🥗 Plan It Prep

### AI-Powered Personalized Diet & Nutrition Planning Platform

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-^3.5.0-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Integrated-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![Stripe](https://img.shields.io/badge/Stripe-Payments-635BFF?style=for-the-badge&logo=stripe&logoColor=white)](https://stripe.com)
[![GetX](https://img.shields.io/badge/GetX-State%20Mgmt-8B5CF6?style=for-the-badge)](https://pub.dev/packages/get)
[![License: MIT](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey?style=for-the-badge)]()

**Plan It Prep** is a production-grade, cross-platform mobile application that delivers AI-assisted personalized diet plans, macro nutrient tracking, meal management, weight progress monitoring, and subscription-based dietician services — built with Flutter and backed by a robust Firebase + REST API infrastructure.

| Application ID | `com.planit.prep` |
|---|---|
| **Current Version** | `1.0.0+1` |
| **Min Android SDK** | 24 (Android 7.0) |
| **Target Android SDK** | 35 (Android 15) |
| **Min iOS Version** | 13.0 |
| **Backend API** | `https://planitprep.cloud/` |

</div>

---

## 📑 Table of Contents

- [Overview](#-overview)
- [Key Features](#-key-features)
- [Architecture & Design Patterns](#-architecture--design-patterns)
- [Project Structure](#-project-structure)
- [Data Models](#-data-models)
- [Controllers (Business Logic)](#-controllers-business-logic)
- [Services (State Layer)](#-services-state-layer)
- [Views & Screens](#-views--screens)
- [Reusable Widgets & Components](#-reusable-widgets--components)
- [Routing & Navigation](#-routing--navigation)
- [Theming & Design System](#-theming--design-system)
- [Third-Party Integrations](#-third-party-integrations)
- [Prerequisites](#-prerequisites)
- [Installation & Setup](#-installation--setup)
- [Configuration](#-configuration)
- [Running the Application](#-running-the-application)
- [Building for Production](#-building-for-production)
- [API Reference](#-api-reference)
- [Push Notifications](#-push-notifications)
- [Payment Integration](#-payment-integration)
- [Local Packages](#-local-packages)
- [Assets & Resources](#-assets--resources)
- [Testing](#-testing)
- [Troubleshooting](#-troubleshooting)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🌟 Overview

**Plan It Prep** (`nutri_ai`) is a comprehensive nutrition and wellness platform that connects users with dietician-curated, AI-enhanced meal plans. The application guides users through a detailed onboarding flow — collecting health metrics, fitness goals, dietary preferences, allergen information, medical history, and cooking preferences — to generate highly personalized weekly diet charts with macro-level nutritional breakdowns.

### Core Value Propositions

| Value | Description |
|---|---|
| 🎯 **Personalized Nutrition** | AI-generated meal plans based on 15+ user health & preference parameters |
| 📊 **Macro Tracking** | Real-time tracking of calories, carbs, protein, fat, fiber, and water intake |
| 📈 **Weight Management** | Visual weight tracking with goal-based progress monitoring over time |
| 🍽️ **Meal Flexibility** | Swap meals, explore food alternatives, and manage serving sizes per item |
| 🛒 **Smart Grocery Lists** | Auto-generated daily, weekly, and monthly grocery lists from meal plans |
| 💳 **Subscription Plans** | Stripe-powered subscription management with multiple pricing tiers |
| 🔔 **Push Notifications** | Firebase Cloud Messaging for reminders, plan updates, and engagement |
| 🌍 **Multi-Region Support** | Country/state/city-based location services and locale configuration |

---

## ✨ Key Features

### 🔐 Authentication & Onboarding

| Feature | Details |
|---|---|
| **Multi-Provider Auth** | Google Sign-In, Apple Sign-In, Phone (OTP), and Email authentication |
| **Firebase Auth** | Secure token-based authentication via Firebase Authentication |
| **OTP Verification** | SMS-based auto-fill OTP verification with countdown timer |
| **Secure Storage** | Access tokens stored via `flutter_secure_storage` |
| **Rich Onboarding Flow** | 18-step registration collecting comprehensive user health profiles |

#### Onboarding Steps (Registration Flow)

| Step | Screen | Data Collected |
|---|---|---|
| 1 | `GetStarted` | Welcome & entry point |
| 2 | `RegisterName` | Full name |
| 3 | `RegisterSex` | Gender |
| 4 | `RegisterAge` | Age / Date of birth |
| 5 | `RegisterHeight` | Height (cm) |
| 6 | `RegisterWeight` | Current & target weight |
| 7 | `RegisterGoal` | Fitness goal (gain / lose / maintain) |
| 8 | `RegisterFitnessLevel` | Current fitness level |
| 9 | `RegisterExercisePlan` | Exercise plan days/week |
| 10 | `RegisterWorkoutPreferences` | Workout type preferences |
| 11 | `RegisterDietPreferences` | Veg / Non-veg / Vegan / etc. |
| 12 | `RegisterDietRegimes` | Specific diet regimes (Keto, Paleo, etc.) |
| 13 | `RegisterAllergens` | Food allergens |
| 14 | `RegisterMedicalIssues` | Medical conditions |
| 15 | `RegisterMedicalTest` | Medical test data |
| 16 | `RegisterLocation` | Country / State / City |
| 17 | `RegisterCuisines` | Cuisine preferences |
| 18 | `RegisterCookingPrep` | Cooking prep, appliances, time, meal count |
| 19 | `RegisterMealType` | Meal type preferences |
| 20 | `RegisterMealPrepSchedule` | Meal prep schedule |
| 21 | `RegisterReminderPreferences` | Notification & reminder settings |
| 22 | `RegisterTrackingPreference` | Tracking preferences |
| 23 | `RegisterDietPackages` | Subscription package selection |
| 24 | `RegisterCreatingPlan` | AI plan generation loading |

### 🍽️ Meal Plan Management

- **Daily Meal Plans**: View complete day-wise meal plans with breakfast, morning snack, lunch, evening snack, and dinner
- **Meal Swapping**: Replace food items within a meal with alternatives
- **Serving Size Control**: Adjust quantities and serving sizes per food item
- **Food Database Search**: Browse and search food items for meal customization
- **My Daily Meals**: Personalized view of consumed / planned meals
- **Surprise Meals**: AI-suggested surprise meal recommendations
- **Recipe Detail Cards**: Full recipe breakdowns with prep time, calories, veg/non-veg indicators, and step-by-step instructions

### 📊 Dashboard & Analytics

- **Calorie Gauge**: Visual circular gauge showing daily calorie intake vs target
- **Macro Progress Bars**: Individual progress bars for carbs, protein, fat, and fiber
- **Water Intake Tracker**: Daily hydration monitoring with time-slot breakdowns
- **Weight Tracking Charts**: Line chart visualizing weight progress over time
- **Weekly Macro Graphs**: Detailed macro consumption trends over 7/30-day periods
- **Individual Macro Tracker**: Dedicated line charts for each macro nutrient
- **Profile Card**: Dashboard user profile summary with health stats
- **Detailed Graph View**: Full-screen expandable graph viewer

### 📅 Calendar & Scheduling

- **Date-Based Meal Navigation**: Browse meal plans by calendar date
- **Cached Diet Plans**: Local caching of diet plan data per user for offline/fast access
- **Grocery Planning**: Date-aware grocery list generation

### 🛒 Grocery Management

- **Auto-Generated Lists**: Grocery items extracted from meal plans
- **Period-Based Views**: Toggle between daily, weekly, and monthly grocery lists
- **Veg/Non-Veg Indicators**: Clear dietary classification per item
- **Quantity Aggregation**: Amounts auto-summed across meals

### 👤 User Profile & Settings

- **Edit Profile**: Full profile editing with image upload (camera/gallery)
- **Progress Images**: Upload and track body progress photos over time
- **Membership Management**: View active/past memberships and subscription details
- **Payment History**: Complete transaction history with Stripe integration
- **Notifications Center**: In-app notification feed

### 💳 Subscription & Payments

- **Stripe Integration**: Full Stripe payment flow with publishable/secret keys
- **Multiple Plans**: Support for daily and monthly subscription tiers
- **Payment Intent**: Server-side payment intent creation via REST API
- **Subscription Management**: Create, view, and manage active subscriptions
- **Coupon System**: Apply promotional coupon codes at checkout
- **Payment History**: Detailed per-transaction payment records

---

## 🏗️ Architecture & Design Patterns

### Architectural Pattern: Service-Controller-View (SCV)

The application implements a clean **Service-Controller-View** architecture powered by [GetX](https://pub.dev/packages/get), separating concerns across three distinct layers:

```
┌─────────────────────────────────────────────────────────────────────┐
│                         PRESENTATION LAYER                          │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────────────┐   │
│  │  Views/   │  │ Widgets/ │  │  Styles/ │  │  Route Configs   │   │
│  │  Screens  │  │  Common  │  │  Theme   │  │  (GetPage)       │   │
│  └─────┬─────┘  └─────┬────┘  └─────┬────┘  └────────┬─────────┘  │
│        │              │             │                 │             │
├────────┼──────────────┼─────────────┼─────────────────┼─────────────┤
│        │       BUSINESS LOGIC LAYER │                 │             │
│        ▼              ▼             ▼                 ▼             │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                    GetX Controllers                         │   │
│  │  UserController  │ DashboardController │ MealPlanController │   │
│  │  PackageController │ RootController │ CalendarController    │   │
│  │  GroceryController │ SubscriptionController                │   │
│  └─────────────────────────────┬───────────────────────────────┘   │
│                                │                                    │
├────────────────────────────────┼────────────────────────────────────┤
│                         STATE LAYER                                 │
│                                ▼                                    │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │               GetX Services (Reactive State)                │   │
│  │  UserService │ DashboardService │ MealPlanService           │   │
│  │  PackageService │ RootService                               │   │
│  └─────────────────────────────┬───────────────────────────────┘   │
│                                │                                    │
├────────────────────────────────┼────────────────────────────────────┤
│                          DATA LAYER                                 │
│                                ▼                                    │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                       Models (40+)                          │   │
│  │  User │ MealPlan │ Meal │ Macros │ Package │ DashboardData  │   │
│  │  WeightTracking │ AppConfig │ Allergen │ Goal │ etc.        │   │
│  └─────────────────────────────┬───────────────────────────────┘   │
│                                │                                    │
├────────────────────────────────┼────────────────────────────────────┤
│                      INFRASTRUCTURE LAYER                           │
│                                ▼                                    │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐     │
│  │  REST API    │  │  Firebase    │  │  Local Storage       │     │
│  │  (HTTP/Dio)  │  │  (Auth/FCM)  │  │  (GetStorage/Secure) │     │
│  └──────────────┘  └──────────────┘  └──────────────────────┘     │
└─────────────────────────────────────────────────────────────────────┘
```

### Design Principles

| Principle | Implementation |
|---|---|
| **Barrel Exports** | Each module has an `xcore.dart` barrel file for clean imports |
| **Single Core Import** | `core.dart` re-exports all barrels — screens only need `import 'core.dart'` |
| **Permanent DI** | All services and controllers registered as permanent via `Get.put(..., permanent: true)` |
| **Reactive State** | All mutable state uses `.obs` with reactive `Obx()` widgets |
| **Service Locator** | `Get.find<T>()` used for dependency resolution across controllers |
| **Centralized API** | `Helper.sendRequestToServer()` centralizes all HTTP calls with auth headers |
| **Feature Flags** | `RootService.isFeatureAccessible` controls platform-level feature gating |
| **Remote Config** | `AppConfig` model loaded from server on app init for dynamic configuration |

---

## 📁 Project Structure

```
plan-it-prep-flutter/
│
├── 📄 pubspec.yaml                          # Dependencies & project config
├── 📄 analysis_options.yaml                 # Dart linter & analyzer rules
├── 📄 LICENSE                               # MIT License
├── 📄 README.md                             # This file
│
├── 📁 lib/                                  # ─── APPLICATION SOURCE CODE ───
│   ├── 📄 main.dart                         # App entry point, Firebase init, DI setup
│   ├── 📄 core.dart                         # Barrel export (single import for all modules)
│   │
│   ├── 📁 common/                           # ─── SHARED UTILITIES & UI ───
│   │   ├── 📄 helper.dart                   # HTTP client, formatters, URI builders (856 lines)
│   │   ├── 📄 xcore.dart                    # Barrel export for common module
│   │   ├── 📁 styles/                       # Design system tokens
│   │   │   ├── 📄 assets.dart               # Asset path constants (109 constants)
│   │   │   ├── 📄 colors.dart               # Color palette (light/dark/dashboard themes)
│   │   │   ├── 📄 fonts.dart                # Typography scale definitions
│   │   │   └── 📄 values.dart               # Spacing & dimension constants
│   │   └── 📁 widgets/                      # Reusable UI components (26 widgets)
│   │       ├── 📄 app_config.dart            # Base URL, API keys, app name
│   │       ├── 📄 calorie_gauge.dart         # Circular calorie progress gauge
│   │       ├── 📄 macro_progress_bar.dart    # Linear macro nutrient bars
│   │       ├── 📄 water_intake.dart          # Water tracking widget
│   │       ├── 📄 food_item_widget.dart      # Food item display card
│   │       ├── 📄 meals_list_widget.dart     # Meal list view
│   │       ├── 📄 weight_tracker_line_chart.dart
│   │       ├── 📄 macros_tracker_line_chart.dart
│   │       ├── 📄 individual_macros_tracker_line_chart.dart
│   │       ├── 📄 shimmer_widget.dart        # Loading shimmer placeholder
│   │       ├── 📄 shimmer_loader_for_meal_plan.dart
│   │       ├── 📄 custom_button_widget.dart  # Themed action buttons
│   │       ├── 📄 custom_form_field.dart     # Themed form inputs
│   │       ├── 📄 coupon_widget.dart         # Coupon code entry/apply
│   │       ├── 📄 date_picker_widget.dart    # Date selection widget
│   │       ├── 📄 number_selector.dart       # Numeric value picker
│   │       ├── 📄 nutrient_bar_widget.dart   # Nutrient breakdown bars
│   │       ├── 📄 weight_goal_widget.dart    # Weight goal display
│   │       ├── 📄 profile_card.dart          # User profile summary card
│   │       ├── 📄 app_bar.dart               # Custom app bar
│   │       ├── 📄 back_arrow_button.dart     # Navigation back button
│   │       ├── 📄 loader_widget.dart         # Loading indicator
│   │       ├── 📄 round_container.dart       # Rounded container wrapper
│   │       ├── 📄 marque_widget.dart         # Scrolling marquee text
│   │       ├── 📄 full_screen_graph.dart     # Expandable chart viewer
│   │       ├── 📄 sliver_app_bar_delegate.dart
│   │       ├── 📄 add_test.dart              # Medical test entry
│   │       ├── 📁 animated_digit/            # Animated number counter
│   │       └── 📁 country_state_city_pro/    # Location picker widget
│   │
│   ├── 📁 models/                           # ─── DATA MODELS (40 models) ───
│   │   ├── 📄 user.dart                     # User profile with health metrics
│   │   ├── 📄 meal_plan.dart                # Meal plan with list of meals
│   │   ├── 📄 meal.dart                     # Individual meal with food items
│   │   ├── 📄 meal_plan_item.dart           # Food item within a meal
│   │   ├── 📄 macros.dart                   # Macro nutrients (cal/carb/protein/fat/fiber/water)
│   │   ├── 📄 dashboard_data.dart           # Dashboard aggregate data
│   │   ├── 📄 weight_tracking.dart          # Weight progress entry
│   │   ├── 📄 package.dart                  # Subscription package + features
│   │   ├── 📄 app_config.dart               # Remote app configuration (feature flags)
│   │   ├── 📄 goal.dart                     # Fitness goals
│   │   ├── 📄 allergen.dart                 # Food allergens
│   │   ├── 📄 diet_type.dart                # Diet preferences (veg/non-veg)
│   │   ├── 📄 diet_regime.dart              # Diet regimes (keto/paleo)
│   │   ├── 📄 fitness_level.dart            # Fitness levels
│   │   ├── 📄 exercise_plan_days.dart       # Exercise frequency options
│   │   ├── 📄 medical_issue.dart            # Medical conditions
│   │   ├── 📄 medical_test.dart             # Medical test records
│   │   ├── 📄 gender.dart                   # Gender options
│   │   ├── 📄 country.dart                  # Country model
│   │   ├── 📄 city.dart                     # City model
│   │   ├── 📄 state_location.dart           # State/region model
│   │   ├── 📄 cuisine.dart                  # Cuisine preferences
│   │   ├── 📄 cooking_prep.dart             # Cooking preparation styles
│   │   ├── 📄 cooking_time.dart             # Available cooking time
│   │   ├── 📄 appliance.dart                # Kitchen appliances
│   │   ├── 📄 meal_count.dart               # Meals per day
│   │   ├── 📄 meal_prep_schedule.dart       # Meal prep frequency
│   │   ├── 📄 mealtype.dart                 # Meal type classification
│   │   ├── 📄 reminder_preference.dart      # Notification preferences
│   │   ├── 📄 coupon.dart                   # Promotional coupons
│   │   ├── 📄 notification.dart             # Notification model
│   │   ├── 📄 payment_model.dart            # Payment transaction records
│   │   ├── 📄 subscription_model.dart       # Stripe subscription details
│   │   ├── 📄 user_membership.dart          # User membership records
│   │   ├── 📄 user_payment.dart             # Payment history entries
│   │   ├── 📄 progress_image.dart           # Progress photo records
│   │   ├── 📄 upload_file.dart              # File upload model
│   │   ├── 📄 login_request.dart            # Auth request payload
│   │   ├── 📄 login_response.dart           # Auth response payload
│   │   └── 📄 xcore.dart                    # Barrel export
│   │
│   ├── 📁 controllers/                      # ─── BUSINESS LOGIC (10 controllers) ───
│   │   ├── 📄 user_controller.dart          # Auth, registration, profile (2180 lines)
│   │   ├── 📄 dashboard_controller.dart     # Dashboard data, charts, water (1129 lines)
│   │   ├── 📄 meal_plan_controller.dart     # Meal CRUD, swapping, search (581 lines)
│   │   ├── 📄 package_controller.dart       # Package listing, payments (210 lines)
│   │   ├── 📄 root_controller.dart          # App config, initial setup (343 lines)
│   │   ├── 📄 calendar_controller.dart      # Calendar, recipes, groceries (250 lines)
│   │   ├── 📄 grocery_controller.dart       # Grocery list management (77 lines)
│   │   ├── 📄 subscription_controller.dart  # Stripe subscriptions (104 lines)
│   │   ├── 📄 surpriseMealController.dart   # AI surprise meal feature
│   │   ├── 📄 PaymentController.dart        # Payment processing
│   │   └── 📄 xcore.dart                    # Barrel export
│   │
│   ├── 📁 services/                         # ─── REACTIVE STATE SERVICES ───
│   │   ├── 📄 root_service.dart             # App config, feature flags, internet state
│   │   ├── 📄 user_service.dart             # Auth state, user data, Google Sign-In
│   │   ├── 📄 dashboard_service.dart        # Dashboard state, weight data, macros graph
│   │   ├── 📄 meal_plan_service.dart        # Meal plan state, food items, selection
│   │   ├── 📄 package_service.dart          # Packages, coupons, features
│   │   └── 📄 xcore.dart                    # Barrel export
│   │
│   ├── 📁 views/                            # ─── UI SCREENS ───
│   │   ├── 📄 root.dart                     # Root/shell screen
│   │   ├── 📁 login/                        # Authentication screens
│   │   │   ├── 📄 login.dart                # Login (Google/Apple/Phone/Email)
│   │   │   └── 📄 verify_otp.dart           # OTP verification
│   │   ├── 📁 register/                     # Onboarding flow (28 screens)
│   │   │   ├── 📄 get_started.dart
│   │   │   ├── 📄 register_name.dart
│   │   │   ├── 📄 register_sex.dart
│   │   │   ├── 📄 register_age.dart
│   │   │   ├── 📄 register_height.dart
│   │   │   ├── 📄 register_weight.dart
│   │   │   ├── 📄 register_goal.dart
│   │   │   ├── 📄 register_fitness_level.dart
│   │   │   ├── 📄 register_exercise_plan.dart
│   │   │   ├── 📄 register_workout_preferences.dart
│   │   │   ├── 📄 register_diet_preferences.dart
│   │   │   ├── 📄 register_diet_regimes.dart
│   │   │   ├── 📄 register_allergens.dart
│   │   │   ├── 📄 register_medical_issues.dart
│   │   │   ├── 📄 register_medical_test.dart
│   │   │   ├── 📄 register_location.dart
│   │   │   ├── 📄 registerCuisines.dart
│   │   │   ├── 📄 register_cooking_prep.dart
│   │   │   ├── 📄 register_appliances.dart
│   │   │   ├── 📄 register_cooking_time.dart
│   │   │   ├── 📄 register_meal_count.dart
│   │   │   ├── 📄 register_meal_type.dart
│   │   │   ├── 📄 register_meal_prep_schedule.dart
│   │   │   ├── 📄 register_reminder_preferences.dart
│   │   │   ├── 📄 register_tracking_preference.dart
│   │   │   ├── 📄 register_diet_packages.dart
│   │   │   ├── 📄 register_creating_plan.dart
│   │   │   └── 📄 register_process.dart
│   │   ├── 📁 dashboard/                    # Main dashboard screens
│   │   │   ├── 📄 dashboard.dart            # Tab-based dashboard shell
│   │   │   ├── 📄 home.dart                 # Home screen with macro summary
│   │   │   ├── 📄 detailed_graph.dart       # Full-screen macro graphs
│   │   │   ├── 📄 notifications.dart        # Notification list
│   │   │   ├── 📄 progress_image_uploader.dart
│   │   │   ├── 📄 surpriseMeal.dart         # Surprise meal recommendation
│   │   │   ├── 📄 surPriseMeal2.dart        # Surprise meal variant
│   │   │   └── 📁 widgets/                  # Dashboard-specific widgets
│   │   │       ├── 📄 calorie_gauge.dart
│   │   │       ├── 📄 homepage_meal_widget.dart
│   │   │       ├── 📄 macro_progress_bar.dart
│   │   │       ├── 📄 profile_card.dart
│   │   │       └── 📄 water_intake.dart
│   │   ├── 📁 meal/                         # Meal plan screens
│   │   │   ├── 📄 daily_meals.dart          # Day-wise meal plan view
│   │   │   ├── 📄 my_daily_meals.dart       # User's consumed meals
│   │   │   └── 📄 food_list.dart            # Searchable food database
│   │   ├── 📁 calender/                     # Calendar & scheduling
│   │   │   └── 📄 calendar_page.dart        # Date-based meal browser
│   │   ├── 📁 grocery/                      # Grocery management
│   │   │   └── 📄 grocery_page.dart         # Grocery list (daily/weekly/monthly)
│   │   ├── 📁 weight/                       # Weight tracking
│   │   │   └── 📄 weight_tracker.dart       # Weight chart & entry
│   │   ├── 📁 profile/                      # User profile section
│   │   │   ├── 📄 user_profile.dart         # Profile overview
│   │   │   ├── 📄 edit_profile.dart         # Edit profile form
│   │   │   ├── 📄 memberships_list.dart     # Active memberships
│   │   │   ├── 📄 payment_history.dart      # Transaction history
│   │   │   └── 📄 progress_images.dart      # Progress photo gallery
│   │   ├── 📁 payment/                      # Payment & subscription screens
│   │   │   ├── 📄 stripePayment.dart        # Stripe payment flow
│   │   │   ├── 📄 payment_details_page.dart # Subscription details
│   │   │   └── 📄 payment_history_page.dart # Payment records
│   │   ├── 📁 checkout/                     # Checkout flow
│   │   │   ├── 📄 payment_view.dart         # Checkout screen
│   │   │   └── 📄 loading_page.dart         # Plan generation loading
│   │   └── 📄 xcore.dart                    # Barrel export
│   │
│   └── 📁 routes/                           # ─── NAVIGATION ───
│       ├── 📄 routes.dart                   # Route definitions & GetPage mappings
│       ├── 📄 app_routes.dart               # (Reserved for route constants)
│       └── 📄 xcore.dart                    # Barrel export
│
├── 📁 packages/                             # ─── LOCAL/FORKED PACKAGES ───
│   ├── 📁 country_picker/                   # Customized country selector
│   ├── 📁 get_4.7.2/                        # GetX v4.7.2 (pinned local copy)
│   ├── 📁 get_storage/                      # GetStorage (local key-value store)
│   └── 📁 numberpicker/                     # Customized number picker widget
│
├── 📁 assets/                               # ─── STATIC ASSETS ───
│   ├── 📁 icons/                            # UI icons (SVG, PNG, WebP, GIF)
│   ├── 📁 images/                           # Image assets (welcome, logos, etc.)
│   ├── 📁 lottie/                           # Lottie JSON animations (loader, etc.)
│   ├── 📁 locations/                        # Location data files
│   └── 📁 videos/                           # Video assets
│
├── 📁 android/                              # ─── ANDROID PLATFORM ───
│   ├── 📄 build.gradle                      # Root Gradle config (GMS plugin)
│   ├── 📄 gradle.properties                 # JVM args, AndroidX, Jetifier
│   ├── 📄 settings.gradle                   # Gradle settings
│   └── 📁 app/
│       ├── 📄 build.gradle                  # App Gradle (compileSdk 36, minSdk 24)
│       ├── 📄 google-services.json          # Firebase config (active)
│       ├── 📄 proguard-rules.pro            # ProGuard rules (Stripe, Razorpay)
│       └── 📁 src/                          # Android source
│
└── 📁 ios/                                  # ─── iOS PLATFORM ───
    ├── 📄 Podfile                           # CocoaPods (iOS 13.0 minimum)
    ├── 📄 Podfile.lock                      # Locked pod versions
    ├── 📁 Runner/                           # iOS app target
    ├── 📁 Runner.xcodeproj/                 # Xcode project
    ├── 📁 Runner.xcworkspace/               # Xcode workspace
    └── 📁 RunnerTests/                      # iOS unit tests
```

---

## 📊 Data Models

The application defines **40+ data models** representing the complete domain:

### Core Domain Models

| Model | File | Purpose |
|---|---|---|
| `User` | `user.dart` | User profile: name, email, phone, height, weight, target weight, daily macro targets, membership dates |
| `MealPlan` | `meal_plan.dart` | Container for a collection of meals (status + meals list) |
| `Meal` | `meal.dart` | Individual meal (breakfast/lunch/etc.) with food items and aggregate macros |
| `MealPlanFoodItem` | `meal_plan_item.dart` | Single food item: name, quantity, serving size, macros |
| `Macros` | `macros.dart` | Nutritional data: calories, carbs, protein, fat, fiber, water |
| `DashboardData` | `dashboard_data.dart` | Aggregated dashboard: today's macros, consumed macros, weekly trends, weight |
| `WeightTracking` | `weight_tracking.dart` | Weight entry: date, current weight, target weight |
| `AppConfig` | `app_config.dart` | Server-driven configuration: feature flags, login providers, reference data lists |

### Health & Preference Models

| Model | File | Purpose |
|---|---|---|
| `Goal` | `goal.dart` | Fitness goals (weight gain / loss / maintain) |
| `FitnessLevel` | `fitness_level.dart` | User fitness level classification |
| `ExercisePlanDays` | `exercise_plan_days.dart` | Weekly exercise frequency options |
| `DietPreference` | `diet_type.dart` | Dietary type (veg / non-veg / vegan / etc.) |
| `DietRegime` | `diet_regime.dart` | Specific diet regimes (keto, paleo, etc.) |
| `Allergen` | `allergen.dart` | Food allergens list |
| `MedicalIssue` | `medical_issue.dart` | Medical condition records |
| `MedicalTest` | `medical_test.dart` | Medical test data |
| `Gender` | `gender.dart` | Gender options |
| `Cuisine` | `cuisine.dart` | Cuisine type preferences |
| `CookingPrep` | `cooking_prep.dart` | Cooking preparation style |
| `CookingTime` | `cooking_time.dart` | Available cooking time |
| `Appliance` | `appliance.dart` | Kitchen appliance availability |
| `MealCount` | `meal_count.dart` | Number of meals per day |
| `MealPrepSchedule` | `meal_prep_schedule.dart` | Meal preparation frequency |
| `ReminderPreference` | `reminder_preference.dart` | Notification preferences |

### Commerce & Location Models

| Model | File | Purpose |
|---|---|---|
| `Package` | `package.dart` | Subscription package: title, price, discounted price, features |
| `PackageFeature` | `package.dart` | Individual package feature entry |
| `CouponItem` | `coupon.dart` | Promotional coupon codes |
| `SubscriptionModel` | `subscription_model.dart` | Stripe subscription records |
| `UserPayment` | `user_payment.dart` | Payment transaction entries |
| `UserMembership` | `user_membership.dart` | Membership records |
| `PaymentModel` | `payment_model.dart` | Payment processing data |
| `Country` | `country.dart` | Country reference data |
| `City` | `city.dart` | City reference data |
| `StateLocation` | `state_location.dart` | State/region reference data |

### Utility Models

| Model | File | Purpose |
|---|---|---|
| `LoginRequest` | `login_request.dart` | Authentication request payload |
| `LoginResponse` | `login_response.dart` | Authentication response with token |
| `ProgressImage` | `progress_image.dart` | Body progress photo metadata |
| `UploadFile` | `upload_file.dart` | File upload metadata |
| `NotificationModel` | `notification.dart` | Push/in-app notification data |
| `MacroData` | `macros.dart` | Chart-ready macro data (name, value, color) |
| `RecipeCardData` | `calendar_controller.dart` | Recipe card display data |
| `GroceryItem` | `grocery_controller.dart` | Grocery list item |

---

## 🎮 Controllers (Business Logic)

Controllers handle all business logic, API interactions, and user actions:

| Controller | Lines | Responsibilities |
|---|---|---|
| **`UserController`** | 2,180 | Authentication (Google/Apple/Phone/Email), 24-step onboarding flow, profile CRUD, file upload, OTP verification, password reset, progress image management, notification handling |
| **`DashboardController`** | 1,129 | Dashboard data fetching, pie/line chart data preparation, water intake management, weight logging, macro graph data processing, date range filtering |
| **`MealPlanController`** | 581 | Fetch daily/personal meal plans, food item search, meal swapping, quantity adjustment, serving size changes, food like/dislike |
| **`RootController`** | 343 | App config loading from server, initial data seeding, AI-generated weekly diet chart storage |
| **`CalendarController`** | 250 | Calendar date selection, date-based meal fetching, recipe card parsing, grocery list by meal, local diet plan caching via `GetStorage` |
| **`PackageController`** | 210 | Package listing, payment initiation, coupon application, purchase completion, payment status handling |
| **`SubscriptionController`** | 104 | Stripe subscription fetching, price tier mapping, subscription display formatting |
| **`GroceryController`** | 77 | Grocery list generation by period (daily/weekly/monthly), veg/non-veg classification |
| **`SurpriseMealController`** | — | AI-powered surprise meal recommendation logic |

---

## 🔧 Services (State Layer)

Services are long-lived `GetxService` instances that persist throughout the app lifecycle:

| Service | Reactive State Properties |
|---|---|
| **`RootService`** | `config` (AppConfig), `isInternetWorking`, `firstTimeLoad`, `uploadProgress`, `isOnHomePage`, `isFeatureAccessible` (computed) |
| **`UserService`** | `isLoggedIn`, `currentUser`, `googleSignIn`, `socialUserProfile`, `notificationsCount`, `myPaymentTransactions`, `myProgressImages`, `myMemberships`, `notifications` |
| **`DashboardService`** | `currentPage`, `pageController`, `data` (DashboardData), `weightTrackingData`, `graphMacrosConsumed`, date range filters, `isOnDashboard` |
| **`MealPlanService`** | `mealPlan`, `myMeal`, `selectedMeal`, `foodItems`, `replaceFoodItems`, `selectedFoodItem`, `selectedQty`, `selectedServingSize`, date/meal filters |
| **`PackageService`** | `packages`, `currentPackage`, `packageFeatures`, `appliedCouponValue`, `couponCode`, `activeCouponsData` |

---

## 📱 Views & Screens

### Screen Inventory (50+ screens)

| Module | Screens | Description |
|---|---|---|
| **Login** (2) | `Login`, `VerifyOTP` | Multi-provider authentication with OTP flow |
| **Register** (28) | `GetStarted` through `RegisterCreatingPlan` | Comprehensive health-profile onboarding |
| **Dashboard** (7) | `Dashboard`, `Home`, `DetailedGraph`, `Notifications`, `ProgressImageUploader`, `SurpriseMeal`, `SurpriseMeal2` | Main app dashboard with analytics |
| **Meal** (3) | `DailyMeals`, `MyDailyMeals`, `FoodList` | Meal plan viewing and food search |
| **Calendar** (1) | `CalendarPage` | Date-based meal plan browser |
| **Grocery** (1) | `GroceryPage` | Smart grocery list manager |
| **Weight** (1) | `WeightTracker` | Weight progress tracking |
| **Profile** (5) | `UserProfile`, `EditProfile`, `MembershipsList`, `PaymentHistory`, `ProgressImages` | User account management |
| **Payment** (3) | `StripePaymentPage`, `SubscriptionDetailsPage`, `SubscriptionHistoryPage` | Stripe payment & subscription |
| **Checkout** (2) | `PaymentView`, `LoadingPage` | Checkout flow and loading states |

---

## 🧩 Reusable Widgets & Components

| Widget | Purpose |
|---|---|
| `CalorieGauge` | Syncfusion circular gauge for daily calorie progress |
| `MacroProgressBar` | Animated linear progress bar per macro nutrient |
| `WaterIntake` | Time-slot based water tracking display |
| `HomepageMealWidget` | Compact meal card for dashboard home |
| `ProfileCard` | User summary card with health stats |
| `FoodItemWidget` | Food item display with macros and actions |
| `MealsListWidget` | Scrollable list of meals for a given day |
| `WeightTrackerLineChart` | FL Chart line graph for weight over time |
| `MacrosTrackerLineChart` | Combined macro trend chart |
| `IndividualMacrosTrackerLineChart` | Per-macro detailed line chart |
| `WeightGoalWidget` | Visual goal indicator (current → target) |
| `NutrientBarWidget` | Horizontal bar chart for nutrient breakdown |
| `ShimmerWidget` | Generic loading skeleton placeholder |
| `ShimmerLoaderForMealPlan` | Meal-plan-specific loading skeleton |
| `CustomButtonWidget` | Themed elevated button with consistent styling |
| `CustomFormField` | Themed text input with validation |
| `CouponWidget` | Coupon code input with apply action |
| `DatePickerWidget` | Themed date selection |
| `NumberSelector` | Numeric stepper/picker |
| `FullScreenGraph` | Expandable full-screen chart viewer |
| `AnimatedDigit` | Animated counting number display |
| `CountryStateCityPro` | Cascading location picker (Country → State → City) |
| `MarqueWidget` | Auto-scrolling marquee text |
| `RoundContainer` | Styled rounded card container |
| `AppBar` | Custom app bar with back navigation |
| `BackArrowButton` | Styled back navigation button |
| `SliverAppBarDelegate` | Custom sliver app bar for scroll effects |
| `LoaderWidget` | Centralized loading indicator |
| `AddTest` | Medical test entry form |

---

## 🧭 Routing & Navigation

The app uses **GetX named routing** with 25+ registered routes:

| Route Path | Screen | Description |
|---|---|---|
| `/` | `GetStarted` | Welcome / splash |
| `/login` | `Login` | Authentication |
| `/verify-otp` | `VerifyOTP` | OTP verification |
| `/register` | `Register` | Onboarding entry |
| `/packages` | `RegisterDietPackages` | Package selection |
| `/checkout` | `PaymentView` | Checkout |
| `/dashboard` | `Dashboard` | Main dashboard |
| `/home` | `Home` | Home tab |
| `/daily-meals` | `DailyMeals` | Day's meal plan |
| `/my-meals` | `MyDailyMeals` | Personal meal log |
| `/food-list` | `FoodList` | Food database search |
| `/weight-tracker` | `WeightTracker` | Weight chart |
| `/payments-history` | `PaymentHistory` | Transaction list |
| `/packages-list` | `MembershipsList` | Memberships |
| `/progress-images` | `ProgressImages` | Progress photos |
| `/edit-profile` | `EditProfile` | Profile editing |
| `/notifications` | `NotificationsView` | Notifications |
| `/loading-page` | `LoadingPage` | Plan generation |
| `/surprise-meal` | `SurpriseMeal` | Surprise meal |
| `/payment` | `StripePaymentPage` | Stripe payment |
| `/stripePaymentHistory` | `SubscriptionHistoryPage` | Sub. history |
| `/stripePaymentDetails` | `SubscriptionDetailsPage` | Sub. details |

All routes are configured with `participatesInRootNavigator: true` and `preventDuplicates: true` where applicable.

---

## 🎨 Theming & Design System

### Typography

The app uses **Google Fonts: Poppins** as the primary typeface with a defined type scale:

| Text Style | Size | Weight |
|---|---|---|
| `headlineLarge` | 22px | Bold |
| `headlineMedium` | 18px | Bold |
| `headlineSmall` | 16px | Bold |
| `titleLarge` | 18px | Regular |
| `titleMedium` | 16px | Regular |
| `titleSmall` | 14px | Regular |
| `bodyLarge` | 18px | Regular |
| `bodyMedium` | 16px | Regular |
| `bodySmall` | 14px | Regular |
| `buttonText` | 16px | Regular |

### Color System

The app defines a **triple-theme color system** (Light / Dark / Dashboard Dark):

| Token | Light Theme | Purpose |
|---|---|---|
| `Primary` | `#F5F5F5` | Background |
| `Accent` | `#310682` | Brand accent |
| `Button BG` | `#4CAF50` | Primary actions (green) |
| `Heading` | `#2E7D32` | Dark green headings |
| `Text` | `#212121` | Body text |
| `Divider` | `#BDBDBD` | Separators |
| `Hint` | `#9E9E9E` | Placeholder text |

#### Macro Color Palette

| Macro | Color | Hex |
|---|---|---|
| 🔥 Calories | Vivid Orange | `#FF6D3F` |
| 🍞 Carbs | Golden Amber | `#FBC02D` |
| 💪 Protein | Steel Blue | `#4682B4` |
| 🧈 Fat | Soft Caramel | `#F4A261` |
| 🥬 Fiber | Fresh Green | `#4CAF50` |
| 💧 Water | Aqua Blue | `#29B6F6` |

### Design Tokens

| Token | Value |
|---|---|
| `glBorderRadius` | 16.0 |
| Primary Gradient | `#4CAF50` → `#81C784` |
| Secondary Gradient | `#FCE4EC` → `#E8F5E9` |

---

## 🔌 Third-Party Integrations

### Complete Dependency Map

| Category | Package | Version | Purpose |
|---|---|---|---|
| **State Management** | `get` | 4.7.2 (local) | Reactive state, DI, routing, controllers |
| **Local Storage** | `get_storage` | local | Lightweight key-value persistence |
| **Secure Storage** | `flutter_secure_storage` | ^9.2.4 | Encrypted token/credential storage |
| **Firebase Core** | `firebase_core` | ^4.3.0 | Firebase initialization |
| **Firebase Auth** | `firebase_auth` | ^6.1.3 | Authentication service |
| **Firebase Messaging** | `firebase_messaging` | ^16.1.0 | Push notifications (FCM) |
| **Google Sign-In** | `google_sign_in` | ^6.2.1 | Google OAuth |
| **Apple Sign-In** | `sign_in_with_apple` | ^6.1.4 | Apple OAuth |
| **Stripe** | `flutter_stripe` | ^12.1.1 | Payment processing |
| **HTTP Client** | `http` | ^1.3.0 | REST API calls |
| **Dio** | `dio` | ^5.8.0+1 | Advanced HTTP (file uploads) |
| **Notifications** | `flutter_local_notifications` | ^19.0.0-dev.4 | Local push notifications |
| **SMS Auto-Fill** | `sms_autofill` | ^2.4.0 | OTP auto-detection |
| **Charts** | `fl_chart` | 0.69.0 | Pie, line, and bar charts |
| **Syncfusion Gauge** | `syncfusion_flutter_gauges` | ^30.1.38 | Circular calorie gauges |
| **Syncfusion DatePicker** | `syncfusion_flutter_datepicker` | ^30.1.38 | Calendar date picker |
| **SVG Rendering** | `flutter_svg` | ^2.0.17 | SVG icon rendering |
| **Google Fonts** | `google_fonts` | 6.2.1 | Poppins font family |
| **Image Caching** | `cached_network_image` | ^3.4.0 | Network image caching |
| **Image Picker** | `image_picker` | 1.1.2 | Camera/gallery image selection |
| **File Picker** | `file_picker` | ^9.0.2 | File selection |
| **Animations** | `flutter_animate` | ^4.5.2 | Declarative animations |
| **Lottie** | `lottie` | ^3.3.1 | Lottie JSON animations |
| **Animations (Material)** | `animations` | 2.0.11 | Material motion |
| **Video Player** | `video_player` | 2.9.3 | Video playback |
| **Carousel** | `carousel_slider` | 5.0.0 | Image/card carousels |
| **Toast** | `toastification` | ^3.0.1 | Toast notifications |
| **Loading** | `flutter_easyloading` | ^3.0.5 | Full-screen loading overlay |
| **Progress Bars** | `simple_animation_progress_bar` | ^1.8.2 | Animated progress bars |
| **Circular Progress** | `simple_circular_progress_bar` | ^1.0.2 | Circular progress indicators |
| **Dialogs** | `awesome_dialog` | 3.2.1 | Styled alert dialogs |
| **Material Dialogs** | `material_dialogs` | 1.1.5 | Material-style dialogs |
| **OTP Input** | `pinput` | ^5.0.1 | PIN/OTP input field |
| **VelocityX** | `velocity_x` | 4.3.1 | UI utility extensions |
| **URL Launcher** | `url_launcher` | ^6.3.1 | External URL opening |
| **Intl** | `intl` | ^0.20.2 | Date/number formatting |
| **Device Info** | `device_info_plus` | ^11.3.0 | Device metadata |
| **Dropdown** | `dropdown_search` | ^6.0.1 | Searchable dropdowns |
| **Date Picker** | `date_picker_plus` | ^4.1.0 | Enhanced date picker |
| **Dotted Lines** | `dotted_dashed_line` | ^0.0.3 | Decorative dotted lines |
| **Tabler Icons** | `flutter_tabler_icons` | ^1.43.0 | Icon set |
| **Number Picker** | `numberpicker` | local | Numeric value selector |
| **Country Picker** | `country_picker` | ^2.0.27 | Country selection |
| **ChatGPT SDK** | `chat_gpt_sdk` | ^3.1.4 | AI-powered meal generation |
| **Overlay Loading** | `overlay_loading_progress` | ^1.0.2 | Upload progress overlay |
| **Launcher Icons** | `flutter_launcher_icons` | ^0.13.1 | App icon generation |
| **Package Name** | `change_app_package_name` | ^1.5.0 | Package name management |

---

## 📋 Prerequisites

| Requirement | Minimum Version | Notes |
|---|---|---|
| **Flutter SDK** | 3.x (Dart ^3.5.0) | `flutter --version` |
| **Dart SDK** | ^3.5.0 | Included with Flutter |
| **Android Studio** | 2023.x+ | With Android SDK 36, NDK 25.1.8937393 |
| **Xcode** | 15.x+ | macOS only, for iOS builds |
| **CocoaPods** | 1.12+ | `gem install cocoapods` |
| **Java JDK** | 8+ (target 1.8) | For Android Gradle builds |
| **Git** | 2.x+ | Version control |
| **Firebase CLI** | Latest | For Firebase project management |

### Verify Setup

```bash
flutter doctor -v
```

Ensure all required components show ✅ before proceeding.

---

## ⚙️ Installation & Setup

### 1. Clone the Repository

```bash
git clone https://github.com/<your-org>/plan-it-prep-flutter.git
cd plan-it-prep-flutter
```

### 2. Install Flutter Dependencies

```bash
flutter pub get
```

### 3. Install iOS Dependencies (macOS only)

```bash
cd ios
pod install --repo-update
cd ..
```

### 4. Configure Firebase

#### Android
Place your Firebase `google-services.json` in `android/app/`:

```
android/app/google-services.json
```

#### iOS
Add `GoogleService-Info.plist` to the Xcode project:

```
ios/Runner/GoogleService-Info.plist
```

### 5. Configure Stripe

Update the Stripe publishable key in `lib/main.dart`:

```dart
Stripe.publishableKey = 'pk_test_YOUR_KEY_HERE';
```

### 6. Configure API Endpoint

Update the base URL and API credentials in `lib/common/widgets/app_config.dart`:

```dart
String appName = "Planit";
String baseUrl = "https://planitprep.cloud/";
String apiUser = "YOUR_API_USER";
String apiKey = "YOUR_API_KEY";
```

---

## 🔧 Configuration

### Environment Configuration Files

| File | Purpose |
|---|---|
| `lib/common/widgets/app_config.dart` | Base URL, API credentials, app name, Pusher keys |
| `lib/main.dart` (lines 28-48) | Stripe publishable key, Firebase options (API key, app ID, project ID) |
| `android/app/build.gradle` | Android namespace, SDK versions, signing config |
| `android/gradle.properties` | JVM args (`-Xmx4G`), AndroidX, Jetifier |
| `android/app/proguard-rules.pro` | ProGuard rules for Stripe and Razorpay |
| `ios/Podfile` | iOS minimum version (`13.0`), build configurations |
| `analysis_options.yaml` | Dart analyzer rules, suppressed warnings |

### Firebase Configuration Variants

The repository maintains multiple Firebase config files for environment management:

| File | Environment |
|---|---|
| `google-services.json` | **Active** production config |
| `client-google-services.json` | Client/staging environment |
| `new-work-google-services.json` | Development environment |
| `old-google-services.json` | Legacy/archive |
| `past-google-services.json` | Previous configuration backup |
| `workable-google-services.json` | Working/test environment |

> ⚠️ **Important**: Only `google-services.json` is read by the build system. Swap files to target different Firebase projects.

### Android Signing Configuration

The app uses a `key.properties` file for release signing:

```properties
# android/key.properties (NOT committed to VCS)
keyAlias=your-key-alias
keyPassword=your-key-password
storeFile=/path/to/your-keystore.jks
storePassword=your-store-password
```

### Remote App Configuration

The `AppConfig` model is loaded from the server on startup (`GET /api/v1/app-config`) and provides:

- Feature flags (`testingAndroid`, `testingIos`, `enableFreeMembership`, `showPaymentsMemberships`)
- Login provider toggles (`googleLogin`, `mobileLogin`, `emailLogin`, `appleLogin`)
- Reference data lists (fitness levels, medical issues, exercise plans, diet types, allergens, diet regimes, goals, cuisines, cooking preps, appliances, cooking time, meal count, meal prep schedule, countries, medical tests)

---

## 🚀 Running the Application

### Development

```bash
# List available devices
flutter devices

# Run in debug mode (default device)
flutter run

# Run on a specific device
flutter run -d <device_id>

# Run in verbose mode
flutter run -v

# Run with a specific flavor (if configured)
flutter run --dart-define=ENV=development
```

### Hot Reload & Hot Restart

| Action | Key | Effect |
|---|---|---|
| Hot Reload | `r` | Apply changes without restarting |
| Hot Restart | `R` | Full restart preserving session |
| Quit | `q` | Stop the running app |

### Debug Tools

```bash
# Open Flutter DevTools
flutter run --observatory-port=8888

# Analyze code
flutter analyze

# Format code
dart format lib/
```

---

## 📦 Building for Production

### Android

```bash
# Build APK (universal)
flutter build apk --release

# Build APK per ABI (recommended for distribution)
flutter build apk --split-per-abi --release

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release
```

**Output Locations:**
| Build Type | Path |
|---|---|
| APK | `build/app/outputs/flutter-apk/app-release.apk` |
| Per-ABI APKs | `build/app/outputs/flutter-apk/app-{abi}-release.apk` |
| App Bundle | `build/app/outputs/bundle/release/app-release.aab` |

### iOS

```bash
# Build iOS release
flutter build ios --release

# Build IPA for distribution
flutter build ipa --release
```

> **Note**: iOS builds require:
> - Valid Apple Developer account
> - Signing certificates & provisioning profiles configured in Xcode
> - `Runner.xcworkspace` opened in Xcode for archive → distribute workflow

### ProGuard Configuration

ProGuard rules in `android/app/proguard-rules.pro` protect:
- **Stripe SDK** classes (`com.stripe.**`)
- **Razorpay SDK** classes (`com.razorpay.**`) — legacy, retained for compatibility
- **Kotlin Parcelize** annotations

---

## 🌐 API Reference

### Base Configuration

| Property | Value |
|---|---|
| Base URL | `https://planitprep.cloud/` |
| API Version | `v1` |
| API Path | `/api/v1/{endpoint}` |
| Auth Header | `Authorization: Bearer {token}` |
| Custom Headers | `USER: {apiUser}`, `KEY: {apiKey}` |

### Known API Endpoints

| Endpoint | Method | Description |
|---|---|---|
| `app-config` | POST | Fetch remote app configuration & reference data |
| `fetch-meals` | POST | Fetch meal plan by day number |
| `fetch-my-meals` | POST | Fetch user's personal meals by date |
| `get-packages` | POST | Fetch subscription packages & features |
| `create-payment-intent` | POST | Create Stripe payment intent |
| `create-subscription` | POST | Create Stripe subscription |
| `plans/getAllPlans` | GET | Fetch all available plans |
| `payments-subscriptions-data` | GET | Fetch subscription history |

### API Communication Pattern

All API calls are routed through `Helper.sendRequestToServer()`:

```dart
// Centralized HTTP client with auth headers
static Future<Response> sendRequestToServer({
  required String endPoint,
  required Map<String, String> requestData,
}) async {
  Uri uri = Helper.getUri(endPoint); // Builds: {baseUrl}/api/v1/{endPoint}
  // Includes USER, KEY, and Bearer token headers
}
```

---

## 🔔 Push Notifications

### Firebase Cloud Messaging (FCM) Setup

| Component | Implementation |
|---|---|
| **Foreground** | `FirebaseMessaging.onMessage` → `showFlutterNotification()` |
| **Background** | `@pragma('vm:entry-point')` `_firebaseMessagingBackgroundHandler()` |
| **Terminated** | Handled via FCM background handler |
| **Channel** | `high_importance_channel` (Android) |
| **Permissions** | Alert, Badge, Sound (all enabled) |

### Notification Flow

1. Firebase initializes in `main()` → `initServices()`
2. Background handler registered: `FirebaseMessaging.onBackgroundMessage()`
3. Notification channel created: `AndroidNotificationChannel('high_importance_channel')`
4. Foreground presentation options set: `alert: true, badge: true, sound: true`
5. `FlutterLocalNotificationsPlugin` displays notifications with custom icon

---

## 💳 Payment Integration

### Stripe Configuration

| Property | Value |
|---|---|
| Payment Provider | Stripe |
| SDK | `flutter_stripe` ^12.1.1 |
| Mode | Test (pk_test_*) |
| Payment Intents | Server-side creation via `/api/v1/create-payment-intent` |
| Subscriptions | Server-side via `/api/v1/create-subscription` |

### Subscription Tiers

| Plan | Price ID | Amount | Duration |
|---|---|---|---|
| Monthly Plan | `price_1SqWXY...` | ₹499 | Per month |
| Daily Plan | `price_1SqWay...` | ₹49 | Per day |

### Payment Flow

```
User selects package → Apply coupon (optional) → Create Payment Intent (API)
→ Stripe Payment Sheet → Confirm payment → Record transaction (API) → Navigate to dashboard
```

---

## 📦 Local Packages

The `packages/` directory contains locally maintained (forked/pinned) Flutter packages:

| Package | Reason for Local Copy |
|---|---|
| `get_4.7.2` | Pinned GetX version to prevent breaking changes; specific bug fixes applied |
| `get_storage` | Local fork for customized storage behavior |
| `country_picker` | Customized UI and data for country selection |
| `numberpicker` | Modified number picker with app-specific styling |

These are referenced in `pubspec.yaml` via path dependencies:

```yaml
get:
  path: "./packages/get_4.7.2"
get_storage:
  path: "./packages/get_storage"
numberpicker:
  path: ./packages/numberpicker
```

---

## 🎨 Assets & Resources

### Asset Directories

| Directory | Contents | Format |
|---|---|---|
| `assets/icons/` | 80+ UI icons | SVG, PNG, WebP, GIF |
| `assets/images/` | Logos, welcome screens, backgrounds | JPG, PNG, SVG |
| `assets/lottie/` | Loading animations (e.g., `loader.json`) | Lottie JSON |
| `assets/videos/` | Onboarding/instructional videos | MP4 |
| `assets/locations/` | Location reference data | Data files |

### Icon Categories

| Category | Examples |
|---|---|
| **Food & Nutrition** | apple, chicken, eggs, nuts, fruits, breakfast, lunch, evening-snack, morning-snack, dish, diet-bowl, junk-food, non-veg, coffee |
| **Body & Fitness** | arm, body, bmi, fat-body, muscle, overweight, bone-joints, gut, lings, cardio, stairs |
| **Health Tracking** | burn, drop, stats, progress, gripfire |
| **Goals & Plans** | gain-mass, loss-mass, maintain, 1-2 days, 3-4 days, 5-6 days, everyday, 1-month, 3-month, 6-month |
| **UI Controls** | plus, minus, edit, delete, check, menu, home, notifications, chevron-left, circle-down, circle-plus, shutter, share-fill, like, dislike |
| **Profile & Settings** | about, logout, membership, notification, payment-info, mobile |
| **Theme** | Icon-sun, moon |

### Registered Asset Paths (pubspec.yaml)

```yaml
assets:
  - assets/images/
  - assets/icons/
  - assets/videos/
  - assets/lottie/
  - assets/locations/
```

---

## 🧪 Testing

### Running Tests

```bash
# Run all unit & widget tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run a specific test file
flutter test test/<test_file>.dart

# Generate coverage report (lcov)
flutter test --coverage && genhtml coverage/lcov.info -o coverage/html

# Run integration tests
flutter test integration_test/
```

### iOS Tests

iOS unit tests are located in `ios/RunnerTests/`.

### Static Analysis

```bash
# Run Dart analyzer
flutter analyze

# Check formatting
dart format --set-exit-if-changed lib/

# Custom lint rules (analysis_options.yaml)
# - invalid_use_of_protected_member: ignored
# - Base rules: package:flutter_lints/flutter.yaml
```

---

## 🔍 Troubleshooting

### Common Issues

| Issue | Solution |
|---|---|
| `firebase_core` not initialized | Ensure `Firebase.initializeApp()` is called before any Firebase service. Check `firebaseOptions` in `main.dart` |
| Stripe not loading | Verify `Stripe.publishableKey` is set before `Stripe.instance.applySettings()` |
| iOS build fails with CocoaPods error | Run `cd ios && pod install --repo-update && cd ..` |
| Gradle build fails | Verify `org.gradle.jvmargs=-Xmx4G` in `gradle.properties`. Ensure JDK 8+ is configured |
| Android SDK version mismatch | `compileSdkVersion 36`, `minSdkVersion 24`, `targetSdkVersion 35` required |
| NDK not found | Install NDK version `25.1.8937393` via Android Studio SDK Manager |
| `GetStorage` not initialized | Ensure `await GetStorage.init()` is called before any `GetStorage()` reads |
| Background notifications not working | Verify `@pragma('vm:entry-point')` annotation on background handler |
| `google-services.json` mismatch | Ensure the active file matches your Firebase project. Only `google-services.json` is read by Gradle |
| MultiDex issues | `multiDexEnabled true` is set in `android/app/build.gradle` |
| Core library desugaring | `coreLibraryDesugaringEnabled true` + `com.android.tools:desugar_jdk_libs:2.1.4` |

### Useful Commands

```bash
# Clean build artifacts
flutter clean

# Rebuild from scratch
flutter clean && flutter pub get && cd ios && pod install && cd ..

# Check outdated dependencies
flutter pub outdated

# Upgrade dependencies
flutter pub upgrade --major-versions

# View dependency tree
flutter pub deps
```

---

## 🤝 Contributing

### Branch Naming Convention

```
feature/<feature-name>        # New features
bugfix/<bug-description>       # Bug fixes
hotfix/<hotfix-description>    # Urgent production fixes
release/<version>              # Release preparation
refactor/<scope>               # Code refactoring
```

### Commit Message Format

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <short description>

[optional body]

[optional footer(s)]
```

**Types:** `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `perf`, `ci`, `build`

**Examples:**
```
feat(meal-plan): add surprise meal recommendation
fix(auth): resolve Google Sign-In token refresh issue
docs(readme): update installation instructions
refactor(controllers): extract macro calculation logic
```

### Development Workflow

1. Fork the repository
2. Create a feature branch from `main`
3. Make changes following [Effective Dart](https://dart.dev/effective-dart) guidelines
4. Ensure linter passes: `flutter analyze`
5. Format code: `dart format lib/`
6. Write/update tests for changed functionality
7. Submit a pull request with detailed description

### Code Conventions

- **File naming**: `snake_case.dart` for all Dart files
- **Class naming**: `PascalCase` for classes, `camelCase` for methods/variables
- **Barrel exports**: Every module has an `xcore.dart` barrel file
- **State**: All mutable state must use `.obs` reactive variables
- **Controllers**: Extend `GetxController`, services extend `GetxService`
- **API calls**: Route through `Helper.sendRequestToServer()`
- **Navigation**: Use `Get.toNamed()` with named routes only

---

## 📄 License

This project is licensed under the **MIT License**.

```
MIT License

Copyright (c) 2025 saurabhunify

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

<div align="center">

**Built with ❤️ using Flutter**

[⬆ Back to Top](#-plan-it-prep)

</div>
