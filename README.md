This is a project that shows a list of super heroes using the Marvel API. 

If you select a hero on the list you could see some extra details like the Comics where it has appared on.

## Architectures

<img width="956" alt="image" src="https://github.com/user-attachments/assets/787d20e3-4703-47e8-9072-fd9bd79c23a1" />

This project uses MVP-C architecture to keep the same architecture as the base project. 

A Coordinator layer was introduce to handle navigation and remove that responsibility from the view.

It was also introduced a Handler layer to also remove some heavy work from the Presenter, that normally increases in size as the requirements grow. 

## Patterns 

This projects uses the following Patterns:

- Depedency Injection: together with the Protocol Oriented Programming (POP) we can abstract the class and remove ant strong depedencies to any specific implementation
- Factory pattern: it use in this case is to simply facilitates the creation of models
- Delegate Pattern: it's used, for example, to send actions from Presenter to View (i.e. ui?.update(...))
- Coordinator Pattern: coordinator is a layer that handles the creation of view controllers, and it pushes/presents them. It also takes chages of passing data between views.
- Singleton Pattern: often considered and anti pattern, but well used can help to keep just one instance of a speficic class, in this case the ApiClient.

## Unit Tests and UI Tests

This projects adds unit tests for the critical business logic:
- On the ListHeroesPresenter and ListHeroesHandler

The UI Test was setup using a OHHTTPStubs library to mock network calls and avoid any reliance on real ones.

It was tested the happy path and some error cases:
- Load of heroes
- Error when loading heroes
- Load of heroes and navigation to detail view

## Use and installation 

This Project was built using CocoaPods as Dependency Manager. Therefore, Cocoapods is needed:

Run: `pod install`

The open the .xcworkspace generated.

## Consideration and Nice-To-Have

- A persistency mechanism would be nice to have for moments that there is no connection
- A dinamic search would be nice to have to search for specific heroes that matches our query against the API
- Snapshot testing could be nice to have to have a robust UI design
- Use of SwiftUI, howeverm, for a smooth transition to it, a architecture change to MVVM shall be considered.

## API

The API used for Marvel Heroes: http://developer.marvel.com/
 
