# `voice`

General tools for voice analysis. 

The `voice` package is being developed to be an easy-to-use set of tools to deal with audio analysis in R. It provides a free and user-friendly toolkit for audio analysis, enabling researchers to extract, tag, and analyze voice data efficiently. It supports the extraction of audio features, enrichment of structured datasets with audio summaries, and automatic identification of spoken segments—while introducing novel features. It also allows audio analysis based on musical theory, associating frequencies with musical notes arranged in a score via [`gm`](https://github.com/flujoo/gm) package. 

The package has been tested extensively since 2019, including:

- Real-world applications: Dozens of uses, e.g. sex prediction from voice features and speaker diarization in audiobooks.
- Validation: Successful tests on open datasets and LibriVox recordings.

If you want to contribute, report bugs or request new features, use the 'Issues' tab on Github.


## 0. Basic installation
```{r, eval=FALSE}
# Development version from GitHub
install.packages(c('devtools','tidyverse'))
devtools::install_github('filipezabala/voice')

# Stable version from CRAN
install.packages('voice')
```

If you wish to perform a full installation, proceed to Section 4.


### 0.1 For Windows Users
If you're compiling R packages from source, you may need to install [RTools](https://cran.r-project.org/bin/windows/Rtools/), a collection of Windows-specific build tools for R.

### 0.2 For macOS Users
If you're compiling packages, ensure you have [Xcode Command Line Tools](https://mac.install.guide/commandlinetools/) installed. You also may need [macOS tools](https://cran.r-project.org/bin/macosx/tools/).

```{bash, eval=FALSE}
# Install Xcode on MacOS
xcode-select --install
```
More details may be found at https://filipezabala.com/voicegnette/.

## 1. Extract features
### 1.1 Load packages and audio files
```{r, message=FALSE, warning=FALSE}
# packs
library(voice)
library(tidyverse)

# get path to audio file
wavDir <- list.files(system.file('extdata', package = 'wrassp'),
                     pattern = glob2rx('*.wav'), full.names = TRUE)
```

### 1.2 Extract features
```{r, message=FALSE, warning=FALSE}
# minimal usage
M <- voice::extract_features(wavDir)
glimpse(M)
```


## 2. Tag
```{r, message=FALSE, warning=FALSE}
# creating Extended synthetic data
E <- dplyr::tibble(subject_id = c(1,1,1,2,2,2,3,3,3), wav_path = wavDir)
E

# minimal usage
voice::tag(E)

# canonical data
voice::tag(E, groupBy = 'subject_id')
```


## 3. Visualization
### 3.1 Get audio
```{r, message=FALSE, warning=FALSE}
url0 <- 'https://github.com/filipezabala/voiceAudios/raw/refs/heads/main/wav/doremi.wav'
download.file(url0, paste0(tempdir(), '/doremi.wav'), mode = 'wb')
```

You may use the command `voice::embed_audio(url0)` if you wish to show a play 
button when compiling an .Rmd file. See https://github.com/mccarthy-m-g/embedr 
for more details about `embed_audio()` related functions.


### 3.2 Media data
```{r, message=FALSE, warning=FALSE}
M <- voice::extract_features(tempdir())
summary(M)
```

### 3.3 Plot
```{r, message=FALSE, warning=FALSE, fig.width=7.5, fig.height=4}
voice::piano_plot(M, 0) # f0
voice::piano_plot(M, 0:1) # f0 + f1
```

### 3.4 Assign notes
```{r, message=FALSE, warning=FALSE}
(f0_spn <- voice::assign_notes(M, fmt = 0, min_points = 22, min_percentile = .85)) # f0
(f1_spn <- voice::assign_notes(M, fmt = 1, min_points = 22, min_percentile = .85)) # f1
```

### 3.5 Sheet music
Must have [MuseScore](https://musescore.org/en) and [gm](https://flujoo.github.io/gm/articles/gm.html).

#### 3.5.1 Notes sequence of f0
```{r, message=FALSE, warning=FALSE}
library(gm)
line_0 <- gm::Line(as.character(f0_spn))
m0 <- gm::Music() +
  gm::Meter(4, 4) +
  line_0
gm::show(m0, to = c('score', 'audio'))
```


#### 3.5.2 Notes sequences of f0 and f1
```{r, message=FALSE, warning=FALSE}
line_0 <- gm::Line(as.character(f0_spn))
line_1 <- gm::Line(as.character(f1_spn))
m1 <- gm::Music() +
  gm::Meter(4, 4) +
  line_0 + line_1
gm::show(m1, to = c('score', 'audio'))
```

<!-- #### 3.6.3 Chords sequence using f0, f1 and f2  -->
<!-- ```{r, message=FALSE, warning=FALSE} -->
<!-- line_0 <- gm::Line(as.character(f0_spn)) -->
<!-- line_1 <- gm::Line(as.character(f1_spn)) -->
<!-- line_2 <- gm::Line(as.character(f2_spn)) -->
<!-- m2 <- gm::Music() +  -->
<!--   gm::Meter(4, 4) +  -->
<!--   line_0 + line_1 + line_2 -->
<!-- gm::show(m2, to = c('score', 'audio')) -->
<!-- ``` -->


## 4. Advanced installation
Python-based functions `diarize` and `extract_features` (when the latter is inferring `f0_praat` and `fmt_praat` features) require a configured Python environment.

### 4.1 Ubuntu
The following steps are used to fully configure `voice` on [Ubuntu 24.04 LTS (Noble Numbat)](https://ubuntu.com/blog/tag/ubuntu-24-04-lts). Reports of inconsistencies are welcome.

<!-- > Without the following Python items 3 and 10, you may run all the functions except `diarize` and `extract_features` calling `f0_praat` and `fmt_praat` features. These functions run respectively [pyannote-audio](https://github.com/pyannote/pyannote-audio) and [Parselmouth](https://github.com/YannickJadoul/Parselmouth). -->

#### 4.1.1. [Curl](https://curl.se/)
Command line tool and library for transferring data with URLs.
```bash
# installing dependencies
sudo apt-get update
sudo apt-get install -y libssl-dev autoconf libtool make
# installing curl
sudo apt install curl
# verify installation
curl --version
```

<!-- #### 4.1.2. [Git](https://git-scm.com/) -->
<!-- Git is a free and open source distributed version control system. -->
<!-- ```bash -->
<!-- sudo apt-get update -->
<!-- sudo apt-get install git-all -->
<!-- ``` -->

<!-- #### 4.1.3. [pip](https://pypi.org/project/pip/) -->
<!-- pip is the package installer for Python.  -->
<!-- ```bash -->
<!-- sudo apt-get update -->
<!-- sudo apt-get install python3-pip -->
<!-- pip3 --version -->
<!-- ``` -->

#### 4.1.2. [ffmpeg](https://ffmpeg.org/)
ffmpeg is a cross-platform solution to record, convert and stream audio and video.
```bash
sudo apt-get update
sudo apt-get install ffmpeg
```

#### 4.1.3. Audio drivers and extra packages
```bash
sudo apt-get update
sudo apt-get install portaudio19-dev libasound2-dev libfontconfig1-dev libmagick++-dev libxml2-dev libharfbuzz-dev libfribidi-dev libgdal-dev cmake cmake-doc ninja-build
```

#### 4.1.4. [MuseScore](https://musescore.org/)
MuseScore is an open source notation software.

```bash
sudo add-apt-repository ppa:mscore-ubuntu/mscore-stable
sudo apt-get update
sudo apt-get install musescore
```

#### 4.1.5. [R](https://www.r-project.org)
R is a free software environment for statistical computing and graphics. To find out your Ubuntu distribution use `lsb_release -a` at terminal.    
```bash
sudo sh -c 'echo "deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/" >> /etc/apt/sources.list.d/cran.list'
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9 
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 51716619E084DAB9
gpg -a --export E084DAB9 | sudo apt-key add -

sudo add-apt-repository ppa:c2d4u.team/c2d4u4.0+

sudo apt-get update && sudo apt-get upgrade
sudo apt-get install r-base r-base-dev
```

#### 4.1.6. [RStudio](https://posit.co/download/rstudio-desktop/)
RStudio is an Integrated Development Environment (IDE) for R. Check for updates [here](https://posit.co/download/rstudio-desktop/).
```bash
sudo apt-get update
sudo apt-get install gdebi-core
wget https://download1.rstudio.org/electron/jammy/amd64/rstudio-2025.05.0-496-amd64.deb
sudo gdebi rstudio-2025.05.0-496-amd64.deb
```

#### 4.1.9. R packages
"Packages are the fundamental units of reproducible R code." [Hadley Wickham and Jennifer Bryan](https://r-pkgs.org/). The installation may take several minutes. At terminal run:
```bash
sudo R
```

Running R as super user paste the following, row by row:
```r
packs <- c('audio','reticulate','R.utils','seewave','tidyverse','tuneR','wrassp')
install.packages(packs, dep = TRUE)
update.packages(ask = FALSE)
devtools::install_github('egenn/music')
devtools::install_github('flujoo/gm')
```
To configure the `gm` package.
```r
usethis::edit_r_environ()
```

Add the line `MUSESCORE_PATH=/usr/bin/mscore` to `/root/.Renviron` file. To exit use `:wq` at VI. Save and restart the R/RStudio session.


#### 4.1.10. [Miniconda](https://docs.conda.io/en/latest/miniconda.html)
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

You can undo this by running `conda init --reverse $SHELL`? `yes`

Do you wish the installer to initialize Miniconda3 by running conda init? `yes`.

Close and reopen terminal.

```bash
conda update -n base -c defaults conda
```

The following packages will be INSTALLED/REMOVED/UPDATED/DOWNGRADED:... Proceed ([y]/n)? `y`

```bash
conda create -n pyvoice python=3.12
```

The following (NEW) packages will be downloaded/INSTALLED:... Proceed ([y]/n)? `y`

```bash
conda activate pyvoice
pip install -r https://raw.githubusercontent.com/filipezabala/voice/master/requirements.txt
```


### 4.2 MacOS
The following steps are used to fully configure `voice` on [MacOS Sonoma](https://www.apple.com/macos/macos-sequoia/) (Link to MacOS Sequoia). Reports of inconsistencies are welcome.

<!-- Hardware   -->
<!--  . MacBook Air (13-inch, 2020)   -->
<!--  . Chip Apple M1 -->
<!--  . Memory 8GB LPDDR4 -->

#### 4.2.1. [Homebrew](https://brew.sh/)
Install Homebrew, 'The Missing Package Manager for macOS (or Linux)' and remember to `brew doctor` eventually. At terminal (`command + space 'terminal'`) run:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

#### 4.2.2. [wget](https://www.gnu.org/software/wget/)
GNU Wget is a free software package for retrieving files using HTTP, HTTPS, FTP and FTPS, the most widely used Internet protocols. It is a non-interactive commandline tool, so it may easily be called from scripts, cron jobs, terminals without X-Windows support, etc.
```bash
brew install wget
```

#### 4.2.3. [Python](https://www.python.org/)
Python is a programming language that integrate systems. According to [this](https://github.com/Homebrew/homebrew-core/issues/62911) post, it is recommended to install Python 3.8 and 3.9 and make it consistent.
```bash
brew install python@3.12
python3 --version 
pip3 --version
```

#### 4.2.4. [ffmpeg](https://ffmpeg.org/)
ffmpeg is a cross-platform solution to record, convert and stream audio and video. The installation may take several minutes.
```bash
brew install ffmpeg
```

#### 4.2.5. [XQuartz](https://www.xquartz.org/)
The XQuartz project is an open-source effort to develop a version of the [X.Org X Window System](https://www.x.org/wiki/) that runs on macOS.

 - Download and run https://github.com/XQuartz/XQuartz/releases/download/XQuartz-2.8.5/XQuartz-2.8.5.pkg
 - Will take around 320 MB of disk space   
 - Send XQuartz-2.8.5.dmg to Trash    


#### 4.2.6. [MacPorts](https://guide.macports.org/chunked/installing.macports.html)
Follow the instructions from https://guide.macports.org/chunked/installing.macports.html.

<!-- ```bash -->
<!-- curl -O https://distfiles.macports.org/MacPorts/MacPorts-2.10.7.tar.bz2 -->
<!-- tar xf MacPorts-2.10.7.tar.bz2 -->
<!-- cd MacPorts-2.10.7 -->
<!-- ./configure -->
<!-- make -->
<!-- sudo make install -->
<!-- cd ../; rm -rf MacPorts-2.10.7* -->
<!-- sudo nano /etc/paths -->
<!-- ``` -->
<!-- Add the following lines at the end of the file. -->
<!-- ```bash -->
<!-- /opt/local/bin -->
<!-- /opt/local/sbin -->
<!-- ``` -->
<!-- Use Ctrl+O and return to save the file and Ctrl+X to close nano editor. Reboot your terminal and use -->
<!-- ```bash -->
<!-- sudo port -v selfupdate -->
<!-- sudo port upgrade outdated -->
<!-- ``` -->

#### 4.2.7. [tcllib](https://ports.macports.org/port/tcllib/)

```bash
sudo port selfupdate && sudo port upgrade tcllib
sudo port install tcllib
```

#### 4.2.8. [MuseScore](https://musescore.org/)
MuseScore is an open source notation software.

 - Download and run https://musescore.org/en/download/musescore.dmg  
 - Drag MuseScore 4 to Applications folder   
 - Will take around 320 MB of disk space   
 - Unmount MuseScore-4.5.2 virtual disk and send MuseScore-Studio-4.5.2.251141402.dmg to Trash   


#### 4.2.9. [R](https://www.r-project.org)
R is a free software environment for statistical computing and graphics.  

 - Download and run the pkg file according to you architecture from https://cloud.r-project.org/bin/macosx/
 - Will take around 180 MB of disk space   


#### 4.2.10. [RStudio](https://posit.co/download/rstudio-desktop/)
RStudio is an Integrated Development Environment (IDE) for R.

 - Download and run https://download1.rstudio.org/electron/macos/RStudio-2025.05.0-496.dmg
 - Drag RStudio to Applications folder   
 - Will take around 770 MB of disk space   
 - Unmount RStudio virtual disk and send RStudio-2025.05.0-496.dmg to Trash   
 - Type `command + space 'rstudio'`   
 - Tools > Global Options... > Appearance > Merbivore (Restart required)   


#### 4.2.11. R packages
"Packages are the fundamental units of reproducible R code." [Hadley Wickham and Jennifer Bryan](https://r-pkgs.org/). Type `command + space 'terminal'`   
```bash
sudo R
```

Running R as super user paste the following, one line at a time.
```r
packs <- c('audio','reticulate','R.utils','seewave','tidyverse','tuneR','wrassp')
install.packages(packs, dep = TRUE)
update.packages(ask = FALSE)
devtools::install_github('egenn/music')
devtools::install_github('flujoo/gm')
```

#### 4.2.12. [Miniconda](https://docs.conda.io/en/latest/miniconda.html)
Miniconda is a free minimal installer for [conda](https://docs.conda.io/), an open source package, dependency and environment management system for any language—Python, R, Ruby, Lua, Scala, Java, JavaScript, C/ C++, FORTRAN and more, that runs on Windows, macOS and Linux. 

For 64-bit version use

```bash
cd ~/Downloads
wget -r -np -k https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh
cd repo.anaconda.com/miniconda/
bash Miniconda3-latest-MacOSX-x86_64.sh
```

For M1 version use

```bash
cd ~/Downloads
wget -r -np -k https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh
cd repo.anaconda.com/miniconda/
bash Miniconda3-latest-MacOSX-arm64.sh
```

In order to continue the installation process, please review the license
agreement. Please, press ENTER to continue `ENTER`.

You can undo this by running `conda init --reverse $SHELL`? `yes`

Close and reopen terminal.

```bash
export PATH="~/miniconda3/bin:$PATH"
conda update -n base -c defaults conda
```

The following packages will be INSTALLED/REMOVED/UPDATED/DOWNGRADED:... Proceed ([y]/n)? `y`

```bash
conda create -n pyvoice python=3.12
```
The following (NEW) packages will be downloaded/INSTALLED:... Proceed ([y]/n)? `y`

Close and reopen terminal.

```bash
conda activate base
conda activate pyvoice
pip install -r https://raw.githubusercontent.com/filipezabala/voice/master/requirements.txt
```

## 5. Diarize

```{r}
# download
url0 <- 'https://github.com/filipezabala/voiceAudios/raw/main/wav/sherlock0.wav'
wavDir <- normalizePath(tempdir())
download.file(url0, paste0(wavDir, '/sherlock0.wav'), mode = 'wb')
```
Diarization can be performed to detect speaker segments (i.e., 'who spoke when').
```{r}
# diarize
voice::diarize(fromWav = wavDir, toRttm = wavDir, token = 'YOUR_TOKEN')
```

The `voice::diarize()` function creates Rich Transcription Time Marked (RTTM)[^rttm] files, space-delimited text files containing one turn per line defined by NIST - National Institute of Standards and Technology. The RTTM files can be read using `voice::read_rttm()`.

[^rttm]: See Appendix	C at https://www.nist.gov/system/files/documents/itl/iad/mig/KWS15-evalplan-v05.pdf.

```{r}
# read_rttm
(rttm <- voice::read_rttm(wavDir))
```

Finally, the audio waves can be automatically segmented.
```{r}
# split audio wave
voice::splitw(fromWav = wavDir, fromRttm = wavDir, to = wavDir)
dir(wavDir, pattern = '.[Ww][Aa][Vv]$')
```

