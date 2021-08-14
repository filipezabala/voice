# `voice`

<!-- badges: start -->
[![R build status](https://github.com/filipezabala/voice/workflows/R-CMD-check/badge.svg)](https://github.com/filipezabala/voice/actions?workflow=R-CMD-check)
<!-- badges: end -->

General tools for voice analysis. The `voice` package is being developed to be an easy-to-use set of tools to deal with audio analysis in R.  
It is based on [`tidyverse`](https://www.tidyverse.org/) collection, [`tuneR`](https://cran.r-project.org/web/packages/tuneR/index.html), [`wrassp`](https://cran.r-project.org/web/packages/wrassp/index.html), as well as [Parselmouth](https://github.com/YannickJadoul/Parselmouth) - a Python library for the [Praat](http://www.praat.org/) software - and [pyannote-audio](https://github.com/pyannote/pyannote-audio) - an open-source toolkit written in Python for speaker diarization based on [PyTorch](https://github.com/pytorch/pytorch) machine learning framework.  
A vignette is found at http://filipezabala.com/voicegnette/.

## MacOS Installation
The following steps were used to configure [github.com/filipezabala/voice](https://github.com/filipezabala/voice) on [MacOS Big Sur](https://www.apple.com/macos/big-sur/). Note the software versions during installation, inconsistency reporting is welcome.  
If the error "The package %@ is missing or invalid" appears during the upgrading from MacOS Catalina to Big Sur, press simultaneously `command + option + p + r` at restart. The processes may be accompanied using the keys `command + space 'Activity Monitor'`.    
> Without the following Python items 3 and 10, you may run all the functions except `poetry` and `extract_features_py`, that run respectively [pyannote-audio](https://github.com/pyannote/pyannote-audio) and [Parselmouth](https://github.com/YannickJadoul/Parselmouth).

Hardware  
 . MacBook Air (13-inch, 2017)  
 . Processor 1.8 GHz Dual-Core Intel Core i5  
 . Memory 8GB 1600 MHz DDR3  
 . Graphics Intel HD Graphics 6000 1536 MB  

### 1. [Homebrew](https://brew.sh/)
Install Homebrew, 'The Missing Package Manager for macOS (or Linux)' and remember to `brew doctor` eventually. At terminal (`command + space 'terminal'`) run:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
sudo chown -R $(whoami) /usr/local/lib/pkgconfig /usr/local/share/info /usr/local/share/man/man3 /usr/local/share/man/man5
chmod u+w /usr/local/lib/pkgconfig /usr/local/share/info /usr/local/share/man/man3 /usr/local/share/man/man5
```

### 2. [wget](https://www.gnu.org/software/wget/)
GNU Wget is a free software package for retrieving files using HTTP, HTTPS, FTP and FTPS, the most widely used Internet protocols. It is a non-interactive commandline tool, so it may easily be called from scripts, cron jobs, terminals without X-Windows support, etc.

```bash
brew install wget
```

### 3. [Python](https://www.python.org/)
Python is a programming language that integrate systems. According to [this](https://github.com/Homebrew/homebrew-core/issues/62911) post, it is recommended to install Python 3.8 and 3.9 and make it consistent.

```bash
brew install python@3.8
brew install python@3.9
brew unlink python@3.9
brew unlink python@3.8
brew link python@3.8
python3 --version 
pip3 --version
```

### 4. [ffmpeg](http://ffmpeg.org/)
ffmpeg is a cross-platform solution to record, convert and stream audio and video. The installation may take several minutes.

```bash
brew install ffmpeg
```

### 5. [XQuartz](www.xquartz.org)
 . Download and run https://github.com/XQuartz/XQuartz/releases/download/XQuartz-2.8.1/XQuartz-2.8.1.dmg  
 . Will take 319.2 MB of disk space   
 . Send XQuartz-2.8.1.dmg to Trash    

### 6. [bwidget](http://sourceforge.net/projects/tcllib/files/)
 . Download https://sourceforge.net/projects/tcllib/files/latest/download  

```bash
cd ~/Downloads
tar -xf bwidget-1.9.14.tar.gz
mv bwidget-1.9.14 /usr/local/lib/bwidget-1.9.14
```

### 7. [R](https://www.r-project.org)
R is a free software environment for statistical computing and graphics.  
 . Download and run https://cloud.r-project.org/bin/macosx/base/R-4.1.0.pkg   
 . Will take 174.8 MB of disk space   
 . Send R-4.1.0.pkg to Trash   

### 8. [RStudio](https://www.rstudio.com/)
RStudio is an integrated development environment (IDE) for R.  
 . Download and run https://download1.rstudio.org/desktop/macos/RStudio-1.4.1717.dmg  
 . Drag RStudio to Applications folder   
 . Will take 768.4 MB of disk space   
 . Unmount RStudio virtual disk and send RStudio-1.4.1717.dmg to Trash   
 . Type `command + space 'rstudio'`   
 . Tools > Global Options... > Appearance > Merbivore (Restart required)   

### 9. [R packages](https://cran.r-project.org/web/packages/)
"Packages are the fundamental units of reproducible R code." [Hadley Wickham and Jennifer Bryan](https://r-pkgs.org/). Type `command + space 'terminal'`   
 
```bash
sudo R
```

Running R as super user paste the following, row by row:
```r
ini <- Sys.time()
packs <- c('devtools', 'e1071', 'ellipse', 'ggfortify', 'gm', 'RColorBrewer', 'reticulate', 'R.utils', 'seewave', 'tidyverse', 'tuneR', 'VIM', 'wrassp')
install.packages(packs, dep = T); Sys.time()-ini
update.packages(ask = F); Sys.time()-ini
devtools::install_github('egenn/music'); Sys.time()-ini
devtools::install_github('filipezabala/voice', force = T); Sys.time()-ini
```

### 10. [Miniconda](https://docs.conda.io/en/latest/miniconda.html)
Miniconda is a free minimal installer for [conda](https://docs.conda.io/), an open source package, dependency and environment management system for any language—Python, R, Ruby, Lua, Scala, Java, JavaScript, C/ C++, FORTRAN and more, that runs on Windows, macOS and Linux.

```bash
cd ~/Downloads
wget -r -np -k https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh
cd repo.anaconda.com/miniconda/
bash Miniconda3-latest-MacOSX-x86_64.sh
conda create -n pyvoice38 python=3.8
conda activate pyvoice38
pip3 install -r https://raw.githubusercontent.com/filipezabala/voice/master/requirements.txt
```

### 11. [MuseScore](https://musescore.org/)
MuseScore is an open source notation software.  
 . Download and run https://musescore.org/en/download/musescore.dmg  
 . Drag MuseScore 3 to Applications folder   
 . Will take 314 MB of disk space   
 . Unmount MuseScore-3.6.2 virtual disk and send MuseScore-3.6.2.548020600.dmg to Trash   
