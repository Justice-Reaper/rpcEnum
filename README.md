# RpcEnum
This Bash script enables convenient scanning of the MSRPC service

# Features
- Enumerate domain users
- Enumerate user information from the deployment
- Enumerate user description, full name, and alias
- Enumerate groups
- Enumerate groups and their respective users
- Enumerate printers
- Enumerate SMB shared resources
- Enumerate password policy
- Enumerate server information
- Generate a comprehensive report with all the above functions

# Usage
```
git clone https://github.com/Justice-Reaper/rpcEnum.git
cd rpcEnum
chmod +x rpcEnum.sh
./rpcEnum.sh
```

# Help Panel
If the script is used incorrectly, a warning will appear, and the help panel will be displayed

![](/images/image_1.png)

# User Enumeration
Using the -u (username) and -p (password) parameters to provide credentials

![](/images/image_2.png)

Enumerate without credentials, i.e., with the anonymous user

![](/images/image_3.png)

Another alternative is to leave the -u (username) and -p (password) fields empty

![](/images/image_4.png)

Enumerate user information in the deployment

![](/images/image_5.png)

Enumerate all possible user information

![](/images/image_6.png)

# Group Enumeration
Enumerate groups and their descriptions

![](/images/image_7.png)

Enumerate groups and the users belonging to each

![](/images/image_8.png)

# Printer Enumeration
Enumerate printers

![](/images/image_9.png)

# SMB Enumeration
Enumerate SMB shared resources

![](/images/image_10.png)

# Password Policy Enumeration
Enumerate the password policy

![](/images/image_11.png)

# Server Enumeration
Enumerate server information

![](/images/image_12.png)

## Credits
Author: Justice-Reaper  

Inspiration: Tool based on the one created by Zunder > [https://github.com/rubenza02/rpcenumeration.git](https://github.com/rubenza02/rpcenumeration.git)  

YouTube: Link to Zunder’s video explaining the tool’s utility > [https://youtu.be/gC6l4YA3Ue4?si=MFjejjpeVxMlbhjg](https://youtu.be/gC6l4YA3Ue4?si=MFjejjpeVxMlbhjg)
