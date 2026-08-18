# Data Science Basic


This is the repository used for the Data Science Basic Workshops given in 2022. 
The content of the workshop is in the following folders:

- 01-what-is-data-science-r
- 02-working-with-r-markdown
- 03-importing-data
- 04-data-wrangling
- 05-data-visualization
- 06-case-study


In each of these folders, apart from the `/01-what-is-data-science-r` one, you will can find an `.Rmd` file with the content of the session together with an `/exercise` folder that includes the exercises that we are going to do during the workshop. 


In this workshop, we are going to use R and RStudio. To start a new session click on "Start" at the top of this page.

## How to save your work at end of the workshop

In order to permanently save your work on Renku, you would need to use some git commands. 
Go into the `terminal` tab (next to the console) and type the following commands

```
git add .
git commit -m "update exercises" --no-verify
git push
```

This will make sure that you take a snapshot of the latest version of the files you have saved (commit), and that you send (push) this latest version to Gitlab, which is where your repository is stored
