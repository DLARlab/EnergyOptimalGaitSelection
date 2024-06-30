# Energy-Optimal Asymmetrical Gait Selection for Quadrupedal Robots

## Summary Video

https://github.com/DLARlab/EnergyOptimalGaitSelection/assets/80292027/30baa0d6-38bb-4767-87ae-5aaf0b949e54

## Overview

This document presents the code utilized for constructing a nonlinear programming (NLP) problem aimed at identifying five optimal asymmetrical gaits for the A1 quadrupedal robot, specifically: Pronking Forward (PF), Bounding with Extended Suspension (BE), Bounding with Gathered Suspension (BG), Bounding with Two Suspensions (B2), and Bounding without Suspension (B0). This code employs Fast Robot Optimization and Simulation (FROST) toolkit (https://github.com/ayonga/frost-dev). Additionally, the solutions trajectories, energetics (cost of transport and joint work), and center of mass variations results are also presented and illustrated. 


Contents:
* Gaits: Code for generating the solutions of the pronking gait and all four bounding gaits, including creating the hybrid system and the NLP problem cost functions and constraints.
* Data: Gaits libraries of the five gaits at different speeds.

Features:

* **Hybrid Dynamics:** Creating realistic models for any robot and formulating them as hybrid dynamics with impact models.
* **Animations:** Generate the animations and the trajectories of any solution. 
* **NLP:** Constructing and solving NLP problems.

This is research code, expect that it changes often and any fitness for a particular purpose is disclaimed.

The source code is released under a [BSD 3-Clause license](LICENSE).

**Author: Yasser G. Alqaham, Jing Cheng, Zhenyu Gan<br />
Affiliation: [DLAR Lab](https://dlarlab.syr.edu)<br />
Maintainer: Yasser G. Alqaham, ygalqaha@syr.edu />**
With contributions by: Zhenyu Gan, Ayonga Hereid, and Aaron D. Ames.

This projected was initially developed at Syracuse University (Dynamic Locomotion and Robotics Lab).

![Asymmetrical Gaits Diagram](https://github.com/DLARlab/EnergyOptimalGaitSelection/assets/80292027/a26a0851-715c-46e2-9ee5-feb732a1f9ac)

## Publications

This work has been submitted to IEEE Robotics and Automation Letters (RAL).

## Requirements

To use this code, you need MATLAB R2019b and Wolfram Mathematica 12.1.

## Usage

* **For optimization:**

1- Download FROST framework from (https://github.com/ayonga/frost-dev) and follow the steps on the installation page.

2- Add the "Gait" folder to the main folder of FROST.

3- For each gait, run the main file section by section. For example, B2 main file name is "A1BoundingB2."

* **For visualizing the data:**

1- Run "Plot_Data" file.



