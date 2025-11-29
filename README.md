

-----

#  Team Visionary - AI Research & Development Platform

A Java Web Application (MVC) designed to facilitate AI research. It features Role-Based Access Control (RBAC) for Administrators and Researchers to manage datasets, resources, projects, and experiments.

-----

# Prerequisites (Software Required)

Before running this project, ensure you have the following installed:

1.  **Java Development Kit (JDK):** Version 17 or 21.
2.  **IntelliJ IDEA:** (Community or Ultimate Edition).
3.  **MySQL Server & MySQL Workbench:** For the database.
4.  **Apache Tomcat 10:** (Must be **Tomcat 10.x** because this project uses Jakarta EE).
      * *Download "Core Zip" from [tomcat.apache.org](https://tomcat.apache.org/download-10.cgi) and extract it.*

-----

## Step 1: Database Setup

1.  Open **MySQL Workbench**.
2.  Create a new SQL Query tab.
3.  Copy and paste the following script to set up the database and tables:

<!-- end list -->

```sql
CREATE DATABASE ai_platform;
USE ai_platform;

-- 1. Users Table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    password VARCHAR(100),
    role ENUM('ADMIN', 'RESEARCHER')
);

-- 2. Resources Table (Admin)
CREATE TABLE resources (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(50),
    capacity VARCHAR(50),
    status VARCHAR(20) DEFAULT 'AVAILABLE'
);

-- 3. Projects Table
CREATE TABLE projects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Project Members (Collaboration)
CREATE TABLE project_members (
    project_id INT,
    user_id INT,
    FOREIGN KEY (project_id) REFERENCES projects(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- 5. Datasets Table (Researcher)
CREATE TABLE datasets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    description TEXT,
    file_name VARCHAR(255),
    researcher_id INT,
    FOREIGN KEY (researcher_id) REFERENCES users(id)
);

-- 6. Experiments Table (Training)
CREATE TABLE experiments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    researcher_id INT,
    model_name VARCHAR(100),
    parameters TEXT,
    status VARCHAR(50) DEFAULT 'Training...',
    accuracy VARCHAR(20) DEFAULT '--',
    start_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (researcher_id) REFERENCES users(id)
);

-- 7. Usage Logs (Mock Data for Admin Chart)
CREATE TABLE usage_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    resource_type VARCHAR(50),
    usage_value INT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- SEED DATA (Default Admin)
INSERT INTO users (name, email, password, role) VALUES 
('System Admin', 'admin@ai.com', 'admin123', 'ADMIN');

-- MOCK USAGE DATA
INSERT INTO usage_logs (resource_type, usage_value) VALUES 
('GPU-Cluster-1', 45), ('Storage-SAN', 80), ('GPU-Cluster-2', 12);
```

4.  Click the **Lightning Bolt Icon** ⚡ to run the script.

-----

## Step 2: Project Setup in IntelliJ

1.  **Open Project:** Open the `AIResearchPlatform` folder in IntelliJ.
2.  **Load Maven Dependencies:**
      * Open the `pom.xml` file.
      * Look for a floating **"M" icon** (Maven) in the top-right corner of the editor window and click it.
      * *This downloads the MySQL Connector and Servlet libraries.*
3.  **Create Uploads Folder:**
      * Navigate to `src` \> `main` \> `webapp`.
      * Right-click `webapp` \> **New** \> **Directory**.
      * Name it: `uploads`.
      * *This is where researcher files will be saved.*

-----

##  Step 3: Connect Code to Database

1.  Navigate to `src/main/java/com/aiplatform/utils/DBConnection.java`.
2.  Find the line:
    ```java
    private static final String PASSWORD = "password"; 
    ```
3.  Change `"password"` to your actual **MySQL Root Password**.
4.  Save the file.

-----

##  Step 4: Run Configuration (Smart Tomcat)

Since you are using IntelliJ Community Edition, use the **Smart Tomcat** plugin.

1.  **Install Plugin:** Go to **File \> Settings \> Plugins**. Search for "Smart Tomcat" and install it. Restart IntelliJ.
2.  **Add Configuration:**
      * Click "Add Configuration" (Top Right) \> **+** \> **Smart Tomcat**.
      * **Name:** `TeamVisionary`.
      * **Tomcat Server:** Click the folder icon and select your **unzipped Tomcat 10 folder**.
      * **Deployment Directory:** Click folder icon \> select `src/main/webapp`.
      * **Context Path:** Type `/ai`.
      * **Server Port:** `8080`.
3.  Click **Apply** and **OK**.

-----

##  Step 5: How to Run

1.  Click the **Green Play Button** ▶️ in the top right corner.
2.  Wait for the console to verify startup: `Server startup in [xxxx] ms`.
3.  Open your browser and go to:
     **http://localhost:8080/ai/login.jsp**

-----

##  Login Credentials

###  Admin Portal

  * **Email:** `admin@ai.com`
  * **Password:** `admin123`
  * *Features: Manage users, add hardware resources, view analytics.*

###  Researcher Portal

  * **Email:** `smith@ai.com`
  * **Password:** `1234`
  * *Features: Upload datasets, train models (simulation), track experiments, collaborate.*

-----

## 📂 Project Structure (MVC)

  * **`com.aiplatform.model`**: Defines what a "User" is.
  * **`com.aiplatform.dao`**: (Data Access Object) Handles all SQL database operations.
  * **`com.aiplatform.controller`**: (Servlets) Handles form submissions and logic.
  * **`src/main/webapp`**: Contains the Frontend (JSP files, CSS, Bootstrap).

-----

*© 2025 Team Visionary.* 
Mohammad Junaid 24SCSE1180508
Aditya Singh 24SCSE1180631
