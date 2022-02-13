!
!   Test of LRSCHAST.C
!
-schema=lrschast.c -source=testast
-style=caps

After-Init:
    (--) Ok                                 -> Have-Message
          + Open-Terminal-Channel
          + Write-Message-To-Channel
          + Check-Io-Status-Block
          + Read-Message-from-Channel
          + Check-Io-Status-Block
          + Check-Message-Contents
    (--) Error                              ->
          + Terminate-The-Thread

Have-Message:
    (--) Again                              -> Have-Message
          + Write-Message-To-Channel
          + Check-Io-Status-Block
          + Read-Message-from-Channel
          + Check-Io-Status-Block
          + Check-Message-Contents
    (--) Exit                               ->
          + Close-Terminal-Channel
          + Terminate-The-Thread

Defaults:
    (--) Io-Error                           ->
          + Close-Terminal-Channel
          + Terminate-The-Thread
