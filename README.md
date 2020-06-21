# Bûllets

## Slide Show meets Game Engine

![](docs/bullets-start.png)

### Check out the [demo presentation](https://renerocksai.github.io/bullets/bullets.html)!

### See how you can start playing with it on [youtube](https://www.youtube.com/watch?v=PSlo6nRRmZM)!

This software is so **fresh**, it's currently in usable alpha!

1. [What is Bûllets?](#what-is-bûllets)
2. [How To](#how-to)  
2.1 [How to create your first presentation](#how-to-create-your-first-presentation)  
2.2 [How to export to PDF](#how-to-export-to-pdf)

## What is Bûllets? 

- Bûllets is a slide show software powered by the 
    **Godot game engine**

- It helps you create beautiful presentations on all 
    platforms (Windows, Mac, Linux, and the web) that are 100% 
    self-contained  and will look and feel the same on all 
    platforms

- Using plain text with optional easy markup for 
    content makes slide creation a breeze
    - this is how you enter bullet lists
    - ![](docs/edittext.png)
    - and to the right you see how you can customize the appearance of typical slide elements like title, page numbers, etc.
    - ![](Bullets/img/godotscr2.png)
- If you know how to code, you can create the most 
    complex, interactive animations, with sound effects -
    or even embed a full game into your slides.
    - ![](docs/gametime.png)

- You can share Bûllets presentations either as native 
    programs or publish them to the web
    - Like this [first demo](https://renerocksai.github.io/bullets/bullets.html)!

- PDF export is supported, too
    - Web-exported Bûllets can directly create PDF and download presentations from your slides - right in the browser!
        - All you have to do is: press `<P>`
    - Native Bûllets executables can create PNG images from your slides
        - a small browser tool converts the PNG slides to PDF
        - the conversion happens locally in the browser, no upload is required

- Bûllets presentations are version control friendly and 
    allow for GitHub collaboration

- And yes, it works with your favorite wireless clicker!
	- Even if that happens to be your  XBOX controller :sunglasses:
	- It **even comes with a laser pointer!**
	    - ![](docs/laserpoint.png)
	- You can **draw on slides**, too!
	    - ![](docs/drawmode.png)
- It is a proof-of-concept and a work in progress

- It is also a hack

## How to...

### How to create your first presentation
It only takes 15 minutes, including downloading Godot. Watch it on [youtube](https://www.youtube.com/watch?v=PSlo6nRRmZM)!

### How to export to PDF

#### The easy way: from the web exoport
- Run your presentation in the browser, after a web export
- Go to the first slide
- Press `<P>`
- You're done!
    - Bûllets will iterate over all slides and create PDF pages in the background
    - At the last slide, the PDF download will start automatically
    
Note: The conversion will happen purely in your browser via JavaScript. Your slides will not be uploaded to any server for conversion.

*Technical note:* Initially I had added a version that would transfer a snapshot of each slide as a base64-encoded array of pixels to JavaScript for PDF creation via a HTML5 canvas. The amount of data to transfer was huge. I abandoned this approach in favor of transferring a base64-encoded PNG image. However, rendering PNGs into buffers is only supported from Godot 3.2.2 onwards, which is currently available only as a release candidate. As soon as it comes out (any day now!), this will work with the standard, stable Godot from its download page. In the meantime you can fall back to the native approach below. If you can't wait, however, just download RC2 from the [dev snapshots](https://downloads.tuxfamily.org/godotengine/3.2.2/rc2/).

#### The native way
- Run your presentation from the Godot Editor (not the web version).
- Press the `<P>` key
- The slideshow will now iterate over all slides and create a .PNG image for each
- Locate `pdfstuff/browser/index.hml` from your Bûllets folder and double-click it to open it in your browser
    - This is what it will look like:
    - ![](docs/convert.png)
- Click the _Choose Files_ button
- Select all the generated PNG slides
- Click _Open_
- Done, the PDF will be "downloaded" as `result.pdf` instantly

Note: The conversion will happen purely in your browser via JavaScript. Your slides will not be uploaded to any server for conversion.
	
