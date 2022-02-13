!
!   control.l   Dialog description for the monitor script
!
!   Written:    95/10/22  Pieter Hintjens
!   Revised:    95/10/22
!
-schema=lrschema.ksh

After-Init:
    (--) Ok                                 -> Available
          + Define-New-Program
          + Trigger-The-Same-Event
    (--) Error                              ->
          + Signal-Invalid-Operation
          + Terminate-The-Program

!   In this state a program is in development.  A developer can check-out
!   the program in advance of making changes.  The program is then locked.
!
Available:
    (--) Checkout                           -> Checked-Out
          + Lock-The-Program
    (--) Delete                             -> Deleted
          + Delete-The-Program
    (--) Integrate                          -> Integration
          +

!   In this state a program is checked-out by a developer.  Any other
!   developer can only browse the program, not modify it.
!
Checked-Out:
    (--) Checkin                            -> Available
          + Unlock-The-Program
    (--) Edit                               -> Checked-Out
          + Edit-The-Program
    (--) Compile                            -> Checked-Out
          + Compile-The-Program
    (--) Delete                             -> Deleted
          + Unlock-The-Program
          + Delete-The-Program

Deleted:
    (--) Undelete                           -> Available
          + Undelete-The-Program

!   The program is 'frozen' while being tested.  If a change request
!   comes along, the program is moved back into development so that
!   changes can be made.
!
Integration:
    (--) Request                            -> Available
          +

!   Browse is always permitted; we stay in the same state.
!   Any other action (not accepted in the current state) is rejected.
!
Defaults:
    (--) Browse                             ->
          + Browse-The-Program
    (--) Checkin                            ->
          + Reject-Operation
    (--) Checkout                           ->
          + Reject-Operation
    (--) Compile                            ->
          + Reject-Operation
    (--) Delete                             ->
          + Reject-Operation
    (--) Edit                               ->
          + Reject-Operation
    (--) Integrate                          ->
          + Reject-Operation
    (--) Request                            ->
          + Reject-Operation
    (--) Undelete                           ->
          + Reject-Operation
