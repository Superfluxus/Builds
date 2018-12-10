# Builds
Internal Powershell module I wrote to install customer specific RMM and AV agents alongside Misc 3rd party software when configuring new machines for clients


This module is something I wrote to help our internal build engineers configure machines for customers. The RMM agent in question we used was Labtech Automate and the AV in question was Sophos. YMMV when trying others. This also relies on a corresponding file share with the path "COMPANYDIRECTORY-build-hv\companydirectory\buildsmodule\$CustomerName\" to pull the relevant .msi's and software from. Tested and working in production before being sanitized, more food for thought than a copy/paste job. Took a manual 40 minute job of manually installing the customer specific RMM/AV product alongside 5+ bespoke 3rd party apps into a <5 minute task of asking for a Read-Host prompt customer name, installing the RMM/AV, then displaying the contents of the customer's folder, which Read-Host arguments can be passed to a & /qn command.

SpecialCustomer1 and 2 are customers that have their own network port in our internal configuration room, all others have a passive VPN connection that we can use to remotely domain join with the right FQDN and DNS address in the IPv4 adapter config.
