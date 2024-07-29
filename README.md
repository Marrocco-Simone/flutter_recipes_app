# Device-Agnostic Design Course Project II - 8078393e-b90c-49e3-b7cf-0a27a3583e42

## Name of the application:

**Yummy Recipes!**

## Brief description of the application

This **Yummy Recipes!** app was created as the second project of the _Device Agnostic Design_ course of the _Aalto University_. It follows all the requirements for passing with merits.

### Features

- Header and Footer in all pages, with a search bar and links to your account, the main page and to see all categories
- Discover in the main page the recipe most favourited, see the top categories and explore all of them
- See al the steps and ingredients for a recipe in its own page
- Look at all the categories and their recipes, with an easy to use menu (even on mobile)
- Log in to favourite recipes and create your own
- Everything grouped together nicely, following the User Experience Laws

### For devs

- Different providers for different usages: even if some access the same collection, everything needs different things
- Three breakpoints for desktop, tablet and mobile: try them!
- Smooth scrolling and pagination in the recipe category page: try it with the category "Test Pagination", and look at the logs by pressing F12

## Key challenges faced during the project

- Firebase is a barebone database, without schema populate, partial string matching or native pagination, which I needed to create all by myself
- Refreshing a page automatically in Flutter simply does not exist

## Key learning moments from working on the project

- Nesting multiple Flex, being careful of SizedBox
- Provider arguments using a provider family
- Dialogs and Forms validation
-

## Database formation

The application uses three collections. All three of them have a corresponding schema in the folder lib/models.

- the Category schema has a name ("_name_") and the number of recipes ("_nRecipes_")
- the Recipe schema has a name ("_name_"), the number of time it has been flagged as favourite ("_nFavourites_"), the list of steps ("_steps_", list of String) and ingredients ("_ingredients_", list of String), the author id ("_author_") and the category id ("_category_")
- the AuthUser schema has a name ("_name_"), the uuid of access as anonymus user ("_uuid_") and the list of favourite recipes ids ("_favouritesRecipes_", list of String)

## List of dependencies and their versions

- sdk: ">=3.4.1 <4.0.0"
- cupertino_icons: ^1.0.6
- firebase_core: ^3.0.0
- flutter_riverpod: ^2.5.1
- cloud_firestore: ^5.0.0
- firebase_auth: ^5.0.0
- go_router: ^14.1.4
