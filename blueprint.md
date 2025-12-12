# Kaekae Songbook App - The Visionary Blueprint

## 1. The Grand Vision: A Global Music Collaboration Platform

Our goal is to build an indispensable, world-class application for musicians, songwriters, and music lovers across the globe, with a special focus on regions like Southeast Asia where access to such tools is limited. This platform will be a treasure trove of lyrics and chords, but more importantly, a vibrant social and collaborative ecosystem. It will empower creators to share their work, allow users to learn and play, and enable a community to collectively refine musical knowledge. We are not just building an app; we are building the definitive social network for grassroots music creation and appreciation.

## 2. Architectural & Design Pillars

*   **Social & Collaborative Core:** The app's heart is its community. Every feature is designed to encourage interaction, from commenting and voting to the unique collaborative "Re-Edit" system. The user feed will be driven by a sophisticated, Facebook-style algorithm.
*   **Intuitive Creation & Customization:** Song creation will be powerful yet simple, using an intuitive `[Chord]` syntax. The viewing experience will be highly customizable, allowing users to tailor everything from fonts and colors to backgrounds, ensuring a personal and accessible experience.
*   **Scalable & Maintainable Architecture:** The codebase will be impeccably organized using a feature-first, layered architecture. We will use `go_router` for navigation, `provider` for state management, and a full Firebase backend (Firestore, Firebase Auth, Firebase Storage, and Cloud Functions) to ensure scalability, real-time updates, and security. The code will be structured like an "adaptor," allowing for easy modification and expansion.
*   **Security & Privacy First:** User data and content ownership are paramount. We will implement robust security measures and give users granular control over the privacy of their content.
*   **API-First Mentality:** From the outset, we will design the system with a future public API in mind, enabling developers to build upon our platform and embed song content across the web.

## 3. Detailed Feature Breakdown

### **Phase 1: The Core Experience (MVP)**

1.  **Onboarding & Authentication:**
    *   **UI:** A beautiful welcome screen.
    *   **Functionality:**
        *   One-tap sign-up/login with Google and Facebook via Firebase Auth.
        *   A "Continue as Guest" option with limited functionality (searching/viewing a few public songs).
        *   Prompt to register/login for advanced features like commenting or creating.

2.  **Song Creation & Rendering:**
    *   **UI:** A clean, intuitive editor screen.
    *   **Functionality:**
        *   Input fields for Title, Artist, Original Key, and Tempo.
        *   A main text area for lyrics and chords using the `[G]Your [C]Lyrics` format.
        *   A live preview or toggle to see how the rendered song will look.
        *   **Smart Renderer:** A widget that correctly parses and displays chords *above* the corresponding syllable. This renderer must be intelligent enough to handle font size changes, line wraps, and maintain perfect chord-lyric alignment.

3.  **Song Viewing Experience:**
    *   **UI:** A dedicated screen for viewing a song.
    *   **Functionality:**
        *   Display song metadata (Title, Artist, Key).
        *   Render lyrics and chords using the Smart Renderer.
        *   **Chord Transposition:** Simple `+` and `-` buttons to transpose all chords in the song up or down. The underlying logic will handle all key conversions (e.g., G -> G#, A -> Bb).

4.  **Basic Home & Search:**
    *   **UI:** A simple home screen.
    *   **Functionality:**
        *   A search bar to find songs by title or artist from a pre-defined list of public songs.
        *   A list view to display search results.

### **Phase 2: Building the Social Foundation**

1.  **The Algorithmic Feed:**
    *   **UI:** The home screen evolves into a dynamic, infinite-scrolling feed.
    *   **Functionality:**
        *   Display song posts from followed creators, trending songs, and suggestions.
        *   The algorithm (initially simple, later complex) will be managed by Cloud Functions.
        *   Intersperse "Suggested Creator" posts within the feed.

2.  **Post Interactions:**
    *   **UI:** Buttons on each post for Like, Comment, Share, and Save.
    *   **Functionality:**
        *   **Like:** Real-time update on the post's like count.
        *   **Comment:** Open a view to see comments and add new ones. Allow replies to comments.
        *   **Share:** Save a song to the user's own profile wall.
        *   **Save:** Save a song to a private "My List" for later viewing.

3.  **User Profiles:**
    *   **UI:** A profile page for each user.
    *   **Functionality:**
        *   Display user's name, profile picture, and a list of their created/shared songs.
        *   Follow/Unfollow button.

### **Phase 3: Collaboration & Advanced Customization**

1.  **The "Re-Edit" System:**
    *   **UI:** A "Re-Edit" button on every song post.
    *   **Functionality:**
        *   Allows a user to propose corrections (lyrics or chords) to another user's song.
        *   The submission is saved as a "pending edit."
        *   Other users (or certified editors) can vote on these pending edits.
        *   If an edit receives enough positive votes, the original post is updated, and the contributor is credited.

2.  **Advanced Viewing Customization:**
    *   **UI:** A settings panel on the song view screen.
    *   **Functionality:**
        *   **Text/Chord Styling:** Sliders and color pickers to adjust font size, font family, color, and add effects like highlights or shadows.
        *   **Backgrounds:** Allow users to select a background from a curated list (colors, gradients, images) or upload their own from their device's gallery.

3.  **Content Privacy & Notifications:**
    *   **Functionality:**
        *   When creating a song, allow users to set privacy: `Public`, `Followers`, `Friends`, `Only Me`.
        *   Implement a full notification system (using Cloud Functions and Firestore) to alert users of likes, comments, re-edits, votes, and new followers.

### **Phase 4: Platform Expansion**

1.  **Offline Sync:**
    *   **Functionality:**
        *   Use a local database (like a file or a simple mobile DB) to store songs created while offline.
        *   When the app comes online, a background service automatically syncs the local songs with the Firestore database.

2.  **Public API:**
    *   **Functionality:**
        *   Develop and document a REST or GraphQL API.
        *   Provide API keys for developers.
        *   Create a simple embeddable web component, so a developer can show a song on their website with just a single line of HTML/JS.

3.  **Monetization & Roles:**
    *   **Functionality:**
        *   Introduce user roles: `Creator`, `Editor`, `Supporter`.
        *   Explore potential monetization strategies that reward top creators.

This blueprint will serve as our living document, guiding every step of the development process. We will begin with **Phase 1** to build a strong, functional core before layering on the more complex social and collaborative features.
