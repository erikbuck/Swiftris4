# Swiftris4
A Tetris like game that demonstrates the virtues of Model View Controller with Swift 4

## Model
The **Model** consists of the data representation of the game a.k.a. "game state" and the "business logic" for the game. The Model works with multiple different Views and with no View. The Model has no dependencies on any other part of the project. For this example, the Model is created using Apple's Core Data framework and the visual Entity Relationship diagramming tool that's integrated with Xcode. It might seem odd to use Core Data, an "object database", for a game, but it actually works well.

## View
The key to understanding **View** subsystems is that there are often multiple Views of the same Model. Consider a program like Microsoft Powerpoint. The Model in Powerpoint is the content and formatting of slides, but the same content can be viewed as a text outline, in a "slide sorter" view, in a presentation view, etc. The way the Model is viewed has no effect on the Model. Viewing the slides in slide sorter view vs. presentation view does not change the content of the Model. This project includes several example Views including a 2D View using Quartz and UIKit, a 2D View using SpriteKit, and a 3D View using SceneKit. All Views share share the exact same Model implementation. Models have no dependencies on Views, and Views have no (or at least minimal) dependencies on any particular Model implementation.

*Note: It's also common to use a single View subsystem with multiple Models. A Web browser is an example. The same Web browser works with the Model stored in a database at Amazon.com and with the Model stored in Wikipedia's database.*

## Controller
There are two roles of the **Controller** subsystem. 1) Create or load the Model and View subsystems. 2) "Glue" the Model and View subsystems together in ways that avoid dependencies or coupling between the Model, View, and Controller subsystems. IN the context of the Web, Web Servers are the "Controller" subsystem in the sense that Web servers provide a standard interface, HyperText Markup Language (HTML), to Views a.k.a Web browsers. Most Web servers also provide standard interfaces to Models a.k.a databases and "business logic". 
