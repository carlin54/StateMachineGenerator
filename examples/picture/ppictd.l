-schema=lrschema.cob
-plusd
-opt:ext=cob
-opt:model=called

After-Init:
    (--) Ok                                 -> Doing-Operation
          + Execute-The-Operation
    (--) Error                              ->
          + Terminate-The-Program

Doing-Operation:
    (--) Picture                            -> Start-Of-Picture
          + Init-Picture-Parsing
          + Get-Next-Symbol
    (--) Error                              ->
          + Terminate-The-Program

Defaults:
    (--) Floating-Insert                    -> Ne
          + Get-Next-Symbol
    (--) Left-Par                           ->
          + Get-Repetitions
          + Get-Next-Symbol
    (--) Other                              -> Error
          + Signal-Invalid-Symbol
          + Get-Next-Symbol

Start-Of-Picture:
    (--) Letter-P                           -> Nu-Ne
          + Get-Next-Symbol
    (--) Digit-9                            -> All-9s
          + Get-Next-Symbol
    (--) Left-Par                           -> Error
          + Signal-Nothing-To-Repeat
          + Get-Next-Symbol
    (--) Letter-A                           -> All-As
          + Get-Next-Symbol
    (--) Letter-B                           -> Al-Ae-Ne
          + Get-Next-Symbol
    (--) At-End                             ->
          + Signal-No-Picture
          + Terminate-The-Program
    (--) Letter-V                           -> Nu-Ne
          + Get-Next-Symbol
    (--) Letter-E                           -> Error
          + Signal-Floating-Error
          + Get-Next-Symbol
    (--) Edit-Symbol                        -> Ne
          + Get-Next-Symbol
    (--) Point                              -> Ne
          + Get-Next-Symbol
    (--) Sign                               -> Ne-Fl
          + Get-Next-Symbol
    (--) Slash-Or-0                         -> Ae-Ne
          + Get-Next-Symbol
    (--) Letter-X                           -> An-Ae
          + Get-Next-Symbol
    (--) Letter-S                           -> Nu
          + Get-Next-Symbol

Al-Ae-Ne:
    (--) Letter-S                           -> Error
          + Signal-Not-Number
          + Get-Next-Symbol
    (--) Letter-P                           -> Ne
          + Get-Next-Symbol
    (--) Digit-9                            -> An-Ae
          + Get-Next-Symbol
    (--) Letter-A                           -> Al-Ae
          + Get-Next-Symbol
    (--) Letter-B                           -> Al-Ae-Ne
          + Get-Next-Symbol
    (--) At-End                             ->
          + Store-Al-Or-Ae-Or-Ne
          + Terminate-The-Program
    (--) Letter-V                           -> Error
          + Signal-Not-Numeric
          + Get-Next-Symbol
    (--) Letter-E                           -> Error
          + Signal-Not-Floating
          + Get-Next-Symbol
    (--) Point                              -> Ne
          + Get-Next-Symbol
    (--) Edit-Symbol                        -> Ne
          + Get-Next-Symbol
    (--) Sign                               -> Ne
          + Get-Next-Symbol
    (--) Slash-Or-0                         -> Ae-Ne
          + Get-Next-Symbol
    (--) Letter-X                           -> An-Ae
          + Get-Next-Symbol

Ae-Ne:
    (--) At-End                             ->
          + Store-Ae-Or-Ne
          + Terminate-The-Program
    (--) Letter-V                           -> Error
          + Signal-Not-Numeric
          + Get-Next-Symbol
    (--) Letter-E                           -> Error
          + Signal-Not-Floating
          + Get-Next-Symbol
    (--) Point                              -> Ne
          + Get-Next-Symbol
    (--) Edit-Symbol                        -> Ne
          + Get-Next-Symbol
    (--) Sign                               -> Ne
          + Get-Next-Symbol
    (--) Slash-Or-0                         -> Ae-Ne
          + Get-Next-Symbol
    (--) Letter-X                           -> An-Ae
          + Get-Next-Symbol
    (--) Letter-S                           -> Error
          + Signal-Not-Number
          + Get-Next-Symbol
    (--) Letter-P                           -> Ne
          + Get-Next-Symbol
    (--) Digit-9                            -> Ae-Ne
          + Get-Next-Symbol
    (--) Letter-A                           -> Ae
          + Get-Next-Symbol
    (--) Letter-B                           -> Ae-Ne
          + Get-Next-Symbol

Ne:
    (--) At-End                             ->
          + Store-Ne
          + Terminate-The-Program
    (--) Letter-V                           -> Ne
          + Get-Next-Symbol
    (--) Letter-E                           -> Error
          + Signal-Not-Floating
          + Get-Next-Symbol
    (--) Point                              -> Ne
          + Get-Next-Symbol
    (--) Edit-Symbol                        -> Ne
          + Get-Next-Symbol
    (--) Sign                               -> Ne
          + Get-Next-Symbol
    (--) Slash-Or-0                         -> Ae-Ne
          + Get-Next-Symbol
    (--) Letter-X                           -> Error
          + Signal-Not-Number
          + Get-Next-Symbol
    (--) Letter-S                           -> Error
          + Signal-Not-Number
          + Get-Next-Symbol
    (--) Letter-P                           -> Ne
          + Get-Next-Symbol
    (--) Digit-9                            -> Ne
          + Get-Next-Symbol
    (--) Letter-A                           -> Error
          + Signal-Not-Alphabetic
          + Get-Next-Symbol
    (--) Letter-B                           -> Ne
          + Get-Next-Symbol

Nu-Ne:
    (--) At-End                             ->
          + Store-Nu-Or-Ne
          + Terminate-The-Program
    (--) Letter-V                           -> Nu-Ne
          + Get-Next-Symbol
    (--) Letter-E                           -> Error
          + Signal-Not-Floating
          + Get-Next-Symbol
    (--) Point                              -> Ne
          + Get-Next-Symbol
    (--) Edit-Symbol                        -> Ne
          + Get-Next-Symbol
    (--) Sign                               -> Ne
          + Get-Next-Symbol
    (--) Slash-Or-0                         -> Ne
          + Get-Next-Symbol
    (--) Letter-X                           -> Error
          + Signal-Not-Alphanumeric
          + Get-Next-Symbol
    (--) Letter-S                           -> Error
          + Signal-S-Must-Be-First
          + Get-Next-Symbol
    (--) Letter-P                           -> Ne
          + Get-Next-Symbol
    (--) Digit-9                            -> Nu-Ne
          + Get-Next-Symbol
    (--) Letter-A                           -> Error
          + Signal-Not-Alphabetic
          + Get-Next-Symbol
    (--) Letter-B                           -> Ne
          + Get-Next-Symbol

Nu:
    (--) At-End                             ->
          + Store-Nu
          + Terminate-The-Program
    (--) Letter-V                           -> Nu
          + Get-Next-Symbol
    (--) Letter-E                           -> Error
          + Signal-Not-Floating
          + Get-Next-Symbol
    (--) Point                              -> Error
          + Signal-Not-Edited
          + Get-Next-Symbol
    (--) Edit-Symbol                        -> Error
          + Signal-Not-Edited
          + Get-Next-Symbol
    (--) Sign                               -> Error
          + Signal-Not-Edited
          + Get-Next-Symbol
    (--) Slash-Or-0                         -> Error
          + Signal-Not-Edited
          + Get-Next-Symbol
    (--) Letter-X                           -> Error
          + Signal-Not-Alphanumeric
          + Get-Next-Symbol
    (--) Letter-S                           -> Error
          + Signal-S-Must-Be-First
          + Get-Next-Symbol
    (--) Letter-P                           -> Nu
          + Get-Next-Symbol
    (--) Digit-9                            -> Nu
          + Get-Next-Symbol
    (--) Letter-A                           -> Error
          + Signal-Not-Alphabetic
          + Get-Next-Symbol
    (--) Letter-B                           -> Error
          + Signal-Not-Alphabetic
          + Get-Next-Symbol

Ne-Fl:
    (--) Letter-E                           -> Fl
          + Get-Next-Symbol
    (--) Point                              -> Ne-Fl
          + Get-Next-Symbol
    (--) Edit-Symbol                        -> Ne
          + Get-Next-Symbol
    (--) Sign                               -> Ne
          + Get-Next-Symbol
    (--) Slash-Or-0                         -> Ne
          + Get-Next-Symbol
    (--) Letter-X                           -> Error
          + Signal-Not-Alphanumeric
          + Get-Next-Symbol
    (--) Letter-S                           -> Nu
          + Signal-Not-Number
          + Get-Next-Symbol
    (--) Letter-P                           -> Ne
          + Get-Next-Symbol
    (--) Digit-9                            -> Ne-Fl
          + Get-Next-Symbol
    (--) Letter-A                           -> Error
          + Signal-Not-Alphabetic
          + Get-Next-Symbol
    (--) Letter-B                           -> Error
          + Signal-Not-Alphabetic
          + Get-Next-Symbol
    (--) At-End                             ->
          + Store-Ne
          + Terminate-The-Program
    (--) Letter-V                           -> Ne-Fl
          + Get-Next-Symbol

Al-Ae:
    (--) At-End                             ->
          + Store-Al-Or-Ae
          + Terminate-The-Program
    (--) Letter-V                           -> Error
          + Signal-Not-Numeric
          + Get-Next-Symbol
    (--) Letter-E                           -> Error
          + Signal-Not-Floating
          + Get-Next-Symbol
    (--) Point                              -> Error
          + Signal-Not-Numeric
          + Get-Next-Symbol
    (--) Edit-Symbol                        -> Error
          + Signal-Not-Numeric
          + Get-Next-Symbol
    (--) Sign                               -> Error
          + Signal-Not-Numeric
          + Get-Next-Symbol
    (--) Slash-Or-0                         -> Ae
          + Get-Next-Symbol
    (--) Letter-X                           -> Ae
          + Get-Next-Symbol
    (--) Letter-S                           -> Error
          + Signal-Not-Numeric
          + Get-Next-Symbol
    (--) Letter-P                           -> Error
          + Signal-Not-Numeric
          + Get-Next-Symbol
    (--) Digit-9                            -> Ae
          + Get-Next-Symbol
    (--) Letter-A                           -> Al-Ae
          + Get-Next-Symbol
    (--) Letter-B                           -> Al-Ae
          + Get-Next-Symbol

All-As:
    (--) Letter-A                           -> All-As
          + Get-Next-Symbol
    (--) Letter-B                           -> Al-Ae
          + Get-Next-Symbol
    (--) At-End                             ->
          + Store-Al
          + Terminate-The-Program
    (--) Letter-V                           -> Error
          + Signal-Not-Numeric
          + Get-Next-Symbol
    (--) Letter-E                           -> Error
          + Signal-Not-Floating
          + Get-Next-Symbol
    (--) Point                              -> Error
          + Signal-Not-Numeric
          + Get-Next-Symbol
    (--) Edit-Symbol                        -> Error
          + Signal-Not-Numeric
          + Get-Next-Symbol
    (--) Sign                               -> Error
          + Signal-Not-Numeric
          + Get-Next-Symbol
    (--) Slash-Or-0                         -> Ae
          + Get-Next-Symbol
    (--) Letter-X                           -> An-Ae
          + Get-Next-Symbol
    (--) Letter-S                           -> Error
          + Signal-Not-Numeric
          + Get-Next-Symbol
    (--) Letter-P                           -> Error
          + Signal-Not-Numeric
          + Get-Next-Symbol
    (--) Digit-9                            -> An-Ae
          + Signal-Not-Numeric
          + Get-Next-Symbol

All-9s:
    (--) At-End                             ->
          + Store-Nu
          + Terminate-The-Program
    (--) Letter-V                           -> Nu-Ne
          + Get-Next-Symbol
    (--) Letter-E                           -> Error
          + Signal-Not-Floating
          + Get-Next-Symbol
    (--) Point                              -> Ne
          + Get-Next-Symbol
    (--) Edit-Symbol                        -> Ne
          + Get-Next-Symbol
    (--) Sign                               -> Ne
          + Get-Next-Symbol
    (--) Slash-Or-0                         -> Ae-Ne
          + Get-Next-Symbol
    (--) Letter-X                           -> An-Ae
          + Get-Next-Symbol
    (--) Letter-S                           -> Error
          + Signal-S-Must-Be-First
          + Get-Next-Symbol
    (--) Letter-P                           -> Ne
          + Get-Next-Symbol
    (--) Digit-9                            -> All-9s
          + Get-Next-Symbol
    (--) Letter-A                           -> An-Ae
          + Get-Next-Symbol
    (--) Letter-B                           -> Ae-Ne
          + Get-Next-Symbol

Ae:
    (--) At-End                             ->
          + Store-Ae
          + Terminate-The-Program
    (--) Letter-V                           -> Error
          + Signal-Not-Numeric
          + Get-Next-Symbol
    (--) Letter-E                           -> Error
          + Signal-Not-Floating
          + Get-Next-Symbol
    (--) Point                              -> Error
          + Signal-Not-Numeric
          + Get-Next-Symbol
    (--) Edit-Symbol                        -> Error
          + Signal-Not-Numeric
          + Get-Next-Symbol
    (--) Sign                               -> Error
          + Signal-Not-Numeric
          + Get-Next-Symbol
    (--) Slash-Or-0                         -> Ae
          + Get-Next-Symbol
    (--) Letter-X                           -> Ae
          + Get-Next-Symbol
    (--) Letter-S                           -> Error
          + Signal-Not-Numeric
          + Get-Next-Symbol
    (--) Letter-P                           -> Error
          + Signal-Not-Numeric
          + Get-Next-Symbol
    (--) Digit-9                            -> Ae
          + Get-Next-Symbol
    (--) Letter-A                           -> Ae
          + Get-Next-Symbol
    (--) Letter-B                           -> Ae
          + Get-Next-Symbol

Fl:
    (--) At-End                             ->
          + Store-Fl
          + Terminate-The-Program
    (--) Letter-V                           -> Error
          + Signal-Floating-Error
          + Get-Next-Symbol
    (--) Letter-E                           -> Error
          + Signal-Floating-Error
          + Get-Next-Symbol
    (--) Point                              -> Error
          + Signal-Floating-Error
          + Get-Next-Symbol
    (--) Edit-Symbol                        -> Error
          + Signal-Not-Edited
          + Get-Next-Symbol
    (--) Sign                               -> Fl
          + Get-Next-Symbol
    (--) Slash-Or-0                         -> Error
          + Signal-Not-Edited
          + Get-Next-Symbol
    (--) Letter-X                           -> Error
          + Signal-Not-Alphanumeric
          + Get-Next-Symbol
    (--) Letter-S                           -> Error
          + Signal-Floating-Error
          + Get-Next-Symbol
    (--) Letter-P                           -> Error
          + Signal-Floating-Error
          + Get-Next-Symbol
    (--) Digit-9                            -> Fl
          + Get-Next-Symbol
    (--) Letter-A                           -> Error
          + Signal-Not-Alphabetic
          + Get-Next-Symbol
    (--) Letter-B                           -> Error
          + Signal-Not-Alphabetic
          + Get-Next-Symbol

An-Ae:
    (--) At-End                             ->
          + Store-An-Or-Ae
          + Terminate-The-Program
    (--) Letter-V                           -> Error
          + Signal-Not-Numeric
          + Get-Next-Symbol
    (--) Letter-E                           -> Error
          + Signal-Not-Floating
          + Get-Next-Symbol
    (--) Point                              -> Error
          + Signal-Not-Numeric
          + Get-Next-Symbol
    (--) Edit-Symbol                        -> Error
          + Signal-Not-Numeric
          + Get-Next-Symbol
    (--) Sign                               -> Error
          + Signal-Not-Numeric
          + Get-Next-Symbol
    (--) Slash-Or-0                         -> Ae
          + Get-Next-Symbol
    (--) Letter-X                           -> An-Ae
          + Get-Next-Symbol
    (--) Letter-S                           -> Error
          + Signal-Not-Numeric
          + Get-Next-Symbol
    (--) Letter-P                           -> Error
          + Signal-Not-Numeric
          + Get-Next-Symbol
    (--) Digit-9                            -> An-Ae
          + Get-Next-Symbol
    (--) Letter-A                           -> An-Ae
          + Get-Next-Symbol
    (--) Letter-B                           -> Ae
          + Get-Next-Symbol

Error:
    (--) At-End                             ->
          + Signal-Error-Found
          + Terminate-The-Program
    (--) Letter-V                           -> Error
          + Get-Next-Symbol
    (--) Letter-E                           -> Error
          + Get-Next-Symbol
    (--) Point                              -> Error
          + Get-Next-Symbol
    (--) Edit-Symbol                        -> Error
          + Get-Next-Symbol
    (--) Sign                               -> Error
          + Get-Next-Symbol
    (--) Slash-Or-0                         -> Error
          + Get-Next-Symbol
    (--) Letter-X                           -> Error
          + Get-Next-Symbol
    (--) Letter-S                           -> Error
          + Get-Next-Symbol
    (--) Letter-P                           -> Error
          + Get-Next-Symbol
    (--) Digit-9                            -> Error
          + Get-Next-Symbol
    (--) Letter-A                           -> Error
          + Get-Next-Symbol
    (--) Letter-B                           -> Error
          + Get-Next-Symbol
