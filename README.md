# Gridy

A pet project — a mobile Kanban board inspired by Trello, built with Swift for iOS.

---

## About

Gridy is a learning project to explore iOS development patterns around gesture handling, custom layouts, and interactive UI. The idea was simple: build a board where tasks live in columns and can be moved around — like a mini Trello, but native.

---

## Features

- **Kanban board** with three columns: *To Do*, *In Progress*, *Done*
- **Drag & drop** — cards can be dragged from one column to another
- **Tap to open** — tapping a card opens it for details
- **Pinch-to-zoom** — the board supports two zoom states:
  - Default: ~85% of the first column is visible, with a peek of the second
  - Pinch out: all three columns fit on screen at once

---

## Tech Stack

- Swift
- UIKit
- UIGestureRecognizer (pan, tap, pinch)
- No third-party dependencies

---

## Getting Started

1. Clone the repo:
   ```bash
   git clone https://github.com/julimorozova/Gridy.git
   ```
2. Open `Gridy.xcodeproj` in Xcode
3. Select a simulator or device and run (⌘R)

> Requires Xcode 14+ and iOS 15+


