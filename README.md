# PL/SQL Connector Builder Example - Spring Boot MVC Demo

## Prerequisites

Install PL/SQL Connector Builder Maven Plugin from : https://www.jr-database-tools.com/download

### Installed Software

- Java 17
- Docker 
- Maven 3.x

### Oracle Database XE 21c

- **Windows** : Run **run_oracle.cmd** from the command line of the project root to start a preconfigured database (git-bash will not work).
- **Linux/OSX** : Run **run_oracle.sh** from the command line of the project root to start 
- An Oracle 21c XE (Express Edition) will be downloaded as Docker image.
- All Sql scripts in the folder **ora_db_startup** will be executed after startup.
- About 5 GB will be downloaded and require about 12 GB in the docker registry.

### Oracle Connection Info

- The default password for the administration users SYS, SYSTEM and PDBADMIN are set to 'oracle'.
- A preconfigured schema 'HR' identified by password 'hr' is created during setup.
- Url to the schema 'HR' is 'jdbc:oracle:thin:@localhost:1521/xepdb1'


## Master-Detail Demonstration
This is a Master-Detail Demonstration written in Spring Boot MVC using the Oracle HR Demo Schema.

1. The Master-View works as a search dialog for employees.
2. The Detail-View allows editing or deleting of employees.

## Getting Started

- Startup the Oracle DB.
- Run **mvn** from the command line : Runs the PL/SQL Connector Builder, compiles the Spring-Boot-Application and starts the Spring-Boot-Application using the Oracle DB.
- Should also startup a browser with this URL **http://localhost:8080**.
