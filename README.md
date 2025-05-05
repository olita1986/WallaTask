This is a project that shows a list of super heroes using the Marvel API. 

If you select a hero on the list you could see some extra details like the Comics where it has appared on.

## Architectures

<img width="947" alt="image" src="https://github.com/user-attachments/assets/51d2442e-da3a-4c6a-804f-722b135dff88" />

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

- For the persistency layer, UserDefaults was used for practicity, however on a bigger project a framework like CoreData or Realm should be considered.
- Snapshot testing could be nice to have to have a robust UI design
- Use of SwiftUI, however, for a smooth transition to it, an architecture change to MVVM should be considered.

## API

The API used for Marvel Heroes: http://developer.marvel.com/

## App Features
- Pagination And Try again in case of error
- Dynamic Search
- Pull to refresh
- Persistency 

## Demo

### Pagination

![Pagination](https://github.com/user-attachments/assets/9f44e4f7-cd69-4209-bd09-7c9ec62593e1)

### Heroe Search

![Search](https://github.com/user-attachments/assets/de95bc75-161d-4079-a86a-1330d21fd301)

### Detail View (Not the most beatiful one 😂)

![Detail](https://github.com/user-attachments/assets/8826541e-748a-4f26-b303-d7ff3c301f1e)

### Persistency

![Persistency](https://github.com/user-attachments/assets/5ab8454f-895a-462e-8151-4b752e932674)



 
