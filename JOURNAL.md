# Journal: Documenting the Process of Writing My C Compiler

## June 28, 2026

Confused about different types of pattern matching that can be done. Globbing and extended globbing are designed for file name matching, so I am going to use extended regex for the lexer.

### Standard Globbing

| Pattern | Description | Example |
| :--- | :--- | :--- |
| `*` | Any string of characters | `'file*.txt'` matches `file.txt`, `file1.txt` |
| `?` | Exactly one character | `'image?.png'` matches `image1.png`, `imageA.png` |
| `[...]` | Any one character, including ranges | `'log_[0-9].txt'` matches `log_0.txt`, `log_1.txt` |
| `[!...]` or `[^...]` | Matches any one character not enclosed in brackets | `'data_[!0-9].csv'` matches `data_a.csv` |
| `[:space:]`, `[:digit:]`, `[:lower:]`, `[:upper:]`, `[:alpha:]`, `[:alnum:]` | POSIX character classes | `'file_[[:digit:]].txt'` matches `file_7.txt` |

### Extended Globbing

Uses a quantifier followed by a list of patterns, separated by the OR operator (`|`).

| Pattern | Description | Example |
| :--- | :--- | :--- |
| `?(pattern-list)` | Zero or **one** occurrence of patterns | `'file?(test).txt'` matches `file.txt` and `filetest.txt` |
| `*(pattern-list)` | Zero or **more** occurrences of patterns | `'data*(0).csv'` matches `data0.csv` and `data000.csv` |
| `+(pattern-list)` | **One or more** occurrences of patterns | `'track+(0).mp3'` matches `track0.mp3` but not `track.mp3` |
| `@(pattern-list)` | **Exactly one** of the given patterns | `'report.@(pdf|txt).doc'` matches `report.pdf`, `report.txt` but won't match `report.jpg` |
| `!(pattern-list)` | Anything **except** the given patterns | See complex combinations below |

#### Advanced Examples & Combinations:
* `*([0-9])?(.csv)` finds strings that optionally end with `.csv`, e.g., `123` and `564.csv`.
* `rm '!(*.jpg|*.png)'` deletes all files except `.jpg` and `.png` images.

---

## June 20, 2026

Lexer requires a proper understanding of regular expressions, so I started reading *"Mastering Regular Expressions"*. I have two books to read before picking up the compiler book again.

Got a full list of English words and the full works of Shakespeare to practice RegEx.

---

## June 14, 2026

Got the book from eBay; currently reading Chapter 1.  
Wrote the compiler driver.  
Wrote the lexer using Gemini, but decided to not use LLMs. Deleted the code and am starting it completely from scratch.

---

## May 23, 2026

Installed `ksh93` on my OpenBSD computer for writing the compiler. OpenBSD comes with `pdksh` (Public Domain Korn Shell), which lacks features that I need.

---

## May 19, 2026

Got the Korn shell book from eBay; reading that now.

