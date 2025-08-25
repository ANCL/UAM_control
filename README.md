# UAM_control

*A MATLAB toolkit for Unmanned Aerial Manipulator (UAM) control experiments: numerical models, trajectory generation, and pick-and-drop task controllers.*

---

## Table of contents
- [Overview](#overview)
- [Repository structure](#repository-structure)
- [Project configuration](#project-configuration)
- [Requirements](#Requirements)

---

## Overview
`UAM_control` contains MATLAB code and helper utilities for experimenting with UAM control problems. It focuses on:

- **Trajectory generation** utilities for waypoints, smooth references, and task-specific paths.
- **Pick-and-drop** control examples demonstrating closed-loop execution of simple manipulation/transport tasks.
- **Robotics utilities** shared across modules (filters, frames, geometry, plotting, etc.).

> **Note:** This repository currently targets MATLAB; see the [Requirements](#requirements) section.

---

## Repository structure
UAM_control/
├─ Trajectory/ # Reference/trajectory generation utilities and control demo
├─ PicknDrop/ # Pick-and-drop task controller and demo
└─ robotics_lib/ # Common MATLAB helpers (math, transforms, plotting, I/O)

- Each module is designed to run standalone once `robotics_lib` is on the MATLAB path.

---

## Requirements
- **MATLAB** R2021a or newer  
- Signal Processing Toolbox (optional; for filtering/plots)  
- Control System Toolbox (optional; for some demos)

---
