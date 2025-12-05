# Mini-Trello

A lightweight, feature-rich task management application inspired by Atlassian Trello. Built with Ruby on Rails, Mini-Trello provides an intuitive drag-and-drop interface for organizing tasks across boards, lists, and cards.

## Features

- **User Authentication**: Secure user registration and login powered by Devise
- **Board Management**: Create and organize multiple boards for different projects
- **List Organization**: Add multiple lists within each board to categorize tasks
- **Card System**: Create and manage task cards with titles, descriptions, and completion status
- **Drag & Drop**: Seamlessly move cards within lists, across lists, or between lists and inbox
- **Inbox System**: Personal card inbox for tasks not yet assigned to a specific list
- **Inline Editing**: Edit board, list, and card names without page reloads
- **Modal Card View**: View and edit card details in an elegant modal interface
- **Card Movement**: Manually move cards between boards and lists
- **Responsive Design**: Modern, clean interface styled with Tailwind CSS

## Architecture

Mini-Trello is built around four core components:

1. **User** - Manages authentication and owns boards and cards
2. **Board** - Container for organizing lists and cards
3. **List** - Organizes cards within a board
4. **Card** - Individual task items with titles, descriptions, and completion status

### Data Relationships

```
User
 ├── has_many :boards
 └── has_many :cards (polymorphic: inbox cards)

Board
 ├── belongs_to :user
 └── has_many :lists

List
 ├── belongs_to :board
 └── has_many :cards (polymorphic)

Card
 └── belongs_to :owner (polymorphic: User or List)
```

Cards can belong to either a **User** (inbox) or a **List** (organized), implemented through Rails polymorphic associations.

## Getting Started

### Prerequisites

- Ruby 3.4.7
- Rails 8.1.0
- Rack 3.2.3
- SQLite3 (development)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/DahliaGhonim/Mini_Trello.git
   cd Mini_Trello
   ```

2. **Install dependencies**
   ```bash
   bundle install
   ```

3. **Set up the database**
   ```bash
   bin/rails db:migrate
   ```

4. **Start the development server**
   ```bash
   bin/dev
   ```

5. **Access the application**
   
   Open your browser and navigate to:
   ```
   http://localhost:3000
   ```

You'll be redirected to the sign-in page. Create a new account to get started!

### Alternative Setup Guide

If you need to set up a complete Rails development environment, follow this comprehensive guide:
[How to Install Ruby on Rails with rbenv on Ubuntu 20.04](https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-ubuntu-20-04)

## Usage Guide

### Getting Started

1. **Create an Account**: Register with your email and password
2. **Create Your First Board**: Click "New Board" on the boards index page
3. **Add Lists**: Within a board, click "Add a list" to create organizational categories
4. **Add Cards**: Click "Add a card" within any list or in the inbox to create tasks

### Board Management

**Boards Index View**
- View all your boards in one place
- Create new boards (name required)
- Click on a board name to open it

**Board Show View**
- Add multiple lists for task organization
- Edit board name by clicking on it
- Delete board from the navbar
- Access boards index from the navbar

### Working with Lists

- **Create Lists**: Click "Add a list" within a board
- **Edit List Names**: Click directly on the list name
- **Delete Lists**: Click the delete icon on the list
- **Add Cards**: Use the "Add a card" button within any list

### Managing Cards

**Quick Actions**
- **Toggle Completion**: Check/uncheck the done status checkbox
- **Drag & Drop**: Move cards within a list, between lists, or to/from the inbox
- **Edit Title**: Click the edit icon next to the card title
- **View Details**: Click the card title to open the modal view
- **Delete Card**: Click the delete icon

**Card Detail View (Modal)**
- Edit card title inline
- Add or update card description
- Toggle completion status
- Manually move card to different lists or boards
- Move card back to inbox

### The Inbox

The inbox is your personal holding area for cards that don't yet belong to a specific list. Cards in the inbox belong directly to you (the user) rather than to a list.

- Add cards directly to your inbox from any board view
- Drag cards from the inbox to any list
- Organize inbox cards before assigning them to projects

### Permissions

- All boards, lists, and cards are private to authenticated users
- You can only access and modify your own content

## 🛠️ Technical Stack

### Core Technologies

- **Framework**: Ruby on Rails 8.1.0
- **Language**: Ruby 3.4.7
- **Database**: SQLite3 (development), PostgreSQL-ready for production
- **CSS Framework**: Tailwind CSS
- **JavaScript**: Hotwire (Turbo + Stimulus)

### Key Gems & Libraries

| Technology | Purpose | Documentation |
|------------|---------|---------------|
| [Devise](https://github.com/heartcombo/devise) | User authentication and session management | [Docs](https://github.com/heartcombo/devise) |
| [acts_as_list](https://github.com/brendon/acts_as_list) | Position management for sortable cards | [Docs](https://github.com/brendon/acts_as_list) |
| [Tailwind CSS](https://tailwindcss.com/) | Utility-first CSS styling | [Docs](https://tailwindcss.com/docs) |
| [SortableJS](https://github.com/SortableJS/Sortable) | Drag-and-drop functionality | [Docs](https://github.com/SortableJS/Sortable) |

### Advanced Features Implementation

#### Polymorphic Associations
Cards can belong to either a User (inbox) or a List, implemented using Rails polymorphic associations:
```ruby
# Card model
belongs_to :owner, polymorphic: true

# User model
has_many :cards, as: :owner

# List model
has_many :cards, as: :owner
```

[Rails Polymorphic Associations Guide](https://guides.rubyonrails.org/association_basics.html#polymorphic-associations)

#### Hotwire (Turbo Frames & Streams)
Real-time UI updates without full page reloads:
- **Turbo Frames**: Inline editing of boards, lists, and cards
- **Turbo Streams**: Dynamic updates when creating, updating, or deleting items

#### Stimulus Controllers

**Sortable Controller** (`app/javascript/controllers/sortable_controller.js`)
- Manages drag-and-drop functionality
- Integrates SortableJS with Rails backend
- Updates card positions via AJAX

**Modal Controller** (`app/javascript/controllers/modal_controller.js`)
- Opens card details in a modal overlay
- Handles modal show/hide animations
- Integrates with Turbo Frames for seamless loading

**Move Card Controller** (`app/javascript/controllers/move_card_controller.js`)
- Enables manual card movement between lists and boards
- Updates card ownership (User or List)
- Provides dropdown interface for destination selection

## Project Structure

```
Mini_Trello/
├── app/
│   ├── controllers/        # Request handling
│   ├── models/            # Data models
│   ├── views/             # HTML templates
│   └── javascript/        # Stimulus controllers
├── config/                # Application configuration
├── db/                    # Database schema & migrations
└── spec/                  # RSpec test files
```

## Testing

This project uses RSpec for testing. To run the test suite:

```bash
rspec spec
```
