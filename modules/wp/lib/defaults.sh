#!/bin/bash
#
# WordPress Defaults lib
# Author: Troy McGinnis
# Company: Gearbox
# Updated: May 1, 2017
#

wp::defaults() {
  # Create pages
  wp post create --post_type=page --post_title='Home' --post_status=publish #--page_template='template-home.php'
  wp post create --post_type=page --post_title='Blog' --post_status=publish
  wp post create --post_type=page --post_title='Contact' --post_status=publish --page_template='template-contact.php'

  # Delete pages/posts
  wp post delete 1 --force
  wp post delete 2 --force

  message "Setting up menus..."
  wp menu create "Primary Navigation"
  wp menu location assign primary-navigation primary_navigation
  wp menu item add-post primary-navigation 3
  wp menu item add-post primary-navigation 4
  wp menu item add-post primary-navigation 2
  wp menu item add-post primary-navigation 5

  message "Setting up static pages..."
  wp option update page_on_front 3
  wp option update show_on_front page
  wp option update page_for_posts 4
  wp option update permalink_structure "/%postname%/"
  wp rewrite flush --hard

  message "General setup stuff..."
  wp option update timezone_string America/Vancouver

  # Import Images
  message "Importing media..."
  for i in $(seq 1 10); do
    printf "Downloading and importing image %s...\n" "${i}"
    curl -sL -o "$WP_RANDOM_IMAGE_FILE_NAME" "$WP_RANDOM_IMAGE_SOURCE_FILE"
    wp media import "$WP_RANDOM_IMAGE_FILE_NAME"
    rm "$WP_RANDOM_IMAGE_FILE_NAME"
  done

  # Import content page
  message "Importing general content page..."
  wp plugin install wordpress-importer --activate
  curl -sO "$WP_GENERAL_CONTENT_SOURCE_FILE"
  wp import "$WP_GENERAL_CONTENT_FILE_NAME" --authors=skip
  rm "$WP_GENERAL_CONTENT_FILE_NAME"
}