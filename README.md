### Project scope
Project consists of the following two parts:
+ Data warehouse project for a car rental company.
  + <p align="justify"> Designing simplified data warehouse based on Kimball's principles (define grain, dimensions, facts etc.). I used Microsoft SQL Server to create data warehouse structure. </p>
  + <p align="justify"> Creating ETL pipelines to populate data warehouse. ETL process includes: full loading of dimension tables, incremental load of fact tables and SCD2 (<i>Slowly Changing Dimension 2</i>) on dim_Store. Source data was extracted from MariaDB database called <i>wheelie</i>. I used SSIS to populate data warehouse. </p>
+ Creating dashboards in Tableau which provide answers to the following questions (related to the customer analysis):
    + <p align="justify"> Who are customers of our car rental company i.e where they come from, where they rent cars, how old they are?</p>
    + <p align="justify"> What type of transactions they perform i.e. type of rented cars, rental duration, age/production year of rented cars?</p>
    + <p align="justify"> Performing analysis of returning customers (def: <b>returning customer</b> - <i>customer who rented a car more than two times</i>).</p>

### Data warehouse schema

Entity relationships diagram of the source database (*wheelie* database) is shown below. 

<p align="center">
    <img src="DWH/JPG/wheelie_source_db.png">
</p>

### Tableau dashboards

Below there is a preview of dashboards in Tableau. Tableau files (*.twb, *.hyper) can be found in the repository. All dashboards are fully interactive.

1. Customer analysis - map with customer countries and rental store locations. 

<p align="center">
    <img src="Tableau/Map.JPG">
</p>

2. Customer analysis - charts for rental stores. Bar chart include "drill down" option to show the hierarchy: rental store country / rental store city > customer country. Percentage for each store country/store city is counted with the aid of LOD (*Level of Detail Expression*).

![This is an image](Tableau/Rental-stores.JPG)

3.Customer analysis - charts for car types. Bar chart include "drill down" option to show the hierarchy: rental store country / car producer > car model. Percentage for each store country/car producer is counted with the aid of LOD (*Level of Detail Expression*).

![This is an image](Tableau/Car-types.JPG)
