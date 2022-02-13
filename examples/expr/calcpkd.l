!============================================================================*
!                                                                            *
!   calcpkd.l   COBOL Expression Calculation function                        *
!                                                                            *
!   Written:    95/04/26  Pieter Hintjens                                    *
!   Revised:    95/12/07                                                     *
!                                                                            *
!   Author:     Pieter A. Hintjens                                           *
!               Pijlstraat 9                                                 *
!               2060 Antwerpen, Belgium                                      *
!               ph@mymail.com                                                *
!               (+323) 231.5277                                              *
!                                                                            *
!   FSM Code Generator.  Copyright (c) 1991-95 Pieter A. Hintjens.           *
!                                                                            *
!   This program is free software; you can redistribute it and/or modify     *
!   it under the terms of the GNU General Public License as published by     *
!   the Free Software Foundation; either version 2 of the License, or        *
!   (at your option) any later version.                                      *
!                                                                            *
!   This program is distributed in the hope that it will be useful,          *
!   but WITHOUT ANY WARRANTY; without even the implied warranty of           *
!   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            *
!   GNU General Public License for more details.                             *
!                                                                            *
!   You should have received a copy of the GNU General Public License        *
!   along with this program; if not, write to the Free Software              *
!   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.                *
!*===========================================================================*
-schema=lrschema.cob
-source=calcpk.cob
-opt:model=called       !  Generate subroutine linkage

After-Init:
    (--) Ok                                 -> Start-Expression
          + Get-Next-Token
    (--) Error                              ->
          + Terminate-The-Program

Start-Expression:
    (--) Function                           -> Expecting-Operand
          + Stack-The-Operator
          + Get-Next-Token
    (--) Operand                            -> Expecting-Operator
          + Stack-The-Operand
          + Get-Next-Token
    (--) Left-Par                           -> Expecting-Operand
          + Stack-The-Operator
          + Get-Next-Token
    (--) Operator                           ->
          + Check-If-Signed-Number
          + Signal-Invalid-Token
          + Terminate-The-Program
    (--) End-Mark                           ->
          + Terminate-The-Program

Expecting-Operator:
    (--) Operator                           -> Expecting-Operand
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

Expecting-Operand:
    (--) Function                           -> Expecting-Operand
          + Stack-The-Operator
          + Get-Next-Token
    (--) Operand                            -> Expecting-Operator
          + Stack-The-Operand
          + Get-Next-Token
    (--) Left-Par                           -> Expecting-Operand
          + Stack-The-Operator
          + Get-Next-Token
    (--) Operator                           ->
          + Check-If-Signed-Number
          + Signal-Invalid-Token
          + Terminate-The-Program

Defaults:
    (--) Operand                            ->
          + Signal-Invalid-Token
          + Terminate-The-Program
    (--) Operator                           ->
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
    (--) Function                           ->
          + Signal-Invalid-Token
          + Terminate-The-Program
