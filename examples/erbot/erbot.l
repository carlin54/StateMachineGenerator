!
!   erbot.l	Dialog for erbot the Email Robot.  Implements various
!		NYAIS (not yet an internet standard) protocols:
!
!		RCEP	Remote Command Entry Protocol
!		EMFTP	E-Mail File Transfer Protocol
!		EMRP	E-Mail Routine Protocol
!
!   Written:	96/01/19  Pieter Hintjens
!   Revised:	96/02/01
!
!   Copyright (c) 1996 Pieter Hintjens, may be freely distributed.
!

-source=erbot.awk
-schema=lrschema.awk

After-Init:
    (--) Ok				    -> Have-Routing
	  + Parse-Config-File
	  + Parse-And-Save-Message
	  + Check-If-Routing-Wanted
    (--) Error				    ->
	  + Terminate-The-Program

Have-Routing:
    (--) Ok				    -> Have-Address
	  + Get-First-Routing-Address
    (--) None				    -> Have-Protocol
	  + Check-Protocol-Type

Have-Address:
    (--) External			    -> Have-Address
	  + Route-Message-To-Recipient
	  + Get-Next-Routing-Address
    (--) Internal			    -> Have-Int-Protocol
	  + Check-Protocol-Is-Consistent
	  + Check-Protocol-Type
    (--) Maillist			    -> Have-Address
	  + Parse-Maillist-File
	  + Get-Next-Routing-Address
    (--) Finished			    ->
	  + Terminate-The-Program

Have-Protocol:
    (--) Rcep				    -> Have-Rcep-Command
	  + Log-Rcep-Command
	  + Build-Rcep-Response-Header
	  + Check-Rcep-Password
	  + Check-Rcep-Command-Type
	  + Dialog-Call
    (--) Emftp				    -> Have-Emftp-Command
	  + Log-Emftp-Command
	  + Build-Emftp-Response-Header
	  + Check-Emftp-Command-Type
	  + Dialog-Call
    (--) Return 			    ->
	  + Terminate-The-Program
    (--) Other				    ->
	  + Terminate-The-Program

Have-Int-Protocol: <Have-Protocol>
    (--) Return 			    -> Have-Address
	  + Get-Next-Routing-Address
    (--) Other				    ->
	  + Reply-Unknown-Internal-Protocol
	  + Terminate-The-Program

Have-Rcep-Command:
    (--) Run				    ->
	  + Rcep-Run-Commands
	  + Dialog-Return
    (--) Clone				    ->
	  + Rcep-Clone-Server
	  + Dialog-Return
    (--) Put				    ->
	  + Rcep-Upload-File
	  + Dialog-Return
    (--) Get				    ->
	  + Rcep-Download-File
	  + Dialog-Return
    (--) Version			    ->
	  + Rcep-Send-Version
	  + Dialog-Return
    (--) Empty				    ->
	  + Rcep-Run-Commands
	  + Dialog-Return

Have-Emftp-Command:
    (--) Get				    ->
	  + Emftp-Download-Files
	  + Dialog-Return

Defaults:
    (--) Message			    ->
	  + Log-Fatal-Error
	  + Terminate-The-Program
    (--) Exception			    ->
	  + Terminate-The-Program
