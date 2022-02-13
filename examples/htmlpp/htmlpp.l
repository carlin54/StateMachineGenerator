!*===========================================================================*
!                                                                            *
!   htmlpp.l    HTML pre-processor 1.0                                       *
!                                                                            *
!   Written:    96/03/27  Pieter Hintjens <ph@imatix.com>                    *
!   Revised:    96/04/01                                                     *
!                                                                            *
!   Copyright (c) 1996 Pieter Hintjens.  May be freely distributed.          *
!*===========================================================================*
-schema=lrschema.pl

After-Init:
    (--) Ok                                 -> Collect-Titles
          + Initialise-Program-Data
          + Load-Anchor-Definitions
          + Signal-Collecting-Titles
          + Open-Main-Document
          + Get-Next-Document-Line
    (--) Error                              ->
          + Terminate-The-Program

Collect-Titles:
    (--) Body-Text                          -> Collect-Titles
          + Expand-Symbols-In-Line
          + Collect-Title-If-Present
          + Get-Next-Document-Line
    (--) Blank-Line                         -> Collect-Titles
          + Get-Next-Document-Line
    (--) Comment                            -> Collect-Titles
          + Get-Next-Document-Line
    (--) Define                             -> Collect-Titles
          + Expand-Symbols-In-Line
          + Store-Symbol-Definition
          + Get-Next-Document-Line
    (--) Include                            -> Collect-Titles
          + Expand-Symbols-In-Line
          + Take-Include-File-Name
          + Open-The-Document
          + Get-Next-Document-Line
    (--) Ignore                             -> Collect-Titles
          + Expand-Symbols-In-Line
          + Handle-Ignore-Command
          + Get-Next-Document-Line
    (--) Page                               -> Collect-Titles
          + Expand-Symbols-In-Line
          + Check-If-Ignore-Pages
          + Collect-Page-Information
          + Get-Next-Document-Line
    (--) Ignore-Pages                       -> Collect-Titles
          + Parse-Page-Title-Only
          + Get-Next-Document-Line
    (--) Block                              -> Skip-Block
          + Get-Next-Document-Line
    (--) End                                -> Collect-Titles
          + Get-Next-Document-Line
    (--) Build                              -> Collect-Titles
          + Get-Next-Document-Line
    (--) Finished                           -> Before-Page
          + Close-The-Document
          + Signal-Formatting-Pages
          + Open-Main-Document
          + Get-Next-Document-Line
    (--) Continue                           -> Collect-Titles
          + Get-Next-Document-Line
    (--) Error                              -> Collect-Titles
          + Get-Next-Document-Line

Skip-Block: <Collect-Titles>
    (--) Body-Text                          -> Skip-Block
          + Get-Next-Document-Line
    (--) Blank-Line                         -> Skip-Block
          + Get-Next-Document-Line
    (--) Define                             ->
          + Signal-End-Block-Missing
          + Terminate-The-Program
    (--) Include                            ->
          + Signal-End-Block-Missing
          + Terminate-The-Program
    (--) Ignore                             ->
          + Signal-End-Block-Missing
          + Terminate-The-Program
    (--) Page                               ->
          + Signal-End-Block-Missing
          + Terminate-The-Program
    (--) Block                              -> Skip-Block
          + Get-Next-Document-Line
    (--) End                                -> Collect-Titles
          + Get-Next-Document-Line
    (--) Build                              ->
          + Signal-End-Block-Missing
          + Terminate-The-Program
    (--) Finished                           ->
          + Signal-End-Block-Missing
          + Terminate-The-Program
    (--) Continue                           -> Collect-Titles
          + Get-Next-Document-Line

Before-Page:
    (--) Body-Text                          -> Before-Page
          + Signal-Body-Text-Skipped
          + Get-Next-Document-Line
    (--) Blank-Line                         -> Before-Page
          + Get-Next-Document-Line
    (--) Comment                            -> Before-Page
          + Get-Next-Document-Line
    (--) Define                             -> Before-Page
          + Expand-Symbols-In-Line
          + Store-Symbol-Definition
          + Get-Next-Document-Line
    (--) Include                            -> Before-Page
          + Expand-Symbols-In-Line
          + Take-Include-File-Name
          + Open-The-Document
          + Get-Next-Document-Line
    (--) Ignore                             -> Before-Page
          + Expand-Symbols-In-Line
          + Handle-Ignore-Command
          + Get-Next-Document-Line
    (--) Page                               -> Inside-Page
          + Expand-Symbols-In-Line
          + Check-If-Ignore-Pages
          + Open-New-Output-Page
          + Output-Header-For-Page
          + Get-Next-Document-Line
    (--) Ignore-Pages                       -> Before-Page
          + Parse-Page-Title-Only
          + Get-Next-Document-Line
    (--) Block                              -> Collect-Block
          + Clear-Specified-Block
          + Get-Next-Document-Line
          + Dialog-Call
    (--) Return                             -> Before-Page
          + Get-Next-Document-Line
    (--) End                                -> Before-Page
          + Signal-End-Not-Expected
          + Get-Next-Document-Line
    (--) Build                              -> Before-Page
          + Signal-Build-Not-Expected
          + Get-Next-Document-Line
    (--) Finished                           ->
          + Close-The-Document
          + Signal-Document-Processed
          + Save-Anchor-Definitions
          + Terminate-The-Program
    (--) Continue                           -> Before-Page
          + Get-Next-Document-Line
    (--) Error                              -> Before-Page
          + Get-Next-Document-Line

Inside-Page: <Before-Page>
    (--) Body-Text                          -> Inside-Page
          + Expand-Symbols-In-Line
          + Anchor-Title-If-Present
          + Copy-Line-To-Output-Page
          + Get-Next-Document-Line
    (--) Blank-Line                         -> Inside-Page
          + Copy-Line-To-Output-Page
          + Get-Next-Document-Line
    (--) Page                               -> Inside-Page
          + Check-If-Ignore-Pages
          + Output-Footer-For-Page
          + Expand-Symbols-In-Line
          + Open-New-Output-Page
          + Output-Header-For-Page
          + Get-Next-Document-Line
    (--) Ignore-Pages                       -> Inside-Page
          + Parse-Page-Title-Only
          + Get-Next-Document-Line
    (--) Build                              -> Inside-Page
          + Build-Specified-Table
          + Get-Next-Document-Line
    (--) Finished                           ->
          + Close-The-Document
          + Output-Footer-For-Page
          + Signal-Document-Processed
          + Save-Anchor-Definitions
          + Terminate-The-Program

Collect-Block: <Before-Page>
    (--) Body-Text                          -> Collect-Block
          + Add-Line-To-Block
          + Get-Next-Document-Line
    (--) Blank-Line                         -> Collect-Block
          + Add-Line-To-Block
          + Get-Next-Document-Line
    (--) Block                              -> Collect-Block
          + Clear-Specified-Block
          + Get-Next-Document-Line
    (--) End                                ->
          + Dialog-Return
    (--) Continue                           ->
          + Dialog-Return

Defaults:
    (--) Exception                          ->
          + Terminate-The-Program
