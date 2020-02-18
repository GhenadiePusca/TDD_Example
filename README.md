# TDD_Example

This repo is meant to exemplify how to integrate the Test Driven Development into the workflow in order to maximize the utility of unit tests.

We'll implement an iOS application that is complicated enough to demonstrate the real usage of TDD, and which will allow developers to corellate the conding examples with daily workflow.

The main requirement is to develop an iOS app that will show the user a list of posts consisting of an image and a description.

What will be achieved by this example:
- Demonstrate that it is useful and possible to test the content of UIViewController without UITests or Snapshot Tests.
- Exemplify how we can implement an app screen with full functionality without runing the app(on device or simulator), but instead we will run only tests.
- Exemplify how TDD helps moving with small steps toward a stable and easy to control system.
- Demonstrate that unit tests help with defining the architecture.
- Exemplify how we can inspect the view controller content and trigger differnt actions on it.

App use cases to be implemented:
Posts list use cases:
   - Posts are loaded as soon the screen is visible.
   - While posts are loading a loading indicator is shown.
   - If load failed, an error banner is shown
   - User can manually reload the posts list.

Post image use case:
   - Image is loaded once a post is visible.
   - While image is loading - a loading indicator is shown.
   - If image load failed, a retry button is shown.
   - User is able to retry the image loading.

What is done so far(you can follow the granular commit messages to get up to date with whole reasoning):

Session nr 1:

     - Established the setup and main guiding principles.
     - Tested that the PostsViewController correctly triggers load requests when view becomes visible and on user manual reload.
        
Session nr 2:

     - Stepped up the mase by making use of the established guiding principles.
     - Tested the loading indicator functionality behaves correctly - shown when loading is triggered and hidden on load completion be it success or fail.
     - Tested that the current number of posts is shown and that the posts description is correctly shown.
     - Exemplified how we can test the table view content.
        
Next session:

    - Extract production code from the mock class.
    - Move the components from the test target to production target.
    - Defining the components access modifiers, hints of modularity.
    - Start image loading implementation: determine how the image is loaded by following the Single Responsibility and Interface Segregation Principle, implement the image loading, loaded and error states.
    - We'll see how slowly the PostsViewController transforms into a massive view controller with multiple responsibilities.
    - We'll start implementing the posts loading error state.

