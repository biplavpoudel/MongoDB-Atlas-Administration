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
1. Install Atlas CLI in linux (Fedora in my case) using:
```
dnf install mongodb-atlas -y
atlas --version
```
2. To authenticate Atlas CLI with MongoDB Atlas account:
```
atlas auth login
```
A one-time verification code is generated that can be pasted in the browser prompt to authenticate our account with the CLI.

3. A default profile is created after authentication, which can be read using:
```
atlas config describe default
```
4. We can generate a custom profile with RBAC (Role Based Access Control) with `APIKeys` as mode of authentication (since `UserAccount` authentication with one-time verification code expires in 10 hours). <br>
First lets generate a set of public/private API Keys which can be added to our custom profile (for example, automation):
```
atlas projects apiKeys create --role GROUP_OWNER --desc "API Key for automation"
```
Copy the public and private keys and run:
```
atlas config init --profile automation
```
Select `APIKeys` as authentication type and paste the keys when prompted. <br>

Since my home WiFi network is behind a ISP's CGNAT (Carrier Grade NAT), my public IP address may change dynamically.<br>
So disable `Require IP Access List for the Atlas Administration API` toggle on Organizations Setting in [MongoDB Cloud](https://cloud.mongodb.com/) to prevent any security issues when setting up the profile, like unable to identify Organizations and Projects under the user account.