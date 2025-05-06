---
title: 'voice: A Comprehensive R Package for Audio Analysis'
tags:
  - R
  - Python
  - voice
  - mood
  - emotion
authors:
  - name: Filipe Jaeger Zabala
    orcid: 0000-0002-5501-0877
    equal-contrib: true
    affiliation: "1, 2"
  - name: Giovanni Abrahão Salum
    orcid: 0000-0002-7537-7289
    equal-contrib: true
    affiliation: "1, 3"
affiliations:
 - name: Graduate Program of Psychiatry and Behavioral Sciences, UFRGS, Brazil
   index: 1
   ror: 041yk2d64
 - name: Pontifical Catholic University of Rio Grande do Sul
   index: 2
   ror: 025vmq686
 - name: Child Mind Institute, New York, NY 10022, USA
   index: 3
   ror: 01bfgxw09  
date: 05 May 2025
bibliography: paper.bib
---

## Summary

The `voice` package [@zabala2025voice] for R [@r2024r] is a free, open-source toolkit designed to streamline audio analysis by integrating music theory and advanced computational techniques. It enables researchers to extract, tag, and analyze voice data efficiently, supporting applications such as speech recognition, speaker identification, and mood inference. The package simplifies workflows through three core functions: `extract_features`, `tag`, and `diarize`. By bridging gaps in existing tools like `wrassp` [@wrassp2024winkelmann] and `tuneR` [@tuner2023ligges], `voice` offers a unified solution for audio data analysis.

## Statement of Need

Audio data analysis is complex due to variability in file formats and the lack of integrated tools. While packages like `seewave` [@sueur2008seewave] provide foundational capabilities, they often require specialized knowledge. The `voice` package addresses these challenges by combining existing functionalities with novel features such as *Formant Removals*, which enhance predictive accuracy for tasks like sex classification. Its user-friendly design makes it accessible to researchers in linguistics, psychology, and bioacoustics, where audio data remains underutilized.

The package is particularly useful for researchers in fields such as linguistics, psychology, and bioacoustics, where audio data is underutilized due to the lack of accessible tools. By simplifying the extraction and analysis of audio features, `voice` lowers the barrier to entry for researchers and expands the potential for audio data in scientific studies.

## Features

### Core Functions

1. **`extract_features`**:  
   Extracts standardized audio features (e.g., *Formant Dispersion*, *Formant Position*) from files, leveraging `wrassp` and `tuneR` while introducing new metrics to capture vocal tract characteristics.

2. **`tag`**:  
   Attaches summarized audio features (mean, median, etc.) to datasets, supporting anonymization and privacy-aware analysis via a *6-number summary*.

3. **`diarize`**:  
   Identifies speaker segments using Python's `pyannote-audio` [@bredin2019pyannote], generating RTTM files for transcription and analysis.

### Novel Contributions

- **Formant Removals**:  
  Isolates fundamental frequency (F0) from formants, improving feature interpretability for classification tasks. 
  
- **Integration of R and Python**:  
  Uses `reticulate` [@ushey2023reticulate] to combine R's statistical power with Python's diarization tools.

## Example Applications

### Predicting Sex from Voice
The package was tested on open datasets (AESDD [@vryzas2018speech; @vryzas2018subjective], CREMA-D [@cao2014crema], Mozilla Common Voice [@ardila2019common], RAVDESS [@livingstone2018ryerson] and VoxForge [@voxforge2023]) to predict sex from voice features. Results showed high accuracy across multiple model classes (Binary Logistic [@cramer2002origins], SVM [@vapnik2000nature], Random Forest [@breiman2001random], and BART [@sparapani2021nonparametric]), with formant removals ranking among the top predictive features.

### Speaker Diarization
The `diarize` function was applied to a LibriVox recording of [*The Adventures of Sherlock Holmes*](https://archive.org/details/adventuressherlockholmes_v4_1501_librivox) by Conan Doyle, successfully segmenting the audio into speaker turns. This demonstrates the package's utility for applications in transcription and audio analysis.

## Performance
The `voice` package efficiently processes audio files, with `extract_features` generating feature-rich data frames in seconds for typical audio lengths. The `diarize` function, while computationally intensive for long recordings, provides accurate segmentation and integrates seamlessly with R workflows.

## Availability
The `voice` package is available on CRAN ([https://CRAN.R-project.org/package=voice](https://CRAN.R-project.org/package=voice)) and GitHub ([https://github.com/filipezabala/voice](https://github.com/filipezabala/voice)). Documentation, including vignettes and examples, is provided to facilitate adoption.

## Acknowledgments
The author acknowledges the contributions of the open-source communities behind `wrassp`, `tuneR`, `seewave`, and `pyannote-audio`, which form the foundation of this work. Special thanks to the developers of `reticulate` for enabling seamless R-Python integration.

## References
 
