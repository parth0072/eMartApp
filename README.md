# eMart — SwiftUI iOS E-Commerce App

A modern, fully native iOS e-commerce application built with SwiftUI, targeting iOS 17+.

---

## 📱 Screenshots

> *(Coming soon — screens added progressively)*

---

## 🚀 Features

- [x] Custom design system (colors, typography, spacing)
- [x] Reusable base components (buttons, cards, badges, search, text fields)
- [x] Home screen with banner carousel, categories, and order history
- [ ] Explore / Product listing screen
- [ ] Product detail screen
- [ ] Cart screen
- [ ] Wishlist screen
- [ ] Profile screen
- [ ] Checkout flow

---

## 🛠 Tech Stack

| | |
|---|---|
| **Language** | Swift 5.0 |
| **UI Framework** | SwiftUI |
| **Minimum iOS** | 17.0 |
| **Devices** | iPhone + iPad (portrait & landscape) |
| **Architecture** | MVVM *(progressive)* |
| **Dependency Manager** | None *(pure SwiftUI)* |

---

## 📁 Project Structure

```
eMart/
├── Theme/
│   └── AppTheme.swift          # Colors, typography, spacing, radius, shadows
│
├── Components/
│   ├── AppButton.swift         # Primary, secondary, outline, ghost, danger buttons
│   ├── BadgeView.swift         # Notification badges, tags, discount & rating badges
│   ├── SearchBar.swift         # Search input with filter button & suggestions
│   ├── ProductCard.swift       # Vertical (grid) & horizontal (list) product cards
│   ├── SectionHeader.swift     # Section titles, category chips, empty state
│   └── AppTextField.swift      # Text fields, secure input, quantity stepper
│
├── Screens/
│   └── Home/
│       └── HomeView.swift      # Home screen (banner carousel, categories, orders)
│
├── ContentView.swift           # Root view with custom tab bar navigation
└── eMarApp.swift               # @main App entry point
```

---

## 🎨 Design System

### Primary Color
| Token | Hex | Usage |
|---|---|---|
| `primaryOrange` | `#F97316` | CTAs, active states, highlights |
| `primaryDark` | `#EA580C` | Gradient end, pressed states |
| `primaryLight` | `#FDBA74` | Icons, decorative |
| `primaryPastel` | `#FFF7ED` | Backgrounds, badges |

### Typography — `AppFont`
`display1/2` · `h1–h4` · `bodyLG/MD/SM` · `labelLG/MD/SM` · `caption` · `priceLG/MD/SM`

### Spacing — `AppSpacing`
`xxs(2)` · `xs(4)` · `sm(8)` · `md(12)` · `lg(16)` · `xl(20)` · `xxl(24)` · `x3l(32)` · `x4l(40)` · `x5l(48)`

---

## ⚙️ Setup

1. Clone the repo
   ```bash
   git clone https://github.com/parth0072/eMartApp.git
   cd eMartApp
   ```

2. Open in Xcode
   ```bash
   open eMart/eMart.xcodeproj
   ```

3. Select a simulator (iPhone 14 or later, iOS 17+) and press **⌘R**

> No dependencies to install — pure SwiftUI, zero third-party packages.

---

## 🏗 Architecture

The app follows a progressive **MVVM** approach:
- **Views** live in `Screens/` and `Components/`
- **Models** are defined alongside their screens initially, then extracted as the app grows
- **ViewModels** will be added per screen as business logic is introduced

---

## 📋 Development Workflow

- UI screens are implemented one at a time from design mockups
- Each screen uses shared base components from `Components/`
- Theme tokens ensure consistent styling across the entire app
- Build is verified clean (`xcodebuild`) before every commit

---

## 📄 License

MIT License — feel free to use this as a reference or starting point.
