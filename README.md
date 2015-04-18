# SimplePageViewController
Alternative to iOS UIPageViewController component.

Offers similar functionalities as the UIPageViewController class, with the difference 
that it will continue interrogating the data source after consuming all the data (the data source returns a nil controller), contrary to UIPageViewController 
which will stop once the datasource reaches the end. This design is well suited for fixed size data sources, 
but not well for varying size networks resources. It is possible some way to reset the datasource with 
UIPageViewController, but this is hacky, and unecessary boiling plate code.

A second difference is that there is no need to pre-feed the page view controller with a first view controller. 
Instead, the controller will start feeding from the datasource when it's view gets loaded. This makes a cleaner 
design, relieving the parent view to know about the page view controller details.

It is a simple design, with at most 3 instanciated children view controllers, left (or none if first page), visible,
right (or none if last page). 
