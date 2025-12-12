# Kaekae Songbook Blueprint

## Overview

Kaekae Songbook is a Flutter application designed for managing and displaying a collection of song lyrics with guitar chords. It allows users to create, read, update, and delete songs, and provides a simple and intuitive interface for viewing and searching for songs.

## Features

*   **User Authentication:** Secure sign-in with Google to ensure that only authorized users can manage the songbook.
*   **Song Management:**
    *   Add new songs with title, artist, lyrics, and optional YouTube links.
    *   Edit existing songs to update their details.
    *   Delete songs that are no longer needed.
*   **Song Display:**
    *   A filterable list of all songs, searchable by title or artist.
    *   A detail view for each song, with a custom renderer that displays chords in a distinct and easy-to-read format.
*   **Navigation:** A clear and intuitive routing system using `go_router` for seamless navigation between screens.
*   **Theming:**
    *   Support for both light and dark modes.
    *   A theme toggle to allow users to switch between modes.
*   **Firebase Integration:**
    *   Firestore is used as the backend database to store and manage the song collection.
    *   Firebase Authentication handles user sign-in and session management.

## Design and Styling

*   **Layout:** A clean and modern interface with a focus on readability and ease of use.
*   **Typography:** Clear and legible fonts for song titles, artists, and lyrics.
*   **Color Scheme:** A simple and effective color palette that works well in both light and dark modes, with chords highlighted for easy identification.

## Current Plan

This blueprint serves as a snapshot of the application's state. The current implementation reflects the features and design outlined above. There are no pending changes at this time.
