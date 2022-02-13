!============================================================================
!
!   expr.l      Dialog for expression calculation program
!
!   Written:    95/03/13  Pieter Hintjens
!   Revised:    95/10/14
!
!============================================================================
-schema=lrschema.asm
-opt:model=com

After-Init:
    (--) Ok                                 -> Expecting-Operand
          + Get-Next-Token
    (--) Error                              ->
          + Terminate-The-Program

Expecting-Operand:
    (--) Term-Op                            ->
          + Allow-Signed-Number
          + Signal-Invalid-Token
          + Terminate-The-Program
    (--) Number                             -> Expecting-Operator
          + Stack-The-Number
          + Get-Next-Token
    (--) Left-Par                           -> Expecting-Operand
          + Stack-The-Operator
          + Get-Next-Token

Expecting-Operator:
    (--) Term-Op                            -> Expecting-Operand
          + Unstack-Ge-Operators
          + Stack-The-Operator
          + Get-Next-Token
    (--) Factor-Op                          -> Expecting-Operand
          + Unstack-Ge-Operators
          + Stack-The-Operator
          + Get-Next-Token
    (--) End-Mark                           ->
          + Unstack-All-Operators
          + Unstack-If-End-Mark
          + Terminate-The-Program
    (--) Right-Par                          -> Expecting-Operator
          + Unstack-All-Operators
          + Unstack-If-Left-Par
          + Get-Next-Token

Defaults:
    (--) Number                             ->
          + Signal-Invalid-Token
          + Terminate-The-Program
    (--) Term-Op                            ->
          + Signal-Invalid-Token
          + Terminate-The-Program
    (--) Factor-Op                          ->
          + Signal-Invalid-Token
          + Terminate-The-Program
    (--) End-Mark                           ->
          + Signal-Token-Missing
          + Terminate-The-Program
    (--) Exception                          ->
          + Terminate-The-Program
    (--) Other                              ->
          + Signal-Invalid-Token
          + Terminate-The-Program
    (--) Left-Par                           ->
          + Signal-Invalid-Token
          + Terminate-The-Program
    (--) Right-Par                          ->
          + Signal-Invalid-Token
          + Terminate-The-Program
