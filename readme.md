# vacovdata: COVID-19 Data for the Commonwealth of Virginia

Provide state-level COVID-19 data for the Commonwealth of Virginia.
This data was originally collected by the Virginia Department of Health and
has been collated and archived by the [COVID Tracking Project](https://covidtracking.com/).

## Installation

This dataset is structured as an R package.  To install or update the package,
from you R console type
```
devtools::install_github('rplzzz/vacovdata')
```

The package contains a single data object, also named vacovdata.  Once the 
package is installed you can access it as `vacovdata::vacovdata`.

## Dataset

Detailed documentation for the dataset is available through the R help system
by typing `help(vacovdata::vacovdata)`.  Briefly, the data contains statewide daily counts
going back to 2020-03-05 of positive and negative COVID-19 test results and 
COVID-19 hospital cases, which are further broken out into ICU and ventilator
cases.
