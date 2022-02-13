!
! Dialog description CLI101D.L
! Written: 92/11/27   Pieter Hintjens
! Revised: 92/11/27
!
/source=cli101.c

After-Init:
    (--) Ok                                 -> Have-Input
          + Connect-To-Parent-Host
          + Clear-Parent-Connect-Timeout
          + Wait-For-Parent-Message
    (--) Error                              ->
          + Terminate-The-Program

Have-Input:
    (--) From-Parent                        -> Parent-Message
          + Decode-Message-From-Parent
    (--) Timeout                            -> Have-Input
          + Check-If-Time-To-Logon-Parent
          + Wait-For-Parent-Message
    (--) Time-To-Logon                      -> Have-Input
          + Connect-To-Parent-Host
          + Wait-For-Parent-Message

Parent-Message:
    (--) Ok                                 -> Have-Input
          + Display-Message
          + Wait-For-Parent-Message
    (--) Disconnect                         -> Have-Input
          + Disconnect-From-Parent-Host
          + Set-Parent-Connect-Timeout
          + Wait-For-Parent-Message

Defaults:
    (--) Soft-Error                         -> Have-Input
          + Wait-For-Parent-Message
    (--) Error                              ->
          + Disconnect-From-Parent-Host
          + Signal-Fatal-Error-Abort
          + Terminate-The-Program
    (--) Parent-Error                       -> Have-Input
          + Disconnect-From-Parent-Host
          + Set-Parent-Connect-Timeout
          + Wait-For-Parent-Message
