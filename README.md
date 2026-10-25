# Irrgarten - Labyrinth Survival Game (Ruby)

Irrgarten is a turn-based role-playing and survival game developed in Ruby where players must escape a labyrinth filled with monsters by managing attacks, defenses, and rewards.
This project was developed as part of the Object-Oriented Programming and Design (PDOO in University of Granada, Spain) course, with the main goal of applying design patterns and software engineering best practices.


🚀 Highlighted Technical Concepts

The development of this project demonstrates the practical application of the following advanced concepts:

- Object-Oriented Programming (OOP): Extensive use of classes, modules (to emulate enumerations), encapsulation, and visibility control.
- Inheritance and Polymorphism: Generalization of common behaviors (e.g., LabyrinthCharacter as the parent class of Player and Monster; CombatElement for Weapon and Shield), enabling dynamic binding and reusable code.
- MVC Architecture (Model-View-Controller): Strict separation of business logic (Irrgarten), user interface (UI), and game flow coordination (Control), achieving low coupling and high cohesion.
- Design based on High Cohesion and Low Coupling: Each class has a single, clearly defined responsibility (SRP - Single Responsibility Principle).


📁 Project Structure

The code is organized following the MVC architecture:

Irrgarten/ (Model): Contains all the business logic, combat elements (weapon.rb, shield.rb), characters (player.rb, monster.rb, fuzzy_player.rb), the board (labyrinth.rb), and the random decision engine (dice.rb).

UI/ (View): Handles user interaction via the console (textUI.rb).

Control/ (Controller): Coordinates actions between the view and the model (controller.rb).

main.rb: Application entry point.


🛠️ How to run the game

To run this project, you need to have Ruby installed on your system.

Clone this repository:

git clone https://github.com/your-username/irrgarten-ruby.git

Navigate to the project directory:

cd irrgarten-ruby

Execute the main file:

ruby main.rb


🎮 Basic Rules

The goal is to reach the exit square (E) of the labyrinth.

Players move using the arrow keys. If they land on a square occupied by a monster (M), an automatic combat is triggered.

Combats are based on the characters' strength/intelligence and the remaining uses of their weapons and shields.

Winning combats grants extra health and new equipment. Dying implies relying on a resurrection probability to continue playing (turning into a FuzzyPlayer).

Developed as a practical OOP project.
