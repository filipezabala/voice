---
title: 'voice: A Comprehensive R Package for Audio Analysis'
tags:
- R
- Python
- voice
- mood
- emotion
date: "23 Jul 2025"
output: pdf_document
authors:
- name: Filipe Jaeger Zabala
  orcid: "0000-0002-5501-0877"
  equal-contrib: true
  affiliation: '1'
- name: Giovanni Abrahão Salum
  orcid: "0000-0002-7537-7289"
  equal-contrib: true
  affiliation: 1, 2
bibliography: paper.bib
affiliations:
- name: Graduate Program of Psychiatry and Behavioral Sciences, UFRGS, Brazil
  index: 1
  ror: 041yk2d64
- name: Child Mind Institute, New York, NY 10022, USA
  index: 2
  ror: 01bfgxw09
---

## Summary

The `voice` package [@zabala2025voice] for R [@r2024r] is a free, open-source 
toolkit designed to streamline audio analysis by integrating music theory and 
advanced computational techniques. It enables researchers to extract, summarize, 
and analyze voice data efficiently, supporting applications such as speech 
recognition, speaker identification, and mood inference. The package simplifies 
workflows through three core functions: `extract_features`, `tag`, and `diarize`. 
By bridging gaps in existing R tools, `voice` offers a unified solution for 
audio data analysis.

## Statement of Need

Tools like `reticulate` [@ushey2023reticulate] and `rpy2` [@gautier2025] enable 
interoperability between R and Python, allowing users to leverage external 
libraries for audio processing. While R provides foundational packages like 
tuneR and `tuneR` [@tuner2023ligges], `seewave` [@sueur2008seewave] and `wrassp` 
[@wrassp2024winkelmann], Python’s ecosystem (e.g., `Librosa` [@mcfee2015librosa],
`pyannote-audio` [@bredin2019pyannote]) is more extensive, as evidenced by the 
[Awesome Python Audio and Music](https://github.com/andreimatveyeu/awesome-python-audio) 
collection by [Andrei Matveyeu](https://github.com/andreimatveyeu). However, R’s
state-of-the-art time-series infrastructure ([CRAN Task View: Time Series Analysis](https://cran.r-project.org/web/views/TimeSeries.html)), 
offers unique advantages for analyzing audio signals as temporal data. Our
implementation combines these strengths, providing an R-centric workflow with 
optional Python integration for specialized tasks.

`voice` was designed with a user-friendly approach that makes it accessible to 
researchers in linguistics, psychology, and bioacoustics, where audio data 
remains underutilized. There are currently work fronts in these areas making use 
of `voice` functionalities. By simplifying the extraction and analysis of audio
features, the package lowers the barrier to entry for researchers and expands the 
potential for audio data in scientific studies.

## Features

### Core Functions

1. **`extract_features`**:  
   Extracts standardized audio features from files (e.g., *F0*, *Formant Dispersion*, *Gain*, *MFCC*), leveraging `wrassp` and `tuneR` while introducing new metrics to capture vocal tract characteristics.

2. **`tag`**:  
   Attaches summarized audio features to datasets, supporting anonymization and privacy-aware analysis via a *6-number summary* (mean, median, standard deviation, coefficient of variation, interquartile range and median absolute deviation).

3. **`diarize`**:  
   Identifies speaker segments using Python's `pyannote-audio` [@bredin2019pyannote], generating RTTM files for transcription and analysis.

### Novel Contributions

- **Formant Removals**:  
  Isolates fundamental frequency (F0) from formants, improving feature interpretability for classification tasks. 
  
- **Integration of R and Python**:  
  Uses `reticulate` [@ushey2023reticulate] to combine R's statistical power with Python's tools.

## Example Applications

### Predicting Sex from Voice
The package was tested on open datasets (AESDD [@vryzas2018speech; @vryzas2018subjective], CREMA-D [@cao2014crema], Mozilla Common Voice [@ardila2019common], RAVDESS [@livingstone2018ryerson] and VoxForge [@voxforge2023]) to predict sex from voice features. Results showed high accuracy across multiple model classes (Binary Logistic [@cramer2002origins], SVM [@vapnik2000nature], Random Forest [@breiman2001random], and BART [@sparapani2021nonparametric]), with formant removals ranking among the top predictive features.

### Speaker Diarization
The `diarize` function has been used successfully, and as a didactic example was applied to a LibriVox recording of [*The Adventures of Sherlock Holmes*](https://archive.org/details/adventuressherlockholmes_v4_1501_librivox) by Conan Doyle, successfully segmenting the audio into speaker turns. This demonstrates the package's utility for applications in transcription and audio analysis.

## Performance
The `voice` package efficiently processes audio files, with `extract_features` allowing parallelization and generating feature-rich data frames in seconds. The `diarize` function, while computationally intensive for long recordings, provides accurate segmentation and integrates seamlessly with R workflows.

## Availability
The `voice` package is available on CRAN ([https://CRAN.R-project.org/package=voice](https://CRAN.R-project.org/package=voice)) and GitHub ([https://github.com/filipezabala/voice](https://github.com/filipezabala/voice)). Documentation, including vignettes and examples, is provided to facilitate adoption.

## Acknowledgments
The authors gratefully acknowledge Renfei Mao for their technical support and guidance in implementing the `gm` library [@mao2025gm].

## References
 
