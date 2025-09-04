#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status.

echo "--- Installing dependencies ---"
bundle install

echo "--- Building website ---"
bundle exec jekyll build

echo "--- Checking for issues ---"
bundle exec htmlproofer ./_site --disable-external

echo "--- All checks passed! ---"
