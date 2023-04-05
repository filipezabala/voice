# `voice`

<!-- badges: start -->
[![R build status](https://github.com/filipezabala/voice/workflows/R-CMD-check/badge.svg)](https://github.com/filipezabala/voice/actions?workflow=R-CMD-check)
<!-- badges: end -->

General tools for voice analysis. The `voice` package is being developed to be an easy-to-use set of tools to deal with audio analysis in R.  
It is based on [`wrassp`](https://cran.r-project.org/package=wrassp), [`tuneR`](https://cran.r-project.org/package=tuneR), [`seewave`](https://cran.r-project.org/package=seewave), [`gm`](https://cran.r-project.org/package=gm), as well as [Parselmouth](https://github.com/YannickJadoul/Parselmouth) - a Python library for the [Praat](https://www.fon.hum.uva.nl/praat/) software - and [pyannote-audio](https://github.com/pyannote/pyannote-audio) - an open-source toolkit written in Python for speaker diarization based on [PyTorch](https://github.com/pytorch/pytorch) machine learning framework.   

More details may be found at https://cran.r-project.org/package=voice.  

## Ubuntu Installation
The following steps were used to configure [github.com/filipezabala/voice](https://github.com/filipezabala/voice) on [Ubuntu 20.04 LTS (Focal Fossa)](https://releases.ubuntu.com/20.04/). Note the software versions during installation, inconsistency reporting is welcome.  
> Without the following Python items 3 and 10, you may run all the functions except `poetry` and `extract_features_py`, that run respectively [pyannote-audio](https://github.com/pyannote/pyannote-audio) and [Parselmouth](https://github.com/YannickJadoul/Parselmouth).

### 1. [Curl](https://curl.se/)
Command line tool and library for transferring data with URLs. Find the latest version at https://curl.se/download.html. At terminal run:
```bash
# removing (if necessary) old curl installation
sudo apt remove curl
sudo apt purge curl
# removing (if necessary) the /cdrom folder
sudo sed -i '/cdrom/d' /etc/apt/sources.list
# installing dependencies
sudo apt-get update
sudo apt-get install -y libssl-dev autoconf libtool make
cd /usr/local/src
rm -rf curl*
# downloading latest version (check before install!)
sudo wget https://curl.se/download/curl-7.81.0.zip
sudo unzip curl-7.81.0.zip
cd curl-7.81.0
sudo apt-get install autoconf
sudo autoreconf -fi
sudo ./configure --with-ssl 
sudo make
sudo make install
# update the system’s binaries and symbol lookup
sudo cp /usr/local/bin/curl /usr/bin/curl
curl -V
```
You may take a look at [this](https://serverfault.com/questions/503555/libcurl-reporting-different-version-between-commands) post if you have a message like `WARNING: curl and libcurl versions do not match. Functionality may be affected.`

### 2. [Git](https://git-scm.com/)
Git is a free and open source distributed version control system.
```bash
sudo apt-get update
sudo apt-get install git-all
```

### 3. [pip](https://pypi.org/project/pip/)
pip is the package installer for Python. 
```bash
sudo apt-get update
sudo apt-get install python3-pip
pip3 --version
```

### 4. [ffmpeg](https://ffmpeg.org/)
ffmpeg is a cross-platform solution to record, convert and stream audio and video.
```bash
sudo apt-get update
sudo apt-get install ffmpeg
```

### 5. Audio drivers, extra packages and some cleaning
```bash
sudo apt-get update
sudo apt-get install portaudio19-dev libasound2-dev libfontconfig1-dev libmagick++-dev libxml2-dev libharfbuzz-dev libfribidi-dev libgdal-dev
sudo rm -Rf /usr/local/lib/R/site-library/00LOCK-digest

sudo apt-get update
sudo apt-get install cmake cmake-doc ninja-build
```

### 6. [MuseScore](https://musescore.org/)
MuseScore is an open source notation software.  
```bash
sudo add-apt-repository ppa:mscore-ubuntu/mscore-stable
sudo apt-get update
sudo apt-get install musescore
```

### 7. [R](https://www.r-project.org)
R is a free software environment for statistical computing and graphics. To find out your Ubuntu distribution use `lsb_release -a` at terminal.    
```bash
sudo sh -c 'echo "deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/" >> /etc/apt/sources.list.d/cran.list'
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9 
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 51716619E084DAB9
gpg -a --export E084DAB9 | sudo apt-key add -

sudo add-apt-repository ppa:c2d4u.team/c2d4u4.0+

sudo apt-get update && sudo apt-get upgrade
sudo apt-get install r-base
sudo apt-get install r-base-dev
```

### 8. [RStudio Server](https://posit.co/)
RStudio is an Integrated Development Environment (IDE) for R. Check for updates [here](https://posit.co/download/rstudio-server/).
```bash
sudo apt-get update
sudo apt-get install gdebi-core
wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-2021.09.2-382-amd64.deb
sudo gdebi rstudio-server-2021.09.2-382-amd64.deb
```

### 9. R packages
"Packages are the fundamental units of reproducible R code." [Hadley Wickham and Jennifer Bryan](https://r-pkgs.org/). The installation may take several minutes. At terminal run:
```bash
sudo R
```

Running R as super user paste the following, row by row:
```r
ini <- Sys.time()
packs <- c('audio','BART','devtools','e1071','ellipse','foreach','ggfortify','RColorBrewer','reticulate','R.utils','seewave','tidyverse','tuneR','VIM','voice','wrassp')
install.packages(packs, dep = T); Sys.time()-ini
update.packages(ask = F); Sys.time()-ini
devtools::install_github('egenn/music'); Sys.time()-ini
devtools::install_github('flujoo/gm'); Sys.time()-ini
url <- 'http://www.rob-mcculloch.org/chm/nonlinvarsel_0.0.1.9001.tar.gz'
download.file(url, destfile = 'temp')
install.packages('temp', repos = NULL, type='source')
```
To configure the `gm` package.
```r
usethis::edit_r_environ()
```

Add the line `MUSESCORE_PATH=/usr/bin/mscore` to `/root/.Renviron` file. To exit use `:wq` at VI. Save and restart the R/RStudio session.


### 10. [Miniconda](https://docs.conda.io/en/latest/miniconda.html)
Miniconda is a free minimal installer for [conda](https://docs.conda.io/), an open source package, dependency and environment management system for any language—Python, R, Ruby, Lua, Scala, Java, JavaScript, C/ C++, FORTRAN and more, that runs on Windows, macOS and Linux.   
Follow the instructions at https://docs.conda.io/en/latest/miniconda.html. 

At terminal:  
```bash
cd ~/Downloads/
wget -r -np -k https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
cd repo.anaconda.com/miniconda/
bash Miniconda3-latest-Linux-x86_64.sh
```
Do you accept the license terms? [yes|no] `yes`.

Miniconda3 will now be installed into this location: /home/user/miniconda3 [ENTER]

Do you wish the installer to initialize Miniconda3 by running conda init? `yes`.   
Close and reopen terminal. 

```bash
conda update -n base -c defaults conda
```

The following packages will be INSTALLED/REMOVED/UPDATED/DOWNGRADED:... Proceed ([y]/n)? `y` 

```bash
conda create -n pyvoice38 python=3.8
```

The following (NEW) packages will be downloaded/INSTALLED:... Proceed ([y]/n)? `y`   

```bash
conda activate pyvoice38
pip3 install -r https://raw.githubusercontent.com/filipezabala/voice/master/requirements.txt
```


## MacOS Installation
The following steps were used to configure [github.com/filipezabala/voice](https://github.com/filipezabala/voice) on [MacOS Ventura](https://www.apple.com/macos/ventura/). Note the software versions during installation, inconsistency reporting is welcome.  
If the error "The package %@ is missing or invalid" appears during the upgrading from MacOS Catalina to Big Sur, press simultaneously `command + option + p + r` at restart. The processes may be accompanied using the keys `command + space 'Activity Monitor'`.    
> Without the following Python items 3 and 11, you may run all the functions except `poetry` and `extract_features_py`, that run respectively [pyannote-audio](https://github.com/pyannote/pyannote-audio) and [Parselmouth](https://github.com/YannickJadoul/Parselmouth).

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
echo 'export PATH="/usr/local/opt/python@3.8/bin:$PATH"' >> ~/.zshrc
python3 --version 
pip3 --version
```

### 4. [ffmpeg](https://ffmpeg.org/)
ffmpeg is a cross-platform solution to record, convert and stream audio and video. The installation may take several minutes.
```bash
brew install ffmpeg
```

### 5. [XQuartz](https://www.xquartz.org/)
The XQuartz project is an open-source effort to develop a version of the [X.Org X Window System](https://www.x.org/wiki/) that runs on macOS.

 . Download and run https://github.com/XQuartz/XQuartz/releases/download/XQuartz-2.8.1/XQuartz-2.8.1.dmg  
 . Will take 319.2 MB of disk space   
 . Send XQuartz-2.8.1.dmg to Trash    


### 6. [MacPorts](https://guide.macports.org/chunked/installing.macports.html)
You may prefer to proceed using the installer, see documentation.

```bash
wget https://github.com/macports/macports-base/releases/download/v2.7.2/MacPorts-2.7.2.tar.bz2
tar xjvf MacPorts-2.7.2.tar.bz2
cd MacPorts-2.7.2
cd ../; rm -rf MacPorts-2.7.2*
sudo nano /etc/paths
```
Add the following lines at the end of the file.
```bash
/opt/local/bin
/opt/local/sbin
```
Use Ctrl+O and return to save the file and Ctrl+X to cloe nano editor. Reboot your terminal.

### 7. [tcllib](https://ports.macports.org/port/tcllib/)

```bash
sudo port selfupdate && sudo port upgrade tcllib
sudo port install tcllib
```

### 7. [MuseScore](https://musescore.org/)
MuseScore is an open source notation software.  
 . Download and run https://musescore.org/en/download/musescore.dmg  
 . Drag MuseScore 3 to Applications folder   
 . Will take 314 MB of disk space   
 . Unmount MuseScore-3.6.2 virtual disk and send MuseScore-3.6.2.548020600.dmg to Trash   

### 8. [R](https://www.r-project.org)
R is a free software environment for statistical computing and graphics.  
 . Download and run https://cloud.r-project.org/bin/macosx/base/R-4.2.0.pkg   
 . Will take around 180 MB of disk space   
 . Send R-4.2.0.pkg to Trash   

### 9. [RStudio](https://posit.co/)
RStudio is an Integrated Development Environment (IDE) for R.  
 . Download and run https://download1.rstudio.org/desktop/macos/RStudio-2022.02.3-492.dmg  
 . Drag RStudio to Applications folder   
 . Will take around 770 MB of disk space   
 . Unmount RStudio virtual disk and send RStudio-2022.02.3-492.dmg to Trash   
 . Type `command + space 'rstudio'`   
 . Tools > Global Options... > Appearance > Merbivore (Restart required)   

### 10. R packages
"Packages are the fundamental units of reproducible R code." [Hadley Wickham and Jennifer Bryan](https://r-pkgs.org/). Type `command + space 'terminal'`   
```bash
sudo R
```

Running R as super user paste the following, row by row:
```r
ini <- Sys.time()
packs <- c('audio','BART','devtools','e1071','ellipse','foreach','ggfortify','RColorBrewer','reticulate','R.utils','seewave','tidyverse','tuneR','VIM','voice','wrassp')
install.packages(packs, dep = T); Sys.time()-ini
update.packages(ask = F); Sys.time()-ini
devtools::install_github('egenn/music'); Sys.time()-ini
devtools::install_github('flujoo/gm'); Sys.time()-ini
url <- 'http://www.rob-mcculloch.org/chm/nonlinvarsel_0.0.1.9001.tar.gz'
download.file(url, destfile = 'temp')
install.packages('temp', repos = NULL, type='source')
```

### 11. [Miniconda](https://docs.conda.io/en/latest/miniconda.html)
Miniconda is a free minimal installer for [conda](https://docs.conda.io/), an open source package, dependency and environment management system for any language—Python, R, Ruby, Lua, Scala, Java, JavaScript, C/ C++, FORTRAN and more, that runs on Windows, macOS and Linux.

```bash
cd ~/Downloads
wget -r -np -k https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh
cd repo.anaconda.com/miniconda/
bash Miniconda3-latest-MacOSX-x86_64.sh
```
Do you accept the license terms? [yes|no] `yes`.

Miniconda3 will now be installed into this location: /Users/[your_user]/miniconda3 [ENTER]

Do you wish the installer to initialize Miniconda3 by running conda init? `yes`.   

Close and reopen terminal.  

```bash
export PATH="~/miniconda3/bin:$PATH"
conda update -n base -c defaults conda
```

The following packages will be INSTALLED/REMOVED/UPDATED/DOWNGRADED:... Proceed ([y]/n)? `y` 

```bash
conda create -n pyvoice38 python=3.8
```
The following (NEW) packages will be downloaded/INSTALLED:... Proceed ([y]/n)? `y`   

Close and reopen terminal.

```bash
conda activate pyvoice38
pip3 install -r https://raw.githubusercontent.com/filipezabala/voice/master/requirements.txt
```

# voice
