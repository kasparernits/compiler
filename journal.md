# Journal

Documenting the process of writing my C compiler.  

### July 19, 2026

Struggling with getting the test suite to work with my driver.  
Reading sed & awk to distract me from fixing the test suite.  

### July 4, 2026

Using iPad pro as a "dumb terminal" with ShellFish client and OpenBSD server works really well.

Special characters in iPad CH Magic Keyboard.

```
[ Option 5
] Option 6
| Option 7
{ Option 8
} Option 9
~ Option n
\ Option SHIFT 7
```

### July 3, 2026

Vi notes

Find replace in current line
```
:s/CATS/DOGS/g
```

Find replace in entire file
```
:%s/CATS/DOGS/g
```

Visual Mode

```
Ctrl + v 
Use j/k keys to select rows
Shift i to go into enter mode
Type the charcter
Esc twice
```

### July 2, 2026

Applying kernel source file style to my scripts.

```
man 9 style
```

### June 28, 2026

Confused about different types of patten matching that can be done. 
Globbing and extended globbing are designed for file name matching so I am going to use extended regex for the lexer. 

STANDARD GLOBBING

*
any string of characters
'file*.txt' matches file.txt, file1.txt

?
exactly one character		
'image?.png' matches image1.png, imageA.png

[...]
any one character, including ranges  
'log_[0-9].txt' matches log_0.txt, log_1.txt

[!...] or [^...] 
matches any one character not enclosed in brackets  
'data_[!0-9].csv' matches data_a.csv

[:space:], [:digit:], [:lower:], [:upper:], [:alpha:], [:alnum:]
POSIX character classes  
'file_[[:digit:]].txt' matches file_7.txt

EXTENDED GLOBBING

Uses quantifier followed by list of patterns, separated by OR |

?(pattern-list)
zero or ONE occurrence of patterns  
'file?(test).txt' matches file.txt and filetest.txt

*(pattern-list)
zero or MORE occurrences of patterns  
'data*(0).csv' matches data0.csv and data000.csv

+(pattern-list)
one or more  
'track+(0).mp3' matches track0.mp3 but not track.mp3

@(pattern-list)
exactly one of the given patterns  
'report.@(pdf|txt).doc' matches report.pdf, report.txt but wont match report.jpg

!(pattern-list)
anything except the given patterns and we can combine these  

'*([0-9])?(.csv)' finds strings that optionally end with .csv, e.g. 123 and 564.csv  

rm '!(*.jpg|*.png)' deletes all files except jpg and png images 

June 20, 2026

Lexer requires proper understanding of regular expressions so started reading "Mastering Regular Expresssions". 
Two books to read before pickig up the compiler book again. 

Got a full list of Englsh words and full works of Shakespeare to practice RegEx.

June 14, 2026

Got the book from eBay, reading Chapter 1.  
Wrote the compiler driver.  
Wrote the lexer using Gemini, decided to not use LLMs, deleted the code, starting it from scratch.  

May 23, 2026

Installed ksh93 on my OpenBSD computer for writing the compiler.  
OpenBSD comes wiht pdksh (Public Domain Korn Shell) which lacks features that I need.

May 19, 2026

Got the Korn shell book from eBay, reading that.  

