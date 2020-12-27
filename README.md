
# Brainfuck--

A variation of the well known `Brainfuck` language.
Developed by [@einthomaz](https://github.com/einthomaz) in the `Crystal Language`.

## Installation

Install the `crystal language` on your system (only Linux available).

Use this tutorial for the installation of the `crystal language` :  [Installation Guide](https://crystal-lang.org/install/)
After installing crystal clone this repository using : 
```bash
git clone https://github.com/einthomaz/Brainfuck--.git
```
After that `cd` into the directory.
Build a binary from the `brainfuck.cr` using
```bash
crystal build brainfuck.cr
```
Now you can use the binary created and show help using
```bash
./brainfuck -h
```
## `Brainfuck--` Executable Arguments
```
Brainfuck interpreter programmed in Crystal
    -f NAME, --file=NAME             Run Brainfuck code from file
    -r SIZE, --register_size=SIZE    Set Register-Size (Normal is 16)
    -v VERBOSE, --verbose=VERBOSE    Print Registers at the end of the program (Int 0 => false(default), 1 => true)
    -h, --help                       Show help
```

## `Brainfuck--` Documentation
```
+	->	Add 1 to the current register.
-	->	Subtract 1 from the current register.
>	->	Adds 1 to the register pointer.
<	->	Subtract 1 from the register pointer.
[...]	->	Loops as long as the current register is not 0.
.	->	Prints the current register in ascii representation.
!	->	Sets the current register to 0.
?	->	Prints the current register as integer.
$	->	Print registers.
#	->	Stores the current register in a variable.
%	->	Subtract stored value from the register pointer.
&	->	Add stored value to the register pointer.
/	->	Print the current register as integer with a newline.
```
## `Brainfuck--` example
Example that generates `fibonacci` numbers and prints them.
Without comments
```
++++++++++++++++++++++++++++++ --
>++
>+/
>+/
<<#<
[
    >&
    [>+>+<<-]
    >>[<<+>>-]
    <<<[>>+>+<<<-]
    >>>[<<<+>>>-]</>
    <<
    %+#<-
]
```
Commented code
```
++++++++++++++++++++++++++++++ --  ->   Sets the ammount of numbers to generate (minus 2 for the already existing 2).
>++ -> Sets the ammount of numbers already generated in register 2.
>+/ -> Sets the number in register 3 to 1 (first fibonacci number) and prints it.
>+/ -> Sets the number in register 4 to 1 (second fibonacci number) and prints it.
<<#< -> Stores the number from register 2 and goes to register 1.
[ -> Opens a loop until the number in register 1 is 0.
    >& -> Goes to register 2 and jumps the stored number of registers to the right. (Now in register 4)
    [>+>+<<-] -> Copies the value from register 4 to register 5 and register 6.
    >>[<<+>>-] -> Copies the register 6 to register 4.
    <<<[>>+>+<<<-] -> Copies the value from register 3 to register 5 and register 6.
    >>>[<<<+>>>-]</> -> Copies the value from register 6 to register 3.
    << -> Goes to register 4
    %+#<- -> Jumps sotred number of registers to the left, adds 1, stores the value, and subtracts 1 from the first register.
] -> repeated, until the number in register 1 is 0.
```
