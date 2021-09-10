# `voice`

<!-- badges: start -->
[![R build status](https://github.com/filipezabala/voice/workflows/R-CMD-check/badge.svg)](https://github.com/filipezabala/voice/actions?workflow=R-CMD-check)
<!-- badges: end -->

General tools for voice analysis. The `voice` package is being developed to be an easy-to-use set of tools to deal with audio analysis in R.  
It is based on [`tidyverse`](https://www.tidyverse.org/) collection, [`tuneR`](https://cran.r-project.org/web/packages/tuneR/index.html), [`wrassp`](https://cran.r-project.org/web/packages/wrassp/index.html), as well as [Parselmouth](https://github.com/YannickJadoul/Parselmouth) - a Python library for the [Praat](http://www.praat.org/) software - and [pyannote-audio](https://github.com/pyannote/pyannote-audio) - an open-source toolkit written in Python for speaker diarization based on [PyTorch](https://github.com/pytorch/pytorch) machine learning framework.   

A vignette may be found at http://filipezabala.com/voicegnette/.  

## MacOS Installation
The following steps were used to configure [github.com/filipezabala/voice](https://github.com/filipezabala/voice) on [MacOS Big Sur](https://www.apple.com/macos/big-sur/). Note the software versions during installation, inconsistency reporting is welcome.  
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

### 7. [MuseScore](https://musescore.org/)
MuseScore is an open source notation software.  
 . Download and run https://musescore.org/en/download/musescore.dmg  
 . Drag MuseScore 3 to Applications folder   
 . Will take 314 MB of disk space   
 . Unmount MuseScore-3.6.2 virtual disk and send MuseScore-3.6.2.548020600.dmg to Trash   

### 8. [R](https://www.r-project.org)
R is a free software environment for statistical computing and graphics.  
 . Download and run https://cloud.r-project.org/bin/macosx/base/R-4.1.0.pkg   
 . Will take 174.8 MB of disk space   
 . Send R-4.1.0.pkg to Trash   

### 9. [RStudio](https://www.rstudio.com/)
RStudio is an integrated development environment (IDE) for R.  
 . Download and run https://download1.rstudio.org/desktop/macos/RStudio-1.4.1717.dmg  
 . Drag RStudio to Applications folder   
 . Will take 768.4 MB of disk space   
 . Unmount RStudio virtual disk and send RStudio-1.4.1717.dmg to Trash   
 . Type `command + space 'rstudio'`   
 . Tools > Global Options... > Appearance > Merbivore (Restart required)   

### 10. [R packages](https://cran.r-project.org/web/packages/)
"Packages are the fundamental units of reproducible R code." [Hadley Wickham and Jennifer Bryan](https://r-pkgs.org/). Type `command + space 'terminal'`   
```bash
sudo R
```

Running R as super user paste the following, row by row:
```r
ini <- Sys.time()
packs <- c('devtools', 'e1071', 'ellipse', 'ggfortify', 'RColorBrewer', 'reticulate', 'R.utils', 'seewave', 'tidyverse', 'tuneR', 'VIM', 'wrassp')
install.packages(packs, dep = T); Sys.time()-ini
update.packages(ask = F); Sys.time()-ini
devtools::install_github('egenn/music'); Sys.time()-ini
devtools::install_github('filipezabala/voice', force = T); Sys.time()-ini
devtools::install_github('flujoo/gm'); Sys.time()-ini
```

### 11. [Miniconda](https://docs.conda.io/en/latest/miniconda.html)
Miniconda is a free minimal installer for [conda](https://docs.conda.io/), an open source package, dependency and environment management system for any language—Python, R, Ruby, Lua, Scala, Java, JavaScript, C/ C++, FORTRAN and more, that runs on Windows, macOS and Linux.

```bash
cd ~/Downloads
wget -r -np -k https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh
cd repo.anaconda.com/miniconda/
bash Miniconda3-latest-MacOSX-x86_64.sh
conda update -n base -c defaults conda
conda create -n pyvoice38 python=3.8
conda activate pyvoice38
pip3 install -r https://raw.githubusercontent.com/filipezabala/voice/master/requirements.txt
```


## Ubuntu Installation
The following steps were used to configure [github.com/filipezabala/voice](https://github.com/filipezabala/voice) on [Ubuntu 20.04 LTS (Focal Fossa)](https://releases.ubuntu.com/20.04/). Note the software versions during installation, inconsistency reporting is welcome.  
> Without the following Python items 3 and 12, you may run all the functions except `poetry` and `extract_features_py`, that run respectively [pyannote-audio](https://github.com/pyannote/pyannote-audio) and [Parselmouth](https://github.com/YannickJadoul/Parselmouth).

Hardware via `lspci`:    
 . 00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor Family DRAM Controller (rev 09)  
 . 00:01.0 PCI bridge: Intel Corporation Xeon E3-1200/2nd Generation Core Processor Family PCI Express Root Port (rev 09)  
 . 00:16.0 Communication controller: Intel Corporation 6 Series/C200 Series Chipset Family MEI Controller #1 (rev 04)  
 . 00:19.0 Ethernet controller: Intel Corporation 82579V Gigabit Network Connection (rev 05)  
 . 00:1a.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #2 (rev 05)  
 . 00:1b.0 Audio device: Intel Corporation 6 Series/C200 Series Chipset Family High Definition Audio Controller (rev 05)  
 . 00:1c.0 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 1 (rev b5)  
 . 00:1c.1 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 2 (rev b5)  
 . 00:1c.2 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 3 (rev b5)  
 . 00:1c.3 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 4 (rev b5)  
 . 00:1c.4 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 5 (rev b5)  
 . 00:1c.6 PCI bridge: Intel Corporation 82801 PCI Bridge (rev b5)  
 . 00:1c.7 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 8 (rev b5)  
 . 00:1d.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #1 (rev 05)  
 . 00:1f.0 ISA bridge: Intel Corporation P67 Express Chipset LPC Controller (rev 05)  
 . 00:1f.2 SATA controller: Intel Corporation 6 Series/C200 Series Chipset Family 6 port Desktop SATA AHCI Controller (rev 05)  
 . 00:1f.3 SMBus: Intel Corporation 6 Series/C200 Series Chipset Family SMBus Controller (rev 05)  
 . 01:00.0 VGA compatible controller: NVIDIA Corporation GK208B [GeForce GT 730] (rev a1)  
 . 01:00.1 Audio device: NVIDIA Corporation GK208 HDMI/DP Audio Controller (rev a1)  
 . 03:00.0 USB controller: NEC Corporation uPD720200 USB 3.0 Host Controller (rev 04)  
 . 05:00.0 SATA controller: JMicron Technology Corp. JMB362 SATA Controller (rev 10)  
 . 06:00.0 USB controller: NEC Corporation uPD720200 USB 3.0 Host Controller (rev 04)  
 . 07:00.0 PCI bridge: ASMedia Technology Inc. ASM1083/1085 PCIe to PCI Bridge (rev 01)  
 . 08:01.0 Multimedia controller: Philips Semiconductors SAA7130 Video Broadcast Decoder (rev 01)  
 . 08:02.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8110SC/8169SC Gigabit Ethernet (rev 10)  
 . 08:03.0 FireWire (IEEE 1394): VIA Technologies, Inc. VT6306/7/8 [Fire II(M)] IEEE 1394 OHCI Controller (rev c0)  
 . 09:00.0 SATA controller: Marvell Technology Group Ltd. 88SE9172 SATA 6Gb/s Controller (rev 11)  
 
### 1. [Homebrew](https://brew.sh/)
Install Homebrew, 'The Missing Package Manager for macOS (or Linux)' and remember to `brew doctor` eventually. At terminal run:
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
Python is a programming language that integrate systems.  
```bash
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install python3.8
python3 --version 
/home/linuxbrew/.linuxbrew/opt/python@3.9/bin/python3.9 -m pip install --upgrade pip
pip --version
```

### 4. [ffmpeg](http://ffmpeg.org/)
ffmpeg is a cross-platform solution to record, convert and stream audio and video. The installation may take several minutes.
```bash
brew install ffmpeg
```

### 5. Audio drivers
```bash
sudo apt-get install portaudio19-dev libasound2-dev
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

sudo apt update && sudo apt upgrade
sudo apt-get install r-base
sudo apt-get install r-base-dev
```

### 8. [RStudio](https://www.rstudio.com/)
RStudio is an integrated development environment (IDE) for R.  
```bash
sudo apt-get install gdebi-core
wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-1.4.1717-amd64.deb
sudo gdebi rstudio-server-1.4.1717-amd64.deb
```

### 9. [R packages](https://cran.r-project.org/web/packages/)
"Packages are the fundamental units of reproducible R code." [Hadley Wickham and Jennifer Bryan](https://r-pkgs.org/). At terminal run:
```bash
sudo R
```

Running R as super user paste the following, row by row:
```r
ini <- Sys.time()
packs <- c('audio', 'devtools', 'e1071', 'ellipse', 'ggfortify', 'gm', 'RColorBrewer', 'reticulate', 'R.utils', 'seewave', 'tidyverse', 'tuneR', 'VIM', 'wrassp')
install.packages(packs, dep = T); Sys.time()-ini
update.packages(ask = F); Sys.time()-ini
devtools::install_github('egenn/music'); Sys.time()-ini
devtools::install_github('filipezabala/voice', force = T); Sys.time()-ini
devtools::install_github('flujoo/gm'); Sys.time()-ini
```
To configure the `gm` package.
```r
usethis::edit_r_environ()
```

Add the line `MUSESCORE_PATH=/usr/bin/mscore` to `/root/.Renviron` file. Save and restart the R/RStudio session.


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
Do you wish the installer to initialize Miniconda3 by running conda init? `yes`.   
Close and reopen terminal. 

```bash
conda update -n base -c defaults conda
```

The following packages will be UPDATED/DOWNGRADED:... Proceed ([y]/n)? `y` 

```bash
conda create -n pyvoice38 python=3.8
```

The following (NEW) packages will be downloaded/INSTALLED:... Proceed ([y]/n)? `y`   
```bash
conda activate pyvoice38
pip install -r https://raw.githubusercontent.com/filipezabala/voice/master/requirements.txt
```

