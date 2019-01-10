This app is an Universal app which will enable users to search countries based on country name and find some details of countries.
When a user taps any character in the search box and click on Search button in the keyboard. Then, the list of records will be displayed based on the character(s) entered. If the user will tap any character other than alphabets, then no records will be displayed.

The first page of the application is a TableviewController class which contains Search bar on the top. The images in the records are coming in SVG format which is rendered by using SVGKit framework.
If a user clicks on any country, then the detail page will be opened which contains details of the selected country. There is a save button in the detail page, which allows user to save data locally. If the data already persist in the database, then duplicate record will not be saved and it will be prompted to the user.
If the device is not connected to the internet, then the saved records will be shown to the user and user will further search from these records.
