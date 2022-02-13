!============================================================================*
!                                                                            *
!   pctpictd.l  Dialog file for PCT picture analysis routine                 *
!                                                                            *
!   Written:    95/02/26  Pieter Hintjens                                    *
!   Revised:    95/12/07                                                     *
!                                                                            *
!   Version:    PCT V0.2    Alpha version 0.2                                *
!                                                                            *
!   Author:     Pieter A. Hintjens                                           *
!               Pijlstraat 9                                                 *
!               2060 Antwerpen, Belgium                                      *
!               ph@mymail.com                                                *
!               (+323) 231.5277                                              *
!                                                                            *
!   Portable COBOL Translator.  Copyright (c) 1993-95 Pieter A. Hintjens.    *
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
!============================================================================*

/source=pctpict
/style=title

After-Init:
    (--) Ok                                 -> Have-First-Char
          + Get-Next-Picture-Char
    (--) Error                              ->
          + Terminate-The-Program

Have-First-Char:
    (--) X-Character                        -> In-Character
          + Collect-Repetition-Or-Run
          + Count-Picture-Component
          + Get-Next-Picture-Char
    (--) Nine-Numeric                       -> In-Prov-Numeric
          + Collect-Repetition-Or-Run
          + Count-Picture-Component
          + Get-Next-Picture-Char
    (--) S-Virtual-Sign                     -> In-Pure-Numeric
          + Have-Virtual-Sign
          + Get-Next-Picture-Char
    (--) V-Virtual-Point                    -> In-Pure-Numeric
          + Have-Decimal-Point
          + Get-Next-Picture-Char
    (--) Edit-Character                     -> In-Edited
          + Collect-Repetition-Or-Run
          + Count-Picture-Component
          + Get-Next-Picture-Char
    (--) Comma-Character                    -> In-Edited
          + Collect-Repetition-Or-Run
          + Count-Picture-Component
          + Get-Next-Picture-Char
    (--) Point-Character                    -> In-Edited
          + Count-Picture-Component
          + Have-Decimal-Point
          + Get-Next-Picture-Char
    (--) Z-Zero-Suppress                    -> Z-Edited
          + Collect-Repetition-Or-Run
          + Count-Picture-Component
          + Get-Next-Picture-Char
    (--) Star-Zero-Suppress                 -> Star-Edited
          + Collect-Repetition-Or-Run
          + Count-Picture-Component
          + Get-Next-Picture-Char
    (--) Sign-Character                     -> Have-Sign
          + Collect-Repetition-Or-Run
          + Count-Picture-Component
          + Have-Sign-Character
          + Check-If-One-Or-Many
    (--) Dollar-Character                   -> Have-Dollar
          + Collect-Repetition-Or-Run
          + Count-Picture-Component
          + Check-If-One-Or-Many
    (--) Finished                           ->
          + Signal-Empty-Picture


!   We have only seen 'X's.  A '9' switches us to Alphanumeric.

In-Character:
    (--) X-Character                        -> In-Character
          + Collect-Repetition-Or-Run
          + Count-Picture-Component
          + Get-Next-Picture-Char
    (--) Nine-Numeric                       -> In-Alphanumeric
          + Collect-Repetition-Or-Run
          + Count-Picture-Component
          + Get-Next-Picture-Char
    (--) Finished                           ->
          + Set-Character-Picture
          + Terminate-The-Program


!   We have only seen '9's.

In-Prov-Numeric:
    (--) X-Character                        -> In-Alphanumeric
          + Collect-Repetition-Or-Run
          + Count-Picture-Component
          + Get-Next-Picture-Char
    (--) Nine-Numeric                       -> In-Prov-Numeric
          + Collect-Repetition-Or-Run
          + Count-Picture-Component
          + Get-Next-Picture-Char
    (--) V-Virtual-Point                    -> In-Pure-Numeric
          + Have-Decimal-Point
          + Get-Next-Picture-Char
    (--) Edit-Character                     -> In-Edited
          + Collect-Repetition-Or-Run
          + Count-Picture-Component
          + Get-Next-Picture-Char
    (--) Comma-Character                    -> In-Edited
          + Collect-Repetition-Or-Run
          + Count-Picture-Component
          + Get-Next-Picture-Char
    (--) Point-Character                    -> In-Edited
          + Count-Picture-Component
          + Have-Decimal-Point
          + Get-Next-Picture-Char
    (--) Sign-Character                     -> In-Edited
          + Collect-Repetition-Or-Run
          + Count-Picture-Component
          + Allow-One-Sign-Only-At-End
          + Have-Sign-Character
          + Get-Next-Picture-Char
    (--) Finished                           ->
          + Set-Numeric-Picture
          + Terminate-The-Program


!   We have only seen '9's, 'S', or 'V'.  We only accept further '9' or
!   'V's.  Checking against multiple virtual points is handled inside
!   'Have-Decimal-Point'.

In-Pure-Numeric:
    (--) Nine-Numeric                       -> In-Pure-Numeric
          + Collect-Repetition-Or-Run
          + Count-Picture-Component
          + Get-Next-Picture-Char
    (--) V-Virtual-Point                    -> In-Pure-Numeric
          + Have-Decimal-Point
          + Get-Next-Picture-Char
    (--) Finished                           ->
          + Set-Numeric-Picture
          + Terminate-The-Program


!   We have seen a combination of '9's and 'X's.  We accept any further
!   combination of these characters.

In-Alphanumeric:
    (--) X-Character                        -> In-Alphanumeric
          + Collect-Repetition-Or-Run
          + Count-Picture-Component
          + Get-Next-Picture-Char
    (--) Nine-Numeric                       -> In-Alphanumeric
          + Collect-Repetition-Or-Run
          + Count-Picture-Component
          + Get-Next-Picture-Char
    (--) Finished                           ->
          + Set-Alphanumeric-Picture
          + Terminate-The-Program


!   We have seen any editing character.  Checking against multiple decimal
!   points is handled inside 'Have-Decimal-Point'.

In-Edited:
    (--) Nine-Numeric                       -> In-Edited
          + Collect-Repetition-Or-Run
          + Count-Picture-Component
          + Get-Next-Picture-Char
    (--) Edit-Character                     -> In-Edited
          + Collect-Repetition-Or-Run
          + Count-Picture-Component
          + Get-Next-Picture-Char
    (--) Comma-Character                    -> In-Edited
          + Collect-Repetition-Or-Run
          + Count-Picture-Component
          + Get-Next-Picture-Char
    (--) Point-Character                    -> In-Edited
          + Count-Picture-Component
          + Have-Decimal-Point
          + Get-Next-Picture-Char
    (--) Sign-Character                     -> In-Edited
          + Collect-Repetition-Or-Run
          + Count-Picture-Component
          + Allow-One-Sign-Only-At-End
          + Have-Sign-Character
          + Get-Next-Picture-Char
    (--) Finished                           ->
          + Set-Edited-Picture
          + Terminate-The-Program


!   We have only seen 'Z's, commas, or a point.  If we get another editing
!   character or '9' we switch to the In-Edited state.  We check that the
!   'Z's ended cleanly at the decimal point.

Z-Edited:
    (--) Z-Zero-Suppress                    -> Z-Edited
          + Collect-Repetition-Or-Run
          + Count-Picture-Component
          + Get-Next-Picture-Char
    (--) Nine-Numeric                       -> In-Edited
          + Check-Suppress-Ends-At-Point
          + Collect-Repetition-Or-Run
          + Count-Picture-Component
          + Get-Next-Picture-Char
    (--) Edit-Character                     -> In-Edited
          + Collect-Repetition-Or-Run
          + Count-Picture-Component
          + Get-Next-Picture-Char
    (--) Comma-Character                    -> Z-Edited
          + Collect-Repetition-Or-Run
          + Count-Picture-Component
          + Get-Next-Picture-Char
    (--) Point-Character                    -> Z-Edited
          + Count-Picture-Component
          + Have-Decimal-Point
          + Get-Next-Picture-Char
    (--) Finished                           ->
          + Set-Edited-Picture
          + Terminate-The-Program


!   We have only seen '*'s, commas, or a point.  If we get another editing
!   character or '9' we switch to the In-Edited state.  We check that the
!   '*'s ended cleanly at the decimal point.

Star-Edited:
    (--) Star-Zero-Suppress                 -> Star-Edited
          + Collect-Repetition-Or-Run
          + Count-Picture-Component
          + Get-Next-Picture-Char
    (--) Nine-Numeric                       -> In-Edited
          + Check-Suppress-Ends-At-Point
          + Collect-Repetition-Or-Run
          + Count-Picture-Component
          + Get-Next-Picture-Char
    (--) Edit-Character                     -> In-Edited
          + Collect-Repetition-Or-Run
          + Count-Picture-Component
          + Get-Next-Picture-Char
    (--) Comma-Character                    -> Star-Edited
          + Collect-Repetition-Or-Run
          + Count-Picture-Component
          + Get-Next-Picture-Char
    (--) Point-Character                    -> Star-Edited
          + Count-Picture-Component
          + Have-Decimal-Point
          + Get-Next-Picture-Char
    (--) Finished                           ->
          + Set-Edited-Picture
          + Terminate-The-Program


!   We have just read one or many sign characters at the start of the
!   picture.  After one sign, other floating editing like 'Z' and '*'
!   are permitted.  After many signs, we only allow replacement editing
!   characters.

Have-Sign:
    (--) One                                -> After-Sign
          + Get-Next-Picture-Char
    (--) Many                               -> In-Edited
          + Have-Floating-Insert
          + Get-Next-Picture-Char


!   We have had a single sign; here we allow any editing character
!   including floating dollar inserts.
!   A single sign character by itself is considered as an invalid empty
!   picture.

After-Sign:
    (--) Nine-Numeric                       -> In-Edited
          + Collect-Repetition-Or-Run
          + Count-Picture-Component
          + Get-Next-Picture-Char
    (--) Edit-Character                     -> In-Edited
          + Collect-Repetition-Or-Run
          + Count-Picture-Component
          + Get-Next-Picture-Char
    (--) Comma-Character                    -> In-Edited
          + Collect-Repetition-Or-Run
          + Count-Picture-Component
          + Get-Next-Picture-Char
    (--) Point-Character                    -> In-Edited
          + Count-Picture-Component
          + Have-Decimal-Point
          + Get-Next-Picture-Char
    (--) Z-Zero-Suppress                    -> Z-Edited
          + Collect-Repetition-Or-Run
          + Count-Picture-Component
          + Get-Next-Picture-Char
    (--) Star-Zero-Suppress                 -> Star-Edited
          + Collect-Repetition-Or-Run
          + Count-Picture-Component
          + Get-Next-Picture-Char
    (--) Dollar-Character                   -> Have-Dollar
          + Collect-Repetition-Or-Run
          + Count-Picture-Component
          + Check-If-One-Or-Many
    (--) Finished                           ->
          + Signal-Empty-Picture


!   We have just read one or many currency symbols at the start of the
!   picture.  After one dollar, other floating editing like 'Z' and '*'
!   are permitted.  After many dollars, we only allow replacement editing
!   characters.

Have-Dollar:
    (--) One                                -> After-Dollar
          + Get-Next-Picture-Char
    (--) Many                               -> In-Edited
          + Have-Floating-Insert
          + Get-Next-Picture-Char


!   We have had a single dollar; here we allow any editing character except
!   a sign.
!   A single dollar character by itself is considered as an invalid empty
!   picture.

After-Dollar:
    (--) Nine-Numeric                       -> In-Edited
          + Collect-Repetition-Or-Run
          + Count-Picture-Component
          + Get-Next-Picture-Char
    (--) Edit-Character                     -> In-Edited
          + Collect-Repetition-Or-Run
          + Count-Picture-Component
          + Get-Next-Picture-Char
    (--) Comma-Character                    -> In-Edited
          + Collect-Repetition-Or-Run
          + Count-Picture-Component
          + Get-Next-Picture-Char
    (--) Point-Character                    -> In-Edited
          + Count-Picture-Component
          + Have-Decimal-Point
          + Get-Next-Picture-Char
    (--) Z-Zero-Suppress                    -> Z-Edited
          + Collect-Repetition-Or-Run
          + Count-Picture-Component
          + Get-Next-Picture-Char
    (--) Star-Zero-Suppress                 -> Star-Edited
          + Collect-Repetition-Or-Run
          + Count-Picture-Component
          + Get-Next-Picture-Char
    (--) Finished                           ->
          + Signal-Empty-Picture


!   Any characters that are not accepted in the current state cause an
!   error message.  Also, a occurence specifier at the wrong moment (eg.
!   after a decimal point) signals an error.

Defaults:
    (--) X-Character                        ->
          + Signal-Invalid-Picture-Char
    (--) Nine-Numeric                       ->
          + Signal-Invalid-Picture-Char
    (--) S-Virtual-Sign                     ->
          + Signal-Invalid-Picture-Char
    (--) V-Virtual-Point                    ->
          + Signal-Invalid-Picture-Char
    (--) Z-Zero-Suppress                    ->
          + Signal-Invalid-Picture-Char
    (--) Star-Zero-Suppress                 ->
          + Signal-Invalid-Picture-Char
    (--) Edit-Character                     ->
          + Signal-Invalid-Picture-Char
    (--) Comma-Character                    ->
          + Signal-Invalid-Picture-Char
    (--) Point-Character                    ->
          + Signal-Invalid-Picture-Char
    (--) Sign-Character                     ->
          + Signal-Invalid-Picture-Char
    (--) Dollar-Character                   ->
          + Signal-Invalid-Picture-Char
    (--) Open-Parenthesis                   ->
          + Signal-Invalid-Repetition
    (--) Unknown-Char                       ->
          + Signal-Invalid-Picture-Char
    (--) Error                              ->
          + Return-Error-Feedback
          + Terminate-The-Program
