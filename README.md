![WG-EZ-EDIT-IMAGE](WG_EZ_EDIT_HREZ.ico)

# WireGuard_EZ_EDIT
Batch process wireguard CONF files to change DNS and ALLOWED IP lines
___________________________________

Made this simple utility to batch process a folder with CONF files  
Copy code to a ps1 file  / Download ps1 file and execute (admin rights not needed but must have read/write to the folder with your conf files)   
Select the folder containing your CONF files  
DNS = Enter your desired DNS servers - comma separated - you can include 'search domain' here as well - i.e. 1.1.1.1,4.2.2.2,ad.localdomain.local   
Allowed IP= change this from 0.0.0.0/0 to your local subnet(s) - comma separated   
powershell code will create a backup copy in subfolder "Backup" and processed files in subfolder "Processed"  
   
Enjoy!!     
   
Made this after using Ubiquiti / Unifi UDM and having no way to add local search domain or modify the allowed list to tunnel only desired traffic over wireguard vpn.   
No Ubiquitu - I don't want to tunnel ALL traffic (0.0.0.0/0) over the vpn !!!     


