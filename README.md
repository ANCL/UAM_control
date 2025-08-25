# UAM_control

*A MATLAB toolkit for Urban Air Mobility (UAM) control experiments: numerical models, trajectory generation, and pick-and-drop task controllers.*

> **Status:** early draft README (to be adapted to your final structure and conventions). Sections marked **TODO** need your confirmation or details.

---

## Table of contents
- [Overview](#overview)
- [Repository structure](#repository-structure)
- [Requirements](#requirements)
- [Installation](#installation)
- [Quick start](#quick-start)
- [Usage guide](#usage-guide)
  - [Numerical modeling](#numerical-modeling)
  - [Trajectory generation](#trajectory-generation)
  - [Pick-and-drop demo](#pick-and-drop-demo)
- [Project configuration](#project-configuration)
- [Tips & troubleshooting](#tips--troubleshooting)
- [Citing](#citing)
- [Contributing](#contributing)
- [License](#license)

---

## Overview
`UAM_control` contains MATLAB code and helper utilities for experimenting with UAM control problems. It focuses on:

- **Numerical models** of the vehicle/load dynamics for offline simulation and controller prototyping.
- **Trajectory generation** utilities for waypoints, smooth references, and task-specific paths.
- **Pick-and-drop** control examples demonstrating closed-loop execution of simple manipulation/transport tasks.
- **Robotics utilities** shared across modules (filters, frames, geometry, plotting, etc.).

> **Note:** This repository currently targets MATLAB; see the [Requirements](#requirements) section.

---

## Repository structure
UAM_control/
├─ NumericalModel/ # Dynamics, parameters, simulation scripts
├─ Trajectory/ # Reference/trajectory generation utilities and examples
├─ PicknDrop/ # Pick-and-drop task controllers and demos
└─ robotics_lib/ # Common MATLAB helpers (math, transforms, plotting, I/O)

- Each module is designed to run standalone once `robotics_lib` is on the MATLAB path.
- Example scripts in subfolders are usually prefixed with `run_*.m` for quick experiments.

---

## Requirements
- **MATLAB** R2021a or newer  
- Signal Processing Toolbox (optional; for filtering/plots)  
- Control System Toolbox (optional; for some demos)

---
