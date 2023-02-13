### Project scope
Project consists of the following two parts:

+ Data warehouse project for a car rental company.
  + Designing simplified data warehouse based on Kimball's principles (define grain, dimensions, facts etc.). I used Microsoft SQL Server to create data warehouse structure.
  + Creating ETL pipelines to populate data warehouse. ETL process includes: full loading of dimension tables, incremental load of fact tables and SCD2 (*Slowly Changing Dimension 2*) on dim_Store. Source data was extracted from MariaDB database called *wheelie*. I used SSIS to populate data warehouse.
+ Creating dashboards in Tableau which provide answers to the following questions related to the customer analysis:
    + Who are customers of our car rental company i.e where they come from, where they rent cars, how old they are?
    + What type of transactions they perform i.e. type of rented cars, rental duration, age/production year of rented cars?
    + Perform analysis of returning customers (def: **returning customer** - *customer who rented a car more than two times*).
 
### Data warehouse schema

