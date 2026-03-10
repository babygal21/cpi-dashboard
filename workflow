name: Update CPI dashboard

on:
  schedule:
    - cron: "0 7 * * *"
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Setup R
        uses: r-lib/actions/setup-r@v2

      - name: Install packages
        run: |
          Rscript -e 'install.packages(c("rvest","dplyr","readr","ggplot2"))'

      - name: Setup Quarto
        uses: quarto-dev/quarto-actions/setup@v2

      - name: Render dashboard
        run: quarto render finalproj.qmd

      - name: Commit updates
        run: |
          git config --local user.email "action@github.com"
          git config --local user.name "GitHub Action"
          git add .
          git commit -m "Daily update" || echo "No changes"
          git push
