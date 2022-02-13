!
!   C/C++ comment stripper dialog
!
!   Written:    95/03/30  Pieter Hintjens <ph@imatix.com>
!   Revised:    96/05/15  Frans Janssens <frans@sebb.bel.alcatel.be>
!
-source=stripper.c
-schema=lrschema.c

After-Init:
    (--) Ok                         -> Outside-Comment
          + Get-Char-From-Input
    (--) Error                      ->
          + Terminate-The-Program

Outside-Comment:
    (--) Quote                      -> Skip-Quote
          + Put-Char-To-Output
          + Get-Char-From-Input
    (--) Slash                      -> After-Slash
          + Get-Char-From-Input
    (--) Star                       -> Outside-Comment
          + Put-Char-To-Output
          + Get-Char-From-Input
    (--) NewLine                    -> Outside-Comment
          + Put-Char-To-Output
          + Get-Char-From-Input
    (--) Other                      -> Outside-Comment
          + Put-Char-To-Output
          + Get-Char-From-Input

Skip-Quote:
    (--) Quote                      -> Outside-Comment
          + Put-Char-To-Output
          + Get-Char-From-Input
    (--) Slash                      -> Skip-Quote
          + Put-Char-To-Output
          + Get-Char-From-Input
    (--) Star                       -> Skip-Quote
          + Put-Char-To-Output
          + Get-Char-From-Input
    (--) NewLine                    -> Skip-Quote
          + Put-Char-To-Output
          + Get-Char-From-Input
    (--) Other                      -> Skip-Quote
          + Put-Char-To-Output
          + Get-Char-From-Input

After-Slash:
    (--) Quote                      -> Outside-Comment
          + Put-Slash-To-Output
          + Put-Char-To-Output
          + Get-Char-From-Input
    (--) Slash                      -> Skip-Eoln
          + Get-Char-From-Input
    (--) Star                       -> Skip-Comment
          + Start-New-Comment
          + Get-Char-From-Input
    (--) NewLine                    -> Outside-Comment
          + Put-Slash-To-Output
          + Put-Char-To-Output
          + Get-Char-From-Input
    (--) Other                      -> Outside-Comment
          + Put-Slash-To-Output
          + Put-Char-To-Output
          + Get-Char-From-Input

Skip-Eoln:
    (--) Quote                      -> Skip-Eoln
          + Get-Char-From-Input
    (--) Slash                      -> Skip-Eoln
          + Get-Char-From-Input
    (--) Star                       -> Skip-Eoln
          + Get-Char-From-Input
    (--) NewLine                    -> Outside-Comment
          + Put-Char-To-Output
          + Get-Char-From-Input
    (--) Other                      -> Skip-Eoln
          + Get-Char-From-Input

Skip-Comment:
    (--) Quote                      -> Skip-Comment
          + Get-Char-From-Input
    (--) Slash                      -> After-Comment-Slash
          + Get-Char-From-Input
    (--) Star                       -> After-Comment-Star
          + Get-Char-From-Input
    (--) NewLine                    -> Skip-Comment
          + Get-Char-From-Input
    (--) Other                      -> Skip-Comment
          + Get-Char-From-Input
    (--) End-Of-File                ->
          + Signal-Unterminated-Comment
          + Terminate-The-Program

After-Comment-Star:
    (--) Quote                      -> Skip-Comment
          + Get-Char-From-Input
    (--) Slash                      -> Outside-Comment
          + Other-If-Nested-Comment
          + Get-Char-From-Input
    (--) Star                       -> After-Comment-Star
          + Get-Char-From-Input
    (--) NewLine                    -> Skip-Comment
          + Get-Char-From-Input
    (--) Other                      -> Skip-Comment
          + Get-Char-From-Input
    (--) End-Of-File                ->
          + Signal-Unterminated-Comment
          + Terminate-The-Program

After-Comment-Slash:
    (--) Quote                      -> Skip-Comment
          + Get-Char-From-Input
    (--) Slash                      -> Skip-Comment
          + Get-Char-From-Input
    (--) Star                       -> Skip-Comment
          + Start-New-Comment
          + Get-Char-From-Input
    (--) NewLine                    -> Skip-Comment
          + Get-Char-From-Input
    (--) Other                      -> Skip-Comment
          + Get-Char-From-Input
    (--) End-Of-File                ->
          + Signal-Unterminated-Comment
          + Terminate-The-Program

Defaults:
    (--) Exception                  ->
          + Terminate-The-Program
    (--) End-Of-File                ->
          + Terminate-The-Program
