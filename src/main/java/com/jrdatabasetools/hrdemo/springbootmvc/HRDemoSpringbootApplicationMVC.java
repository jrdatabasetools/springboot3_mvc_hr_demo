/*
 * Copyright (c) Jan Richter, www.jr-database-tools.com, Switzerland, 2015-2024. All rights reserved.
 */

package com.jrdatabasetools.hrdemo.springbootmvc;

import java.lang.invoke.MethodHandles;

import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.vaadin.open.Open;

import oracle.ucp.jdbc.PoolDataSource;
import oracle.ucp.jdbc.PoolDataSourceFactory;

@SpringBootApplication
@Configuration
public class HRDemoSpringbootApplicationMVC {
  private static final Logger logger = LoggerFactory.getLogger(MethodHandles.lookup().lookupClass());

  @Value("${database.url}")
  private String              databaseUrl;

  @Value("${database.username}")
  private String              username;

  @Value("${database.password}")
  private String              password;

  public static void main(String[] args) {
    SpringApplication app = new SpringApplication(HRDemoSpringbootApplicationMVC.class);
    app.run();
    
    Open.open("http://localhost:8080");
  }

  @Bean
  public DataSource getDataSource() throws Exception {
    logger.info("database.url=" + databaseUrl);
    logger.info("database.username=" + username);

    PoolDataSource poolDataSource = PoolDataSourceFactory.getPoolDataSource();
    poolDataSource.setConnectionFactoryClassName("oracle.jdbc.pool.OracleDataSource");
    poolDataSource.setURL(databaseUrl);
    poolDataSource.setUser(username);
    poolDataSource.setPassword(password);
    poolDataSource.setInitialPoolSize(3);
    poolDataSource.setMinPoolSize(3);
    poolDataSource.setMaxPoolSize(3);
    poolDataSource.setLoginTimeout(3);
    poolDataSource.setValidateConnectionOnBorrow(false);

    return poolDataSource;
  }
}