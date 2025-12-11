# MongoDB Atlas Administrator Path

## 1. Install mongosh:
Installing Atlas CLI may also install `mongosh`, so this step might be unnecessary. <br>
Adding the following yum repo might still be useful if you have intension to install **MongoDB Community Server**.<br> 

Create a `/etc/yum.repos.d/mongodb-org-8.2.repo` file with contents as:
```ini
[mongodb-org-8.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/8/mongodb-org/8.2/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-8.0.asc
```
Then install the latest stable version of `mongosh` as:
```
sudo yum install -y mongodb-mongosh
mongosh --version
```

## 2. Getting Started with Atlas CLI
Atlas CLI is a cli tool to interface with MongoDB Atlas; while `mongosh` is used for interacting with MongoDB Database.
### 1. Install Atlas CLI in linux (Fedora in my case):
```
dnf install mongodb-atlas -y
atlas --version
```
### 2. To authenticate Atlas CLI with MongoDB Atlas account
```
atlas auth login
```
A one-time verification code is generated that can be pasted in the browser prompt to authenticate our account with the CLI. <br>

A default profile is created after authentication, which can be read using:
```
atlas config describe default
```

### 3. Create a Local environment for SDLC
1. To create a local development environment, we need to ensure Podman/Docker is up and running.
    ```
    systemctl status podman.socket
    podman --version
    ```
    Then deploy a new local deployment, **Dev**. We can initialize and populate the database with script inside `my-films-app/initdb-dev/loadFilms.js`.
    ```
    atlas deployments setup Dev --initdb my-films-app/initdb-dev
    ```
    **Note:** In my case, there was a bug that led to inability to parse my local timezone UTC+05:45 so I had to run:
    ```
    TZ=UTC atlas deployments setup Dev --initdb my-films-app/initdb-dev
    ```
2.  Choose local (Local Database) option and choose the default configuration. Now connect to the deployment with mongosh (MongoDB Shell). <br> Inside the mongosh, run: 
    ```
    show dbs
    ```
    And we will see our local database, my-films-db. Run the following command to choose that database:
    ```
    use my-films-db
    ```
    Now we can read all the inserted documents:
    ```
    db.films.find()
    ```
3. To run additional scripts after the deployment, run this inside mongosh:
    ```
    load ("<script_name>")
    ```
4. To exit mogosh, run:
    ```
    quit
    ```
### 4. Create a Cloud cluster using AWS/Azure/GCP for Testing
We will create a M0 cluster (free tiered) with AWS as Cloud Provider.
```
atlas deployments setup Test --type ATLAS --provider AWS --region AP-SOUTH-1 --mdbVersion 8.0 --tier M0 --skipSampleData
```
This creates a M0 cluster in Mumabi region of AWS with MongoDB version 8.0 with no sample data preloaded. Remember the Username and Password and keep it safe.<br>
We can list all the deployments (local and cloud) using:
```
atlas deployments list
```
To connect to a deployment, run:
```
atlas deployment connect Test
```
You will be prompted to enter the Username and Password to create a connection.

### 5. Create a custom profile for automation 
We can generate a custom profile with a scoped RBAC (Role Based Access Control) with `APIKeys` as mode of authentication (since `UserAccount` authenticated session with one-time verification code expires in 12 hours). <br>
So, lets generate a set of public/private API Keys with `GROUP_OWNER` role, for the custom profile (for example, automation):
```
atlas projects apiKeys create --role GROUP_OWNER --desc "API Key for automation"
```
Copy the public and private keys and run:
```
atlas config init --profile automation
```
Select `APIKeys` as authentication type and paste the keys when prompted. <br>

**NOTE:** Since my home WiFi network is behind a ISP's CGNAT (Carrier Grade NAT), my public IP address may change dynamically.<br>
So disable `Require IP Access List for the Atlas Administration API` toggle on Organizations Setting in [MongoDB Cloud](https://cloud.mongodb.com/) to prevent any security issues when setting up the profile, like unable to identify Organizations and Projects under the user account.

## 3. Security
