# Store App Sideloader
#### Sideload any Microsoft Store app with minimal setup!
## Using the program:
### 1: Open `Run.bat`
### 2: Wait...
### 3: It should be done!
## Cheese Terminator: Reloaded
<img src="https://user-images.githubusercontent.com/51035517/231385694-3eed24b5-06d2-47fc-a2ed-7390332d3707.png" width="1024">

#### This is a game you previously couldn't get without this program!
#### Behold, the remake of Cheese Terminator, completley un-downloadabe from the MS store.

## Making an installer:
### 1: Gather all of your Appx, MSIX, or otherwise files into an [archive type supported by 7-zip](https://7-zip.org).
### 2: Understand how the program works. This is important so you know how to edit the variables.
###### 2.1: First, the program extracts all of $fileArray from $zipName
###### 2.2: Then, it installs all of the extracted files
###### 2.3: Afterwards, it moves `Program Files/WindowsApps/$fromPath` to `Appdata/Local/WindowsApps/$toPath`
###### 2.4: Finally, it registers the application at `Appdata/Local/WindowsApps/$toPath`
### 3: Edit `sideLoad.ps1`, all lines in the image below are safe to edit.

<img src="https://user-images.githubusercontent.com/51035517/231390975-aadae227-7d7c-4e99-9db9-cda942910641.png" width="512">

## But where can I get Appx files?
### You can get the application and it's dependencies from [here](https://store.rg-adguard.net).
### You can get the URLs that you need from the [Microsoft Store](https://apps.microsoft.com/store/apps).
###### PS: You don't need any .BlockMap files.
