# StateMachineGenerator
This script converts libero state machine files into state machine diagrams.



# Dependencies
This script can be run on Python 3.7+ and requires the package GraphViz

# Manual
&emsp;-h, --help<br />
&emsp;&emsp;displays this text, then exits.<br />
&emsp;-i, --input-file<br />
&emsp;&emsp;the input libero state machine file to generate. A diagram and a dot file will be generated from the input file.<br />
&emsp;-o, --output-file<br />
&emsp;&emsp;the directory to output the dot and png files.<br />
&emsp;-n, --name<br />
&emsp;&emsp;sets the name for the output dot and png files.<br />
&emsp;-d, --dpi<br />
&emsp;&emsp;sets the dpi parameter for the generated image.<br />

# Example

$ StateMachineGenerator.py --i control.l


## Control.l
```
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
```

## Generated State Machine Diagram
![state_machine_diagram](https://raw.githubusercontent.com/carlin54/StateMachineGenerator/main/examples/control/control.png?token=GHSAT0AAAAAABROB2WOQJ3GRFDZT7Z6MVSAYQIWMNQ)

## Generated Dot 
```dot
digraph finite_state_machine {
  rankdir=LR;
  graph [ dpi = 700 ];
  size="24,24";
  node [shape = circle, label="Integration"] "Integration_State";
  node [shape = circle, label="Available"] "Available_State";
  node [shape = circle, label="After Init"] "After Init_State";
  node [shape = circle, label="Deleted"] "Deleted_State";
  node [shape = circle, label="Checked Out"] "Checked Out_State";
  node [shape = circle, label="Defaults"] "Defaults_State";
  node [shape = box, label="Compile"] "Compile_Event";
  node [shape = box, label="Integrate"] "Integrate_Event";
  node [shape = box, label="Edit"] "Edit_Event";
  node [shape = box, label="Browse"] "Browse_Event";
  node [shape = box, label="Error"] "Error_Event";
  node [shape = box, label="Checkout"] "Checkout_Event";
  node [shape = box, label="Request"] "Request_Event";
  node [shape = box, label="Delete"] "Delete_Event";
  node [shape = box, label="Undelete"] "Undelete_Event";
  node [shape = box, label="Checkin"] "Checkin_Event";
  node [shape = box, label="Ok"] "Ok_Event";
  edge [dir="forward"] "After Init_State" -> "Ok_Event";
  edge [dir="forward"] "Ok_Event" -> "Available_State";
  edge [dir="both"] "After Init_State" -> "Error_Event";
  edge [dir="forward"] "Available_State" -> "Checkout_Event";
  edge [dir="forward"] "Checkout_Event" -> "Checked Out_State";
  edge [dir="forward"] "Available_State" -> "Delete_Event";
  edge [dir="forward"] "Delete_Event" -> "Deleted_State";
  edge [dir="forward"] "Available_State" -> "Integrate_Event";
  edge [dir="forward"] "Integrate_Event" -> "Integration_State";
  edge [dir="forward"] "Checked Out_State" -> "Checkin_Event";
  edge [dir="forward"] "Checkin_Event" -> "Available_State";
  edge [dir="both"] "Checked Out_State" -> "Edit_Event";
  edge [dir="both"] "Checked Out_State" -> "Compile_Event";
  edge [dir="forward"] "Checked Out_State" -> "Delete_Event";
  edge [dir="forward"] "Delete_Event" -> "Deleted_State";
  edge [dir="forward"] "Deleted_State" -> "Undelete_Event";
  edge [dir="forward"] "Undelete_Event" -> "Available_State";
  edge [dir="forward"] "Integration_State" -> "Request_Event";
  edge [dir="forward"] "Request_Event" -> "Available_State";
  edge [dir="both"] "Defaults_State" -> "Browse_Event";
  edge [dir="both"] "Defaults_State" -> "Checkin_Event";
  edge [dir="both"] "Defaults_State" -> "Checkout_Event";
  edge [dir="both"] "Defaults_State" -> "Compile_Event";
  edge [dir="both"] "Defaults_State" -> "Delete_Event";
  edge [dir="both"] "Defaults_State" -> "Edit_Event";
  edge [dir="both"] "Defaults_State" -> "Integrate_Event";
  edge [dir="both"] "Defaults_State" -> "Request_Event";
  edge [dir="both"] "Defaults_State" -> "Undelete_Event";
  labelloc="t";
  label="control State Machine Diagram - Generated on 2022-02-12 22:16:26";
}

```

# Libero
https://github.com/imatix-legacy/libero

# License 

