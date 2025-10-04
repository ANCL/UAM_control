# UAM_control

A MATLAB toolkit for Unmanned Aerial Manipulator (UAM) control experiments: numerical models, trajectory generation, and pick‑and‑drop task controllers.

---

## Table of contents

* [Features](#features)
* [Repository layout](#repository-layout)
* [Requirements](#requirements)
* [Scripts & models overview](#scripts--models-overview)
* [License](#license)

---

## Features

* A collection of **MATLAB scripts** for plotting, parameter setting, randomizing initial conditions, and publishing figures.
* **Simulink models** for tasks such as pick‑and‑drop and figure‑8 trajectory tracking.
* A reusable **`robotics_lib/`** with helpers for frames, geometry, numerics, and plotting.

---

## Repository layout

```
UAM_control/
├─ robotics_lib/           % common MATLAB helpers (math, transforms, plotting, I/O)
├─ README.md
├─ choose_settling.m
├─ compare_randomized_cases.m
├─ compare_w_nonadaptive.m
├─ figure8trajectory.m
├─ figure8trajectory2021_final.slx
├─ fixedarm_plotsgen.m
├─ io_pickndrop_plotsgen.m
├─ myprinttemplate.mat
├─ myprinttemplate2.mat
├─ pickndrop.slx
├─ random_initialization.m
└─ saveFigureAsPDF.m
```

---

## Requirements

* **MATLAB** R2021a or newer.
* **Toolboxes (commonly used):**

  * Signal Processing Toolbox
  * Control System Toolbox

Scripts/models that require a specific toolbox will error or warn with a clear message—open the file header for details.

---
## Scripts & models overview

* **robotics_lib/** — shared utilities (frames, transforms, plotting, I/O). Add this to your path before running examples.
* **figure8trajectory.m** — parmeter setting for the controller.
* **figure8trajectory2021_final.slx** — Simulink model for trajectory tracking.
* **pickndrop.slx** — pick‑and‑place task model.
* **choose_settling.m** — helper to select settling‑time logic for experiments.
* **random_initialization.m** — creates randomized initial conditions for batch testing.
* **compare_randomized_cases.m / compare_w_nonadaptive.m** — illustrative comparisons between control setups.
* **saveFigureAsPDF.m** — consistent, publication‑ready figure export.
* **myprinttemplate.mat / myprinttemplate2.mat** — templates for figure aesthetics.
* **io_pickndrop_plotsgen.m / fixedarm_plotsgen.m** — plotting scripts.

---

## License

ANCL2025.
