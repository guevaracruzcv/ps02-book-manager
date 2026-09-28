# Personal Book Manager

A small modular command-line application for managing a personal book library and generating personalized recommendations.

This project was developed for Problem Set 02 and demonstrates Bash programming, modular architecture, pipes, parallelization, synchronization, streaming/progress, Gum, and simple multi-strategy recommendation workflows.

## What the Application Does

The Personal Book Manager allows the user to:

- browse a personal book library
- search books by title, author, genre, or keyword
- add books to persistent storage
- enrich basic book information with metadata
- generate recommendations using three different strategies
- run recommendation strategies in parallel
- combine, validate, deduplicate, and refine recommendation results
- interact through a terminal interface built with Gum

## How to Run

### Requirements

- Bash
- Gum

From the project directory:

```bash
chmod +x app.sh
./app.sh
```

The application opens an interactive menu with:

```text
Browse Library
Search Library
Add Book
Get Recommendations
Quit
```

## Architecture

The application follows a modular architecture in which each layer has a clear responsibility:

```text
User
 ↓
app.sh
 ↓
UI Layer
 ↓
Workflow Layer
 ↓
Book / Recommendation Components
 ↓
Data Layer
 ↓
Persistent Storage
```

The project structure is:

```text
book-manager/
│
├── app.sh
│
├── ui/
│   ├── main_menu.sh
│   ├── library_screen.sh
│   └── recommendations_screen.sh
│
├── workflows/
│   ├── manage_library.sh
│   └── get_recommendations.sh
│
├── books/
│   ├── fetch_book_metadata.sh
│   └── search_books.sh
│
├── recommendations/
│   ├── recommend_from_history.sh
│   ├── recommend_from_interests.sh
│   ├── recommend_for_discovery.sh
│   └── refine_recommendations.sh
│
└── data/
    ├── book_database.sh
    ├── books.csv
    └── interests.txt
```

`app.sh` is the entry point. The UI layer handles interaction and presentation. Workflows coordinate operations without directly manipulating storage. Specialized components perform book and recommendation tasks. `book_database.sh` provides the abstraction boundary for access to `books.csv`.

## Recommendation Workflow

The recommendation workflow uses three independent strategies:

```text
                    ┌── History Agent
                    │
User Context ───────┼── Interests Agent
                    │
                    └── Discovery Agent
                             ↓
                         Aggregate
                             ↓
                          Refine
                             ↓
                         Shortlist
```

The three recommendation programs run concurrently using Bash background processes:

```text
&
$!
wait
```

Their outputs are stored independently, synchronized, combined, deduplicated, checked against the existing library, and passed through the refinement component.

The aggregation policy preserves different perspectives:

```text
History    → up to 3 candidates
Interests  → up to 3 candidates
Discovery  → up to 2 candidates
```

The final shortlist may contain fewer than eight books if duplicates or books already present in the library are removed.

## Personalization

The application reflects my interests in technology, artificial intelligence, digital governance, public-sector innovation, development, leadership, and discovery.

Personalization is separated from the program logic where possible. Declared interests are stored in:

```text
data/interests.txt
```

while observed reading patterns come from:

```text
data/books.csv
```

The three recommendation strategies intentionally use different perspectives:

- **History** uses patterns already present in the library.
- **Interests** uses explicitly declared interests and goals.
- **Discovery** introduces topics outside the existing reading pattern.

This creates a simple balance between exploitation of known preferences and exploration of new areas.

## Data Flow

A typical library operation follows:

```text
User Input
    ↓
UI
    ↓
Workflow
    ↓
Specialized Component
    ↓
Data Layer
    ↓
books.csv
```

A recommendation operation follows:

```text
User Request
    ↓
Recommendation Workflow
    ↓
Parallel Agents
    ↓
Synchronization
    ↓
Balanced Aggregation
    ↓
Validation and Refinement
    ↓
Recommendation Screen
```

## Technical Concepts Demonstrated

The project demonstrates:

- small Bash programs
- modular architecture
- command-line arguments
- functions and exit status
- `stdin`, `stdout`, and `stderr`
- pipes
- redirection
- background processes
- process IDs
- synchronization with `wait`
- temporary files
- input normalization
- data validation
- duplicate detection
- Gum terminal UI
- separation of concerns

## Environment Notes

The project was developed on Windows using Git Bash.

During development, several environment-related issues illustrated the importance of validating assumptions at system boundaries, including:

- Windows `CRLF` versus Unix `LF` line endings
- hidden carriage-return characters (`^M`)
- path differences between Windows, Git Bash, macOS, and Linux
- CSV delimiter collisions when user data contains commas
- files whose final record does not end with a newline

The implementation therefore includes simple normalization and defensive handling for these cases.

## Demo

A short narrated demonstration will show:

1. browsing and searching the library
2. adding or inspecting a book
3. generating recommendations from the three parallel strategies

Demo video: **[https://1drv.ms/v/c/a6a91cb71160b1a9/IQCxM9hrxX5JSoM0FHW9jyREAf6EuNbipPzZL-U9cgFuSMY?e=xVrrOH]**